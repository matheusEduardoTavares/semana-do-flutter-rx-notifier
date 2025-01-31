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
      _updateChatScroll();
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
    _updateChatScroll();
  }

  Future<void> _scrollToEnd() {
    return scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn
    );
  }

  void _updateChatScroll() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _scrollToEnd().then((_) {
        _scrollToEnd();
      });
    });
  }

  void dispose() {
    socket.clearListeners();
    socket.onDisconnect((data) => null);
    socket.dispose();
    textControler.dispose();
    focusNode.dispose();
  }
}
