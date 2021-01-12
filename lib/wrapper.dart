import 'package:flutter/material.dart';
import 'screens/auth.dart';
import 'screens/map_page.dart';
import 'screens/merchant_page.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    super.initState();
    _fetchSession();
    //_fetchType("e34771e7-07df-42e9-b49e-18d7ee4db9b6");
    //if (status != null) _fetchType(status);
  }

  @override
  Widget build(BuildContext context) {
    print("this is wrapper${status}");

    //return either a main page or an authentication page
    if (status == null) {
      return Auth();
    } else if (userType == true) {
      print("Fetch Session $status");
      print("Fetch UserType $userType");
      return MapPage();
    } else {
      print("Fetch Session $status");
      print("Fetch UserType $userType");
      return MerchantPage();
    }
  }

  void _fetchSession() async {
    print("Fetch SESSION IS RUNNING $status");
    try {
      var userData = await Amplify.Auth.getCurrentUser();
      await _fetchType(userData.userId);
      setState(() {
        status = userData.userId;
      });
    } on AuthError catch (e) {
      print(e);
    }
  }

  Future<void> _fetchType(data) async {
    print("Fetch TYPE IS RUNNING $data");
    try {
      var response = await http.get(
          'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/usercategory/$data');
      final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
      final type = jsonResponse['body'];
      print("THIS IS TYPE $type");
      setState(() {
        userType = type["isCustomer"];
      });
    } on AuthError catch (e) {
      print(e);
    }
  }
}
