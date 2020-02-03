import 'package:Area_finder/sceens/routing%20Constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
String username;
String contact;
String userimage;
String profilekey;
class Drawers extends StatefulWidget {
  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  @override
  void initState() {
    super.initState();
    _userdata();
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print("Logou***********************");
    print(prefs.getString('profileKey'));
    print(prefs.getString('userName'));
    Navigator.popAndPushNamed(context, LoginScreenRoute);
  }

  _userdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


   print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
   setState(() {
     username=prefs.getString("userName");
     contact=prefs.getString("userId");
     userimage=prefs.getString("image");
     profilekey=prefs.getString("profileKey");
     print(username);
     print(contact);
     print(prefs.getString("image"),);
     print(prefs.getString("profileKey"),);
   });

//    Navigator.popAndPushNamed(context, LoginScreenRoute);
  }
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        children: <Widget>[
          //header
          UserAccountsDrawerHeader(
            accountName: Text(username!=null?username:"User name"),
            accountEmail: Text(contact!=null?contact:"Contact"),
            currentAccountPicture: GestureDetector(
              child:CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage:userimage!=null?NetworkImage(userimage):NetworkImage(
                   "https://www.pngkey.com/png/full/270-2707230_i-am-a-founder-woman-user-icon.png"//                color: Colors.black,
              ),
              )
            ),
            decoration: BoxDecoration(color: Colors.teal[700]),
          ),
          InkWell(
            onTap: () {
              Navigator.popAndPushNamed(context, LandingScreenRoute);
            },
            child: ListTile(
              title: Text('Home Page'),
              leading: Icon(
                Icons.home,
                color: Colors.teal[700],
              ),
            ),
          ),
          Divider(
            // thickness: 1,
            color: Colors.teal[700],
            // height: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.popAndPushNamed(context, MapScreenRoute,
                  arguments: {
                    'firstName': username,
                    'mobileNo': contact,
                  });
            },
            child: ListTile(
              title: Text('Start Map'),
              leading: Icon(
                Icons.map,
                color: Colors.teal[700],
              ),
            ),
          ),
          Divider(
            // thickness: 1,
            color: Colors.teal[700],
            // height: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.popAndPushNamed(context, Viewmaps,arguments:{ 'profilekey':profilekey});
            },
            child: ListTile(
              title: Text('View Covered Areas'),
              leading: Icon(
                Icons.add_location,
                color: Colors.teal[700],
              ),
            ),
          ),
          Divider(
            // thickness: 1,
            color: Colors.teal[700],
            // height: 11,
          ),
          InkWell(
            onTap: _logout,
            child: ListTile(
              title: Text('Logout'),
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.teal[700],
              ),
            ),
          ),
          Divider(
            // thickness: 1,
            color: Colors.teal[700],
            // height: 11,
          ),
//            InkWell(
//              onTap: () {},
//              child: ListTile(
//                title: Text('Settings'),
//                leading: Icon(Icons.settings),
//              ),
//            ),
//            InkWell(
//              onTap: () {},
//              child: ListTile(
//                title: Text('About'),
//                leading: Icon(
//                  Icons.help,
//                  color: Colors.teal[700],
//                ),
//              ),
//            )
        ],
      ),
    );
  }
}
