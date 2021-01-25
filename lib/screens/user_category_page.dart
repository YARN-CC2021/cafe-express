import 'package:flutter/material.dart';
import '../app.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amplify_core/amplify_core.dart';
import '../global.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        body: Center(
            child: Column(children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child:
                  Text("ユーザーカテゴリーを選択してください", style: TextStyle(fontSize: 15))),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: ButtonTheme(
                  minWidth: 300,
                  height: 300,
                  child: RaisedButton.icon(
                      color: Colors.amberAccent,
                      onPressed: () {
                        _insertUserCategory(false);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      icon: IconButton(
                        icon: FaIcon(FontAwesomeIcons.store),
                        onPressed: () {},
                        iconSize: 70.0,
                      ),
                      label: Text("  飲食店の方", style: TextStyle(fontSize: 20))))),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: ButtonTheme(
                  minWidth: 300,
                  height: 300,
                  child: RaisedButton.icon(
                      color: Colors.indigoAccent,
                      onPressed: () {
                        _insertUserCategory(true);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      icon: IconButton(
                        icon: FaIcon(FontAwesomeIcons.userAlt),
                        onPressed: () {},
                        iconSize: 70.0,
                      ),
                      label: Text("一般の方", style: TextStyle(fontSize: 20))))),
        ])));
  }

  Future<dynamic> _insertUserCategory(bool isCustomer) async {
    var userData = await Amplify.Auth.getCurrentUser();
    var userId = userData.userId;
    var useremail = userData.username;
    globals.userId = userId;
    print("useId: $userId");
    print("username= ${userData.username}");
    print("user customer category= $isCustomer");
    var response = await http.post(
      "https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/user",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "id": userId,
        "isCustomer": isCustomer,
        "loginEmail": useremail,
        "createdAt": DateTime.now().toString()
      }),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("_insertUserCategory jsonResponse= $jsonResponse");
      isCustomer
          ? _changePage(context, MapSearchRoute)
          : _changePage(context, MerchantProfileRoute);
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _changePage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
    print("Going to $route was triggered");
  }
}
