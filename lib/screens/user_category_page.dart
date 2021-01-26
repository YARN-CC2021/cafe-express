import 'package:flutter/material.dart';
import '../app.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amplify_core/amplify_core.dart';
import '../global.dart' as globals;
import '../app_theme.dart';

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
          leading: new Container(),
          title: Text("ユーザーカテゴリー",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          centerTitle: true,
          backgroundColor: CafeExpressTheme.buildLightTheme().backgroundColor,
          elevation: 3.0,
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("どちらかを選択してください", style: TextStyle(fontSize: 15))),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: CafeExpressTheme.nearlyWhite,
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: CafeExpressTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0),
                    child: Column(
                      children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '飲食店の方',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  letterSpacing: 0.27,
                                  color: CafeExpressTheme.darkText,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, right: 16, left: 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: CafeExpressTheme.grey
                                                .withOpacity(0.2),
                                            offset: const Offset(0.0, 0.0),
                                            blurRadius: 6.0),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        _insertUserCategory(false);
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        child: AspectRatio(
                                          aspectRatio: 1.28,
                                          child: Image.asset(
                                              "assets/images/store.jpeg"),
                                        ),
                                      ),
                                    ),
                                  ))),
                        ],
                      ),
                    ])),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: CafeExpressTheme.nearlyWhite,
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: CafeExpressTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0),
                    child: Column(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '一般の方',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  letterSpacing: 0.27,
                                  color: CafeExpressTheme.darkText,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, right: 16, left: 16),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: CafeExpressTheme.grey
                                                  .withOpacity(0.2),
                                              offset: const Offset(0.0, 0.0),
                                              blurRadius: 6.0),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          _insertUserCategory(true);
                                        },
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20.0)),
                                          child: AspectRatio(
                                            aspectRatio: 1.28,
                                            child: Image.asset(
                                                "assets/images/customer.jpeg"),
                                          ),
                                        ),
                                      )))),
                        ],
                      ),
                    ])),
              ),
            )
          ]),
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
