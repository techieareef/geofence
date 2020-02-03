import 'package:flutter/material.dart';

class MyAppBar extends PreferredSize {
  MyAppBar({Key key, Widget title, bool falg, IconButton leadingButton})
      : super(
          key: key,
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            automaticallyImplyLeading: falg,
            centerTitle: true,
            title: Text(
              "Geofence",
            ),
            backgroundColor: Colors.teal[700],
            leading: leadingButton,
          ),
        );
}
