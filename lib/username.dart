import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

void showUsernameDialog(BuildContext context) async
{
    String username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.remove(usernameKey);
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