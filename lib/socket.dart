import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Socket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return new MaterialApp(
      title: title,
      home: new SocketPage(
        title: title,
        channel: new IOWebSocketChannel.connect('ws://10.15.16.240:8080/trivia/websocket?roomId=16'),
      ),
    );
  }
}

class SocketPage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  SocketPage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _SocketPageState createState() => new _SocketPageState();
}

class _SocketPageState extends State<SocketPage> {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Form(
              child: new TextFormField(
                controller: _controller,
                decoration: new InputDecoration(labelText: 'Send a message'),
              ),
            ),
            new StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: new Text(snapshot.hasData ? '${snapshot.data}' : ''),

                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _sendMessage,
        
        tooltip: 'Send message',
        child: new Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.channel.sink.add("{\"userId\":15, \"roomId\":16, \"joinReq\": true, \"answer\": \""
          + _controller.text + "\", " +
          "\"questionId\": 12}");
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}