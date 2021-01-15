import 'package:flutter/material.dart';
import '../app.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:cafeexpress/global.dart' as globals;

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
        title: Text(
          "Cafe Express Control Panel",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Center(
        child: QrImage(
          data: shopID,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7),
            IconButton(
              icon: Icon(
                Icons.qr_code_rounded,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, QrRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_today_rounded,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, MerchantCalendarRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                size: 24.0,
                color: Theme.of(context).primaryColor,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, MerchantCalendarRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.assignment,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, BookingListRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () =>
                  {_changePage(context, MerchantProfileSettingRoute)},
            ),
            SizedBox(width: 7),
          ],
        ),
        color: Theme.of(context).primaryColor,
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 4.0,
        child: Icon(
          Icons.videogame_asset,
        ),
        onPressed: () => {_changePage(context, MerchantRoute)},
      ),
    );
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
