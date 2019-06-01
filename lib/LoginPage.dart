import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class LoginState extends StatefulWidget {
  @override
  Login createState() => new Login();
}
class Login extends State<LoginState> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  static final email = TextEditingController();
  static final password = TextEditingController();
  String useremaile = email.text;
  String userpassword = password.text;
  String token;

  /*Future<String> getToken() async {
    String url = "http://192.168.31.22/api/auth/login";
    var response = await http.post(url, body: {"email":"npvarasada@hotmail.com","password":"Palioncorei3#"});
    setState(() {
      var extradata = json.decode(response.body);
      //token=extradata;
      print(extradata);
    });
  }*/
  @override
  void initState() {
    super.initState();

  }
  void showDialogSingleButton(
      BuildContext context, String title, String message, String buttonLabel) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text(buttonLabel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 400,
        margin: EdgeInsets.only(top: 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: RichText(
                  text: TextSpan(
                      // set the default style for the children TextSpans
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 30),
                      children: [
                    TextSpan(
                      text: 'forge',
                    ),
                    TextSpan(
                        text: 'base', style: TextStyle(color: Colors.blue)),
                  ])),
            )),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Welcome",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "Sign in to continue...",
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                  width: 300,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      SizedBox(height: 25.0),
                      TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 35.0,
            ),
            Container(
              width: 115,
              height: 35,
              margin: EdgeInsets.only(left: 20),
              child: RaisedButton(
                onPressed: () async {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Mainpage()));
                 // getToken();
                  showDialogSingleButton(context, "Token", token, "Done");
                },
                textColor: Colors.white,
                color: Color(0xFF42A5F5),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/login.png',
                      width: 20,
                      color: Colors.white,
                    ),
                    const Text('  SIGN IN', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
