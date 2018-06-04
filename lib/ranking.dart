import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  final List users;
  RankingPage(this.users);

  @override
  _RankingPageState createState() => new _RankingPageState(users);
}

class _RankingPageState extends State<RankingPage> {
  List users;
  _RankingPageState(this.users);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Ranking"),
      ),
      body: new ListView.builder(
          itemCount: users == null ? 0 : users.length,
          itemBuilder: (BuildContext context, int index){
            return new ListTile(
              title: new Text(users[index]["name"]),
              subtitle: new Text(users[index]["score"])
            );
          }
      ),
    );
  }
}