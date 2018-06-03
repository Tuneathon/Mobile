import 'package:flutter/material.dart';

class GameQuestionPage extends StatefulWidget{
  @override
  _GameRoomQuestionState createState() => new _GameRoomQuestionState();
}

class _GameRoomQuestionState extends State<GameQuestionPage> with TickerProviderStateMixin{
  AnimationController _controller;
  static const int kStartValue = 30;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: kStartValue),
    );
    _controller.forward();
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
            new Text(
              "question 1"
            ),
            new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'Answer',
                  border: InputBorder.none),
            ),
            new RaisedButton(
              child: new Text('Save'),
              onPressed: (){
              },
            )
          ],
        ),
      )
    );
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