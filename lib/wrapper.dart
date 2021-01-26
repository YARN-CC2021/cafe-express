import 'package:flutter/material.dart';
import 'screens/auth.dart';
import 'screens/map_page.dart';
import 'global.dart' as globals;
import 'custom_drawer/navigation_home_screen.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String status;

  @override
  initState() {
    status = globals.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return Auth();
    } else if (globals.isCustomer == true) {
      return MapPage();
    } else {
      return NavigationHomeScreen();
    }
  }
}
