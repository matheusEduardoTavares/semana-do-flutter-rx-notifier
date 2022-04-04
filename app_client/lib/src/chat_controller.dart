import 'package:common/default_events.dart';
import 'package:flutter/widgets.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:common/common.dart';

class ChatController {
  late Socket socket;
  final String room;
  final String name;
  final listEvents = RxList<SocketEvent>([]);
  final textControler = TextEditingController(text: '');
  final focusNode = FocusNode();
  final scrollController = ScrollController();

  ChatController(this.room, this.name) {
    _init();
  }

  void _init() {
    socket = io(
      API_URL,
      OptionBuilder().setTransports(['websocket']).build(),
    );
    socket.connect();
    socket.onConnect((_) {
      socket.emit(DefaultEvents.enterRoom, {'room': room, 'name': name});
    });
    socket.on(DefaultEvents.sendMessage, (json) {
      final event = SocketEvent.fromJson(json);
      listEvents.add(event);

      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    });
  }

  void send() {
    final event = SocketEvent(
      name: name,
      room: room,
      text: textControler.text,
      type: SocketEventType.message,
    );
    listEvents.add(event);
    socket.emit(DefaultEvents.sendMessage, event.toJson());
    textControler.clear();
    focusNode.requestFocus();
  }

  void dispose() {
    socket.clearListeners();
    socket.onDisconnect((data) => null);
    socket.dispose();
    textControler.dispose();
    focusNode.dispose();
  }
}
