import 'dart:io';

import 'package:common/default_events.dart';
import 'package:socket_io/socket_io.dart';
import 'package:common/common.dart';

void main(List<String> arguments) {
  final server = Server();

  server.on(DefaultEvents.connection, (client) {
    onConnection(client);
  });

  server.listen(Platform.environment['PORT'] ?? 3100);
}

void onConnection(Socket socket) {
  socket.on(DefaultEvents.enterRoom, (data) {
    final dataFormatted = Map<String, dynamic>.from(data);

    final name = dataFormatted['name'];
    final room = dataFormatted['room'];

    socket.join(room);
    socket.to(room).broadcast.emit(
        DefaultEvents.sendMessage,
        SocketEvent(
          name: name,
          room: room,
          type: SocketEventType.enter_room,
        ).toJson());

    socket.on(DefaultEvents.disconnection, (data) {
      socket.to(room).broadcast.emit(
          DefaultEvents.sendMessage,
          SocketEvent(
            name: name,
            room: room,
            type: SocketEventType.leave_room,
          ).toJson());
    });

    socket.on(DefaultEvents.sendMessage, (json) {
      socket.to(room).broadcast.emit(DefaultEvents.sendMessage, json);
    });
  });
}
