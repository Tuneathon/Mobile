import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'game_room.dart';
import 'services.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => new _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final roomNameTextController = new TextEditingController();
  final numberOfPlayersTextController = new TextEditingController();

  List rooms;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("http://10.15.16.240:8080/room/getOpened"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      rooms = JSON.decode(response.body);
    });

    return "Success!";
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
    roomNameTextController.clear();
    numberOfPlayersTextController.clear();
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
                  hintText: 'Please enter room name'),
              controller: roomNameTextController,
            ),
            new TextField(
              decoration: new InputDecoration(
                  labelText: 'Number of players',
                  border: InputBorder.none,
                  hintText: 'Max(4)'),
              controller: numberOfPlayersTextController,
            ),
            new RaisedButton(
              child: new Text('Save'),
              onPressed: (){
                Future future = createRoom(context, roomNameTextController.text, 
                    numberOfPlayersTextController.text);
                future.then((roomId) {
                  int result = roomId as int;
                  if (result != null){
                    Room room;
                    room.roomId = result;
                    Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => new GameRoomPage(room)));
                  }
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
