import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:flutter/material.dart";
import 'merchant_flex.dart';
import 'merchant_strict.dart';

class MerchantPage extends StatefulWidget {
  @override
  _MerchantPageState createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  String status;
  String type = "strict";

  @override
  initState() {
    print('init state was called');
    super.initState();
    _fetchSession();
  }

  @override
  Widget build(BuildContext context) {
    //return either a strict or flex control panel page
    if (type == "strict") {
      return MerchantStrict();
    } else if (type == "flex") {
      return MerchantFlex();
    }
  }

  Future<void> _fetchSession() async {
    print("Fetch SESSION IS RUNNING $status");
    try {
      var userData = await Amplify.Auth.getCurrentUser();
      //await _fetchType(userData.userId);
      setState(() {
        status = userData.userId;
      });
    } on AuthError catch (e) {
      print(e);
    }
  }

  // Future<void> _fetchType(data) async {
  //   print("Fetch TYPE IS RUNNING $data");
  //   try {
  //     var response = await http.get(
  //         'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/usercategory/$data');
  //     final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
  //     final type = jsonResponse['body'];
  //     print("THIS IS jsonresponse $jsonResponse");
  //     print("THIS IS TYPE $type");
  //     setState(() {
  //       userType = type["isCustomer"];
  //     });
  //   } on AuthError catch (e) {
  //     print(e);
  //   }
  // }
}
