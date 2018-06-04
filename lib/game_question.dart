import 'package:flutter/material.dart';
import 'services.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class GameQuestionPage extends StatefulWidget{
  final Room room;
  GameQuestionPage(this.room);
  @override
  _GameRoomQuestionState createState() => new _GameRoomQuestionState(room);
}

class Response {
  final String question;
  final int questionId;
  final String message;
  final List usersList;

  Response({this.question, this.questionId, this.message, this.usersList});

  factory Response.fromJson(Map<String, dynamic> json) {
    return new Response(
      question: json['question'],
      questionId: json['questionId'],
      message: json['message'],
      usersList: json['users'],
    );
  }
}

class Request {
  bool joinReq;
  String answer;
  int questionId;
  int userId;
  int roomId;

  Request({this.joinReq, this.answer, this.questionId, this.userId, this.roomId});

  Map<String, dynamic> toJson() =>
  {
      'joinReq': joinReq,
      'answer': answer,
      'questionId': questionId,
      'userId': userId,
      'roomId': roomId
  };

  factory Request.fromJson(Map<String, dynamic> json) {
    return new Request(
      joinReq: json['joinReq'],
      answer: json['answer'],
      questionId: json['questionId'],
      userId: json['userId'],
      roomId: json['roomId'],
    );
  }
}

class _GameRoomQuestionState extends State<GameQuestionPage> with TickerProviderStateMixin{
  Room room;
  _GameRoomQuestionState(this.room);
  AnimationController _controller;
  static const int kStartValue = 30;
  var socket;
  int questionId;
  TextEditingController _textController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    socket = new IOWebSocketChannel.connect('ws://10.15.16.240:8080/trivia/websocket?roomId=${room.roomId}');
    _sendMessage(true);
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: kStartValue),
    );
    //_controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Game Question"),
        ),
      body: new Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: new Countdown(
                animation: new StepTween(
                  begin: kStartValue,
                  end: 0,
                ).animate(_controller),
              ),
            ),
              new StreamBuilder(
              stream: socket.stream,
              builder: (context, snapshot) {
                String question = "";
                String message = "Welcome";
                if(snapshot.hasData){
                  Response tempResponse = Response.fromJson(json.decode(snapshot.data));
                  if (tempResponse.questionId != 0){
                    question = tempResponse.question;
                    questionId = tempResponse.questionId;
                    _controller.forward();
                    message = "";
                  }
                  else{
                    message = tempResponse.message;
                  }
                }
                return new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text(question),
                    new Text(message)
                  ]);
              },
            ),
            new Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: new TextField(
              controller: _textController,
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'Answer'),
            )),
            new RaisedButton(
              child: new Text('Save'),
              onPressed: (){
                _sendMessage(false);
                },
            )
          ],
        ),
      )
    );
  }

    void _sendMessage(bool joinReq) async {
      Request req = new Request();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      req.joinReq = joinReq;
      req.userId = prefs.getInt(userIdKey);
      req.roomId = this.room.roomId;
      req.answer = this._textController.text;
      req.questionId = this.questionId;

      socket.sink.add(json.encode(req));
  }
}


class Countdown extends AnimatedWidget {
  Countdown({ Key key, this.animation }) : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  build(BuildContext context){
    return new Text(
      animation.value.toString(),
      style: new TextStyle(fontSize: 50.0),
    );
  }
}