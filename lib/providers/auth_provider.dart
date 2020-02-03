import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails {
  String userId;
  String password;
  String firstName;
  String mobileNo;
  String profileKey;
  String profileImage;

  UserDetails({
    this.userId,
    this.password,
    this.firstName,
    this.mobileNo,
    this.profileKey,
    this.profileImage,
  });
}

class Auth with ChangeNotifier {
  // String _userId;
  // String _password;
  // String _firstName;
  // String _mobileNo;
  // String _profileKey;
  // String get userId {
  //   return _userId;
  // }
  // String get password {
  //   return _password;
  // }
  // String get firstName {
  //   return _firstName;
  // }
  // String get mobileNo {
  //   return _mobileNo;
  // }
  // String get profileKey {
  //   return _profileKey;
  // }

  UserDetails userDetails = UserDetails();
  // UserDetails get userdetails {
  //   return userDetails;
  // }
  void setUserDetailsLocal(String userName, String userId, String image) async {
//    print("##################");
//    print(userName+"',"+userId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);
    prefs.setString('userId', userId);
    prefs.setString('image', image);
  }


  Future<bool> login(String username, String password) async {
    bool loginSucceeded = true;
    print("login from provider:$username , $password");
    final url = 'https://kalgudi.com/rest/v1/profiles/mobilelogin';
    var isEmail = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    bool isValidEmail = isEmail.hasMatch(username);
    if (isValidEmail != true) {
      username = '+91$username';
    }
    // 9491018558
    // 12345678
    try {
      final response = await http.post(
        url,
        body: json.encode(
            {'userName': username, 'password': password, 'sessionId': ""}),
      );
      final responseData = json.decode(response.body);
      var userData = json.decode(responseData['data']);
      print("${response.statusCode} == ${HttpStatus.ok}");
      if (responseData['code'] == HttpStatus.ok) {
        print('===> logged-in');
        setUserDetailsLocal(userData['firstName'], userData['mobileNo'],
            userData['profilePicUrl']);
        userDetails.firstName = userData['firstName'];
        userDetails.mobileNo = userData['mobileNo'];
        userDetails.profileKey = userData['profileKey'];
        userDetails.password = password;
        userDetails.userId = username;
        userDetails.profileImage =  userData['profilePicUrl'];
        notifyListeners();
      }
    } catch (e, stacktrace) {
      print('error message: ${e.message} at: \n$stacktrace');
      loginSucceeded = false;
    }
    return loginSucceeded;
  }
}
