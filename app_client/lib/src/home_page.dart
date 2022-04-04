import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = 'NoName';
  String room = 'any';
  final _controller = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(12),
        child: Form(
          key: _controller,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                onChanged: (value) => room = value,
                decoration: InputDecoration(labelText: 'Sala'),
                validator: Validatorless.required('Preencha a sala'),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) => name = value,
                decoration: InputDecoration(labelText: 'Seu nome'),
                validator: Validatorless.required('Preencha seu nome'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_controller.currentState?.validate() ?? false) {
                    Navigator.of(context).pushNamed('/chat', arguments: {
                      'room': room,
                      'name': name,
                    });
                  }
                },
                child: Text('Entrar na sala'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
