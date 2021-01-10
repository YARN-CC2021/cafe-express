import 'package:flutter/material.dart';
import 'screens/map_page.dart';
import 'screens/merchant_page.dart';
import 'wrapper.dart';

const MapSearchRoute = "/map_search";
const DetailRoute = "/detail";
const MerchantRoute = "/merchant_settings";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: _routes(), home: Wrapper());
  }

  RouteFactory _routes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case MapSearchRoute:
          screen = MapPage();
          break;
        case DetailRoute:
          screen = MapPage();
          break;
        case MerchantRoute:
          screen = MerchantPage();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
