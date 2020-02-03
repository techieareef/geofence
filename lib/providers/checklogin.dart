import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class checklogin extends StatefulWidget {
  @override
  _checkloginState createState() => _checkloginState();
}


class _checkloginState extends State<checklogin> {
  var name="";
  @override
  void initState() {
    super.initState();
    _autoLogIn();
  }

  _autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');
    print("##################"+userId);

    if (userId != null) {
      setState(() {
        name = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('im in');
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Text("hello world"+name),
      ),
    );
  }
}
