import 'package:flutter/material.dart';
import 'screens/auth.dart';
import 'screens/map_page.dart';
import 'screens/merchant_page.dart';
import 'models/user_status.dart';
import 'package:provider/provider.dart';
import 'global.dart' as globals;

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final status = Provider.of<Status>(context);
    final userType = globals.test;
    print("this is wrapper${status.isSignedIn}");

    //return either a main page or an authentication page
    if (!status.isSignedIn) {
      return Auth();
    } else if (userType == 0) {
      return MapPage();
    } else {
      return MerchantPage();
    }
  }
}
