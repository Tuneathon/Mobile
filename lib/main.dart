import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'create_room.dart';
import 'services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tuneathon',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Tuneathon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List rooms;

  Future getData() async {
    var response = await http.get(
        Uri.encodeFull("http://10.15.16.240:8080/room/getOpened"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      rooms = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    showUsernameDialog(context);
    getData();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: (){
              getData();
            },
          )
        ],
      ),
      body: new ListView.builder(
          itemCount: rooms == null ? 0 : rooms.length,
          itemBuilder: (BuildContext context, int index){
            return new Card(
              child: new Text(rooms[index]["name"]),
            );
          }
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) => new CreateRoomPage()),
          );
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
