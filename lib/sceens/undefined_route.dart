import 'package:flutter/material.dart';

class UndefinedView extends StatelessWidget {
  final String name;
  const UndefinedView({this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Route for $name is not defined'),
      ),
    );
  }
}
