import 'package:Area_finder/providers/auth_provider.dart';
import 'package:Area_finder/sceens/routing%20Constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sceens/router.dart' as router;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isPreviousLogged = false;

  void getUserDetails(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String getUserName = pref.getString('userName');

    if (getUserName != null && getUserName.isNotEmpty) {
//      print('if statement: $isPreviousLogged');
      Navigator.pushReplacementNamed(context, LandingScreenRoute);
    } else {
//      print('else statement: $isPreviousLogged');
      Navigator.pushReplacementNamed(context, LoginScreenRoute);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("isPreviousLogged $isPreviousLogged");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "",
        // initialRoute: isPreviousLogged ? LandingScreenRoute : LoginScreenRoute,
        onGenerateRoute: router.generateRoute,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(0, 130, 128, 1.0),
          errorColor: Colors.red,
        ),
        home: StartingPage(getUserDetails),
      ),
    );
  }
}

class StartingPage extends StatelessWidget {
  final Function(BuildContext) getUserDetails;
  StartingPage(this.getUserDetails);

  @override
  Widget build(BuildContext context) {
    getUserDetails(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(25),
        child: Center(
          child: Image.asset('images/jaikisanlogo.png'),
        ),
      ),
    );
  }
}
