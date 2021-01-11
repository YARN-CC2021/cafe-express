import 'package:flutter/material.dart';
import '../app.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amplify_core/amplify_core.dart';

class UserCategoryPage extends StatefulWidget {
  @override
  _UserCategoryPageState createState() => _UserCategoryPageState();
}

class _UserCategoryPageState extends State<UserCategoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cafe Express"),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: Column(children: [
        Center(heightFactor: 10, child: Text("Which One Are You?")),
        Row(children: [
          Center(
              child: ButtonTheme(
                  minWidth: 200.0,
                  height: 100.0,
                  child: RaisedButton.icon(
                      onPressed: () {
                        // _goMerchant(context);
                        _insertUserCategory(false);
                      },
                      icon: Icon(Icons.local_restaurant),
                      label: Text("Establishment")))), //or storefront
          Center(
              child: ButtonTheme(
                  minWidth: 200.0,
                  height: 100.0,
                  child: RaisedButton.icon(
                      onPressed: () {
                        // _goMapSearch(context);
                        _insertUserCategory(true);
                      },
                      icon: Icon(Icons.switch_account),
                      label: Text("Customer")))),
        ])
      ] //
          ),
    );
  }

  Future<dynamic> _insertUserCategory(bool isCustomer) async {
    var userData = await Amplify.Auth.getCurrentUser();
    var userId = userData.userId;

    print("_insertUserCategory body= $userId, $isCustomer");
    var response = await http.post(
      "https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/usercategory",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': userId, "isCustomer": isCustomer}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("_insertUserCategory jsonResponse= $jsonResponse");
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _goMapSearch(BuildContext context) {
    Navigator.pushNamed(context, MapSearchRoute);
    print("goMapSearch was triggered");
  }

  void _goMerchant(BuildContext context) {
    Navigator.pushNamed(context, MerchantRoute);
    print("goMerchant was triggered");
  }
}
