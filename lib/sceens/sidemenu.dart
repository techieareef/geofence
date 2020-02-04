import 'package:Area_finder/sceens/routing%20Constants.dart';
import 'package:flutter/cupertino.dart';
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
    print("Logout***********************");
    print(prefs.getString('profileKey'));
    print(prefs.getString('userName'));
    Navigator.popAndPushNamed(context, LoginScreenRoute);
  }

  _userdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


//   print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
   setState(() {
     username=prefs.getString("userName");
     contact=prefs.getString("userId");
     userimage=prefs.getString("image");
     profilekey=prefs.getString("profileKey");
//     print(username);
//     print(contact);
//     print(prefs.getString("image"),);
//     print(prefs.getString("profileKey"),);
   });

//    Navigator.popAndPushNamed(context, LoginScreenRoute);
  }
  @override
  Widget build(BuildContext context) {

    return Drawer(

      elevation: 5.0,
      child: ListView(
        children: <Widget>[
          //header
          Container(
            height:  MediaQuery.of(context).size.height*0.256,
            child: UserAccountsDrawerHeader(
              accountName: Text(username!=null?username:"User name" ,textAlign: TextAlign.start,style: TextStyle(fontSize: 17.0),),
//              accountEmail: Text(""),
              currentAccountPicture: GestureDetector(
                child:CircleAvatar(

                  backgroundColor: Colors.teal[700],
                  backgroundImage:userimage!=null?NetworkImage(userimage):NetworkImage(
                     "https://www.pngkey.com/png/full/270-2707230_i-am-a-founder-woman-user-icon.png"//                color: Colors.black,
                ),
                )
              ),
              decoration: new BoxDecoration(
                color: Colors.teal[700],
//                image: new DecorationImage(
//
////                    image:AssetImage("images/bg.jpg"),
//                    fit: BoxFit.cover
//                )
              ),
            ),
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
