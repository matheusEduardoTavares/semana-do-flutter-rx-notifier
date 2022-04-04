import 'package:app_client/src/chat_controller.dart';
import 'package:app_client/src/utils/images_path.dart';
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
      appBar: AppBar(
        title: Text('Sala: ${widget.room}'),
        centerTitle: true,
      ),
      extendBody: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                      image: AssetImage(ImagesPath.background),
                      fit: BoxFit.cover
                    )
                  ),
                  child: RxBuilder(builder: (_) {
                    return ListView.builder(
                      controller: _controller.scrollController,
                      itemCount: _controller.listEvents.length,
                      itemBuilder: (_, id) {
                        final event = _controller.listEvents[id];
      
                        final Widget child;
                        var color = Colors.black;
      
                        if (event.type == SocketEventType.enter_room) {
                          child = ListTile(
                            title: Text(
                              event.name,
                            ),
                            subtitle: Text('ENTROU NA SALA!'),
                          );
                          color = Theme.of(context).primaryColor;
                        } else if (event.type == SocketEventType.leave_room) {
                          child = ListTile(
                            title: Text(
                              event.name,
                            ),
                            subtitle: Text('SAIU DA SALA!'),
                          );
                          color = Colors.red;
                        }
                        else {
                          child = ListTile(
                            title: Text(event.name),
                            subtitle: Text(event.text),
                          );
                          color = Colors.white70;
                        }
      
                        return Card(
                          color: color,
                          child: child,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
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
          );
        }
      ),
    );
  }
}
