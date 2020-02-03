import 'package:Area_finder/sceens/appebarewid.dart';
import 'package:Area_finder/sceens/routing%20Constants.dart';
import 'package:Area_finder/sceens/sidemenu.dart';
import 'package:flutter/material.dart';

class Landingpage extends StatefulWidget {
  final String firstName;
  final String mobileNo;
  Landingpage({this.firstName, this.mobileNo});
  @override
  _LandingpageState createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          falg: false,
          ),
      body: Container(
        child: Material(
          color: Colors.transparent,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 120,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Image.asset(
                      'images/areameasure.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Click Start and walk around the boundaries.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, MapScreenRoute,
                        arguments: {
                          'firstName': widget.firstName,
                          'mobileNo': widget.mobileNo,
                        });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.teal[700],
                    child: Center(
                      child: Text(
                        "Start",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      endDrawer: Drawers(),
    );
  }
}
