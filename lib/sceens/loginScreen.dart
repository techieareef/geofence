import 'dart:io';

import 'package:Area_finder/sceens/routing%20Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool checkLogin = true;
  String getUserName="";
  String image="";

  void setUserDetailsLocal(String userName, String userId, String image,String profileKey, String password) async {
//    print("##################");
//    print(userName+"',"+userId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);
    prefs.setString('userId', userId);
    prefs.setString('image', image);
    prefs.setString('profileKey', profileKey);
    prefs.setString('password', password);

  }

  void getUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    getUserName = pref.getString('userName');
    image = pref.getString('image');
//    print('user name from localStorage:\t $getUserName ====');
//    print('user image from localStorage:\t $image ====');
  }

  Future<void> _authenticate() async {
    String url = 'https://kalgudi.com/rest/v1/profiles/mobilelogin';
    String username = _usernameController.text;
    String password = _passwordController.text;
    var isEmail = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    bool isValidEmail = isEmail.hasMatch(username);
    if (isValidEmail != true) {
      username = '+91$username';
    }
    try {
      final response = await http.post(
        url,
        body: json.encode(
            {'userName': username, 'password': password, 'sessionId': ""}),
      );
      final responseData = json.decode(response.body);
      var userData = json.decode(responseData['data']);
      // print("@#@#@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      // print(userData);
      // print(userData['firstName']);
      // print(userData['mobileNo']);
      // print(userData['profilePicUrl']);
      // print(userData['profileKey']);
      // print(userData['password']);
      // print('############################');


      if (response.statusCode == HttpStatus.ok) {
        // print('login successful');
        setUserDetailsLocal(userData['firstName'], userData['mobileNo'],
            userData['profilePicUrl'],  userData['profileKey'],password);
        getUserDetails();
        Navigator.popAndPushNamed(context, LandingScreenRoute, arguments: {
          'firstName': userData['firstName'],
          'mobileNo': userData['mobileNo'],
        });
      }
    } catch (e) {
      setState(() {
        checkLogin = false;
      });
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry margin = EdgeInsets.only(left: 30, right: 30);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: Container(
                height: 200,
                width: 200,
                child: Image.asset('images/areameasure.png'),
              ),
            ),
            Container(
              margin: margin,
              child: TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black26,
                    ),
                    labelText: 'Phone | Email',
                    hintText: '(+91)'),
                controller: _usernameController,
              ),
            ),
            Container(
              margin: margin,
              child: TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black26,
                    ),
                    labelText: 'Password',
                    hintText: '**********'),
                controller: _passwordController,
                obscureText: true,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            checkLogin
                ? Container()
                : Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Invalid User Id or Password',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
            RaisedButton(
              color: Color.fromRGBO(0, 130, 128, 1.0),
              onPressed: _authenticate,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
