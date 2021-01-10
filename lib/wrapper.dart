import 'package:flutter/material.dart';
import 'screens/authenticate.dart';
import 'screens/map_page.dart';
import 'screens/merchant_page.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = "";
    final userType = 0;

    //return either home or authenticate
    if (userType == null) {
      return Authenticate();
    } else if (userType == 0) {
      return MapPage();
    } else {
      return MerchantPage();
    }
  }
}
