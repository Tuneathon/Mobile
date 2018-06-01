import 'package:flutter/material.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => new _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final roomNameTextController = new TextEditingController();
  final userNameTextController = new TextEditingController();
  final numberOfPlayersTextController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Create room"),
      ),
      body: new Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(
                  labelText: 'Room name',
                  border: InputBorder.none,
                  hintText: 'Please enter room name'
              ),
              controller: roomNameTextController,
            ),
            new TextField(
              decoration: new InputDecoration(
                  labelText: 'User name',
                  border: InputBorder.none,
                  hintText: 'Please enter your username'
              ),
              controller: userNameTextController,
            ),
            new TextField(
              decoration: new InputDecoration(
                  labelText: 'Number of players',
                  border: InputBorder.none,
                  hintText: 'Max(4)'
              ),
              controller: numberOfPlayersTextController,
            ),
            new RaisedButton(
              child: new Text('Save'),
              onPressed: (){
                return showDialog(
                  context: context,
                  builder: (context) {
                    return new AlertDialog(
                      // Retrieve the text the user has typed in using our
                      // TextEditingController
                      content: new Text(roomNameTextController.text),
                    );
                  },
                );
              },
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}