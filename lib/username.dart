import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String usernameKey = "username";

void saveUsername(BuildContext context, String username) async {
  Navigator.pop(context);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(usernameKey, username);
}

void showUsernameDialog(BuildContext context) async
{
    String username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Bobbyprefs.remove(usernameKey);
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