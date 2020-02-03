import 'package:Area_finder/providers/checklogin.dart';
import 'package:Area_finder/sceens/routing%20Constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Auto Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isLoggedIn = false;
  String name = '';
  String password='';
  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');
    final String password = prefs.getString('password');
    final String mobileNo = prefs.getString('mobileNo');

    if (userId != null && password != null && mobileNo != null) {
      setState(() {
        isLoggedIn = true;
        name = userId;
        print('####################'+mobileNo==null?mobileNo:'hello');
        print('####################'+password);
      });
      return;
    }
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);

    setState(() {
      name = '';
      password='';
      isLoggedIn = false;
    });
  }

  Future<Null> loginUser() async {
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
      if (response.statusCode == HttpStatus.ok) {

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', _usernameController.text);
        prefs.setString('password', _passwordController.text);
        prefs.setString('userName', userData['firstName']);
        prefs.setString('userId', userData['mobileNo']);
        prefs.setString('image',  userData['profilePicUrl']);
        setState(() {
          name = _usernameController.text;
          password=_passwordController.text;
          isLoggedIn = true;
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => checklogin(),
            ));
//        Navigator.popAndPushNamed(context, LandingScreenRoute, arguments: {
//          'firstName': userData['firstName'],
//          'mobileNo': userData['mobileNo'],
//        });
      }else{
        print("*************************** unable to find the user details");
      }
    } catch (e) {
      setState(() {
        isLoggedIn = false;
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
          isLoggedIn
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
              onPressed: loginUser,
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