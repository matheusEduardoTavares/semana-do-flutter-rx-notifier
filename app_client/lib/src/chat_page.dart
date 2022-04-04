import 'package:app_client/src/chat_controller.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final String room;

  const ChatPage({Key? key, required this.name, required this.room}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChatController(widget.room, widget.name);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sala: ${widget.room}')),
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            RxBuilder(builder: (_) {
              return Expanded(
                child: ListView.builder(
                  controller: _controller.scrollController,
                  itemCount: _controller.listEvents.length,
                  itemBuilder: (_, id) {
                    final event = _controller.listEvents[id];

                    if (event.type == SocketEventType.enter_room) {
                      return ListTile(title: Text('${event.name} ENTROU NA SALA!'));
                    } else if (event.type == SocketEventType.leave_room) {
                      return ListTile(title: Text('${event.name} SAIU DA SALA!'));
                    }

                    return ListTile(
                      title: Text(event.name),
                      subtitle: Text(event.text),
                    );
                  },
                ),
              );
            }),
            TextField(
              focusNode: _controller.focusNode,
              onSubmitted: (_) => _controller.send(),
              controller: _controller.textControler,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite a mensagem',
                suffixIcon: IconButton(icon: Icon(Icons.send), onPressed: _controller.send),
              ),
            )
          ],
        ),
      ),
    );
  }
}
