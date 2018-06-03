import 'package:flutter/material.dart';

import 'dart:async';
import 'services.dart';
import 'game_question.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => new _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final roomNameTextController = new TextEditingController();
  String numberOfPlayers;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
    roomNameTextController.clear();
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
            new Center( 
              child: new TextField(
              decoration: new InputDecoration(
                  labelText: 'Room name',
                  border: InputBorder.none,
                  hintText: 'Please enter room name'),
              controller: roomNameTextController,
            )),
            new Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: new DropdownButton<String>(
                value: numberOfPlayers,
                items: <String>['2', '3', '4', '5', '6', '7', '8'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                hint: new Text("Number of players"),
                onChanged: (String newValue) {
                  setState(() {
                      numberOfPlayers = newValue;
                  });
                },
            )),
            new RaisedButton(
              child: new Text('Save'),
              onPressed: (){
                Future future = createRoom(context, roomNameTextController.text, 
                    numberOfPlayers);
                future.then((roomId) {
                    Room room = new Room();
                    room.roomId = roomId;
                    Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) => new GameQuestionPage(room)));
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
