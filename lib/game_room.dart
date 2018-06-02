import 'package:flutter/material.dart';
import 'services.dart';

class GameRoomPage extends StatefulWidget{
  Room room;
  GameRoomPage(this.room);
  @override
  _GameRoomPageState createState() => new _GameRoomPageState(room);
}

class _GameRoomPageState extends State<GameRoomPage>{
  Room room;
  _GameRoomPageState(this.room);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("GameRoom"),
        ),
      body: new ListView.builder(
        itemCount: room.userList.length,
        itemBuilder: (BuildContext context, int index){
          return new ListTile(
            title: new Text(room.userList[index]["name"]),
          );
        }
      )
    );
  }
}