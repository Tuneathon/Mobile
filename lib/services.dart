import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'game_question.dart';

class RoomResponse {
  final bool success;
  final int roomId;

  RoomResponse({this.success, this.roomId});
}

class Room {
  int roomId;
  String status;
  int maxPeople;
  int currentPeople;
  String roomName;
  String hostName;
  List userList;

  Room({this.roomId, this.status, this.maxPeople, this.currentPeople, this.roomName, this.hostName, this.userList});

  factory Room.fromJson(Map<String,dynamic> json){
    return new Room(
      roomId: json['id'],
      status: json['status'],
      maxPeople: json['maxPeople'],
      currentPeople: json['currentPeople'],
      roomName: json['name'],
      hostName: json['hostName'],
      userList: json['userList'],
    );
  }
}

class Question{
  int id;
  String question;
  String answer;

  Question({this.id, this.question, this.answer});

  factory Question.fromJson(Map<String,dynamic> json){
    return new Question(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}

final String usernameKey = "username";
final String userIdKey = "userId";

void saveUsername(BuildContext context, String username) async {
  Map<String, String> userMap = {"name": username};
  String userData = json.encode(userMap); 
  Map<String, String> lHeaders = {"Content-type": "application/json", 
    "Accept": "application/json"};
  final response = await http.post(
    'http://10.15.16.240:8080/user/create', body: userData, headers: lHeaders);
  if (response.statusCode == 200){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(usernameKey, username);
      await prefs.setInt(userIdKey, int.parse(response.body));
      Navigator.pop(context);
  }
}

Future<Room> joinRoom(BuildContext context, int roomId) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getInt(userIdKey).toString();
  final response = await http.post('http://10.15.16.240:8080/room/join?roomId=$roomId&userId=$userId');
  if(response.statusCode == 200){
    return Room.fromJson(json.decode(response.body));
  }
  return null;
}

Future<List<Question>> getQuestions(BuildContext context, int roomId) async {
  final response = await http.get('http://10.15.16.240:8080/room/getQuestions?roomId=$roomId');
  if(response.statusCode == 200){
    return json.decode(response.body);
  }
  return null;
}

Future<int> createRoom(BuildContext context, String roomName,
  String playersCount) async 
{
  Map<String, String> userMap = {"name": roomName, "maxPeople": playersCount};
  String userData = json.encode(userMap); 
  Map<String, String> lHeaders = {"Content-type": "application/json", 
    "Accept": "application/json"};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getInt(userIdKey).toString();
  final response = await http.post(
    'http://10.15.16.240:8080/room/create?userId=$userId', body: userData, 
    headers: lHeaders);
  if (response.statusCode == 200){
      return int.parse(response.body);
  }
  return null;
}



void showUsernameDialog(BuildContext context) async
{
    String username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.remove(usernameKey);a
    if (prefs.getString(usernameKey) == null){
      showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            content: new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'Username',
                  border: InputBorder.none
              ),
              onChanged: (String text) {
                username = text;
              },
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Create"),
                onPressed: () => saveUsername(context, username),
              ),
            ],
          );
        },
      );
    }
}