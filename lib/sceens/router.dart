import 'package:Area_finder/sceens/Viewdetails.dart';
import 'package:Area_finder/sceens/capturedArea.dart';
import 'package:Area_finder/sceens/landingpage.dart';
import 'package:Area_finder/sceens/loginScreen.dart';
import 'package:Area_finder/sceens/map_screen.dart';
import 'package:Area_finder/sceens/routing%20Constants.dart';
import 'package:Area_finder/sceens/splash_screen.dart';
import 'package:Area_finder/sceens/undefined_route.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreenRoute:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case LandingScreenRoute:
      return MaterialPageRoute(builder: (context) => Landingpage());
    case MapScreenRoute:
      var args = settings.arguments as Map<String, dynamic>;
      var firstName = args['firstName'];
      var mobileNo = args['mobileNo'];
      return MaterialPageRoute(
          builder: (context) => MapDetails(
                firstName: firstName,
                mobileNo: mobileNo,
              ));
    case LoginScreenRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());

    case CapturedAreaRoute:
      var args = settings.arguments as Map<String, dynamic>;
      var polyPoints = args['polyPoints'];
      var calculatedArea = args['calculatedArea'];
      var mobileNo = args['mobileNo'];
      var address = args['address'];
      var flag = args['flag'];
      return MaterialPageRoute(
          builder: (context) => CapturedArea(
                areaLatitudeLongitude: polyPoints,
                calculatedArea: double.parse(calculatedArea),
                address: address,
                flag: flag,
              ));
    case Viewmaps:
      var args = settings.arguments as Map<String, dynamic>;
      var profilekey = args['profilekey'];
      return MaterialPageRoute(builder: (context) => ViewMaps(
        profilekey: profilekey ,
      ));
    default:
      return MaterialPageRoute(
          builder: (context) => UndefinedView(name: settings.name));
  }
}
