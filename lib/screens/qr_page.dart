import 'package:flutter/material.dart';
import '../app.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:cafeexpress/global.dart' as globals;
import '../app_theme.dart';

class QrPage extends StatefulWidget {
  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  String shopID;
  String shopName;

  @override
  initState() {
    super.initState();
    if (globals.userId != null) {
      _fetchShopId();
    } else {
      shopID = globals.userId;
    }
  }

  @override
  Widget build(BuildContext context) {
    //return either a strict or flex control panel page
    return Scaffold(
        appBar: AppBar(
          leading: new Container(),
          title: Text("QRコード",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          centerTitle: true,
          backgroundColor: CafeExpressTheme.buildLightTheme().backgroundColor,
          elevation: 3.0,
        ),
        body: shopID != null || globals.userId == null
            ? Center(
                child: QrImage(
                  data: shopID,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }

  void _changePage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
    print("Going to $route was triggered");
  }

  Future<void> _fetchShopId() async {
    try {
      var userData = await Amplify.Auth.getCurrentUser();
      setState(() {
        shopID = userData.userId;
      });
    } on AuthError catch (e) {
      print(e);
    }
  }
}
