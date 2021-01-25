import 'package:flutter/material.dart';
import 'screens/auth.dart';
import 'screens/map_page.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'global.dart' as globals;
import 'custom_drawer/navigation_home_screen.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String status;
  bool userType = true;

  @override
  initState() {
    print('init state was called');
    print("Very beginning: ${globals.userId}");
    super.initState();
    _fetchSession();
  }

  @override
  Widget build(BuildContext context) {
    print("this is wrapper $status");

    if (status == null) {
      return Auth();
    } else if (userType == true) {
      print("Fetch UserType $userType");
      return MapPage();
    } else {
      print("Fetch UserType $userType");
      return NavigationHomeScreen();
    }
  }

  Future<void> _fetchSession() async {
    try {
      var userData = await Amplify.Auth.getCurrentUser();
      await _fetchType(userData.userId);
      setState(() {
        status = userData.userId;
        globals.userId = userData.userId;
      });
    } on AuthError catch (e) {
      print(e);
    }
  }

  Future<void> _fetchType(data) async {
    try {
      var response = await http.get(
          'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/usercategory/$data');
      final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
      final type = jsonResponse['body'];
      print("User is Customer: $type");
      setState(() {
        userType = type["isCustomer"];
      });
    } on AuthError catch (e) {
      print(e);
    }
  }
}
