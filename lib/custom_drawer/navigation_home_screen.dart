import '../screens/merchant_calendar_page.dart';
import '../screens/merchant_profile_setting_page.dart';
import '../screens/booking_list_page.dart';
import '../screens/merchant_strict.dart';
import '../screens/qr_page.dart';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'home_drawer.dart';
import 'drawer_user_controller.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.ControlePanel;
    screenView = MerchantStrict();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CafeExpressTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: CafeExpressTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.Profile) {
        setState(() {
          screenView = MerchantProfileSettingPage();
        });
      } else if (drawerIndex == DrawerIndex.BookingList) {
        setState(() {
          screenView = BookingListPage();
        });
      } else if (drawerIndex == DrawerIndex.Calendar) {
        setState(() {
          screenView = MerchantCalendarPage();
        });
      } else if (drawerIndex == DrawerIndex.ControlePanel) {
        setState(() {
          screenView = MerchantStrict();
        });
      } else if (drawerIndex == DrawerIndex.QRCode) {
        setState(() {
          screenView = QrPage();
        });
      } else {
        // any else case should come in here
      }
    }
  }
}
