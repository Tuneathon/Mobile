import 'package:flutter/material.dart';
import 'services.dart';
import 'dart:async';

class GameRoomPage extends StatefulWidget {
  final Room room;
  GameRoomPage(this.room);
  @override
  _GameRoomPageState createState() => new _GameRoomPageState(room);
}

class _GameRoomPageState extends State<GameRoomPage> {
  Room room;
  _GameRoomPageState(this.room);
  List questions;

  @override
  void initState() {
    super.initState();
    Future future = getQuestions(context, room.roomId);
    future.then(
      (questions){
        this.questions = questions as List;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("GameRoom"),
        ),
        body: new ListView.builder(
            itemCount: room.userList.length,
            itemBuilder: (BuildContext context, int index) {
              return new ListTile(
                title: new Text(room.userList[index]["name"]),
              );
            }));
  }
}
