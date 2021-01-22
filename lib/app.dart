import 'package:cafeexpress/screens/auth.dart';
import 'package:flutter/material.dart';
import 'screens/map_page.dart';
import 'screens/merchant_strict.dart';
import 'screens/merchant_flex.dart';
import 'screens/merchant_page.dart';
import 'wrapper.dart';
import 'screens/auth.dart';
import 'screens/detail_page.dart';
import 'screens/user_category_page.dart';
import 'screens/validation.dart';
import 'screens/merchant_profile_page.dart';
import 'screens/timer_page.dart';
import 'screens/merchant_calendar_page.dart';
import 'screens/qr_page.dart';
import 'screens/booking_list_page.dart';
import 'screens/booking_history_page.dart';
import 'screens/merchant_profile_setting_page.dart';
import 'screens/stripe.dart';
import 'services/stored_cards.dart';
import 'screens/PasswordReset.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'custom_drawer/navigation_home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const WrapperRoute = "/";
const AuthRoute = "/auth";
const MapSearchRoute = "/map_search";
const DetailRoute = "/detail";
const MerchantRoute = "/merchant_settings";
const MerchantFlexRoute = "/merchant_settings_flex";
const MerchantStrictRoute = "/merchant_settings_strict";
const UserCategoryRoute = "/user_category";
const ValidationRoute = "/validation";
const PasswordResetRoute = "/password_reset";
const MerchantProfileRoute = "/merchant_profile";
const MerchantCalendarRoute = "/merchant_calendar";
const TimerRoute = "/timer";
const QrRoute = "/qr";
const BookingListRoute = "/booking_list";
const BookingHistoryRoute = "/booking_history_route";
const MerchantProfileSettingRoute = "/merchant_profile_setting";
const StripeRoute = "/stripe";
const StoredCardsRoute = "/stored_cards";
const NavigateMerchantRoute = "/navigate_merchant";

final Color primaryColor = HexColor('#54D3C2');
final Color secondaryColor = HexColor('#54D3C2');
final ColorScheme colorScheme = const ColorScheme.light().copyWith(
  primary: primaryColor,
  secondary: secondaryColor,
);
final ThemeData base = ThemeData.light();

TextTheme _buildTextTheme(TextTheme base) {
  const String fontName = 'WorkSans';
  return base.copyWith(
    headline1: base.headline1.copyWith(fontFamily: fontName),
    headline2: base.headline2.copyWith(fontFamily: fontName),
    headline3: base.headline3.copyWith(fontFamily: fontName),
    headline4: base.headline4.copyWith(fontFamily: fontName),
    headline5: base.headline5.copyWith(fontFamily: fontName),
    headline6: base.headline6.copyWith(fontFamily: fontName),
    button: base.button.copyWith(fontFamily: fontName),
    caption: base.caption.copyWith(fontFamily: fontName),
    bodyText1: base.bodyText1.copyWith(fontFamily: fontName),
    bodyText2: base.bodyText2.copyWith(fontFamily: fontName),
    subtitle1: base.subtitle1.copyWith(fontFamily: fontName),
    subtitle2: base.subtitle2.copyWith(fontFamily: fontName),
    overline: base.overline.copyWith(fontFamily: fontName),
  );
}

class MyApp extends StatelessWidget {
  static init() {
    if (Amplify.Auth.getCurrentUser() != null) Amplify.Auth.signOut();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const locale = Locale("ja", "JP");
    return Theme(
        data: CafeExpressTheme.buildLightTheme(),
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: colorScheme,
            primaryColor: primaryColor,
            buttonColor: primaryColor,
            indicatorColor: Colors.white,
            splashColor: Colors.white24,
            splashFactory: InkRipple.splashFactory,
            selectedRowColor: HexColor('#FA7D82'),
            accentColor: secondaryColor,
            canvasColor: Colors.white,
            focusColor: const Color(0xFF3A5160),
            backgroundColor: const Color(0xFFFFFFFF),
            scaffoldBackgroundColor: const Color(0xFFF6F6F6),
            errorColor: const Color(0xFFB00020),
            buttonTheme: ButtonThemeData(
              colorScheme: colorScheme,
              textTheme: ButtonTextTheme.normal,
            ),
            fontFamily: 'NotoSansJP',
            // textTheme: _buildTextTheme(base.textTheme),
            // primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
            // accentTextTheme: _buildTextTheme(base.accentTextTheme),
          ),
          locale: locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            locale,
          ],
          debugShowCheckedModeBanner: false,
          onGenerateRoute: _routes(),
          home: Wrapper(),
        ));
  }

  RouteFactory _routes() {
    return (settings) {
      print(settings.arguments);
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case WrapperRoute:
          screen = Wrapper();
          break;
        case AuthRoute:
          screen = Auth();
          break;
        case MapSearchRoute:
          screen = MapPage();
          break;
        case DetailRoute:
          screen = DetailPage(arguments['id']);
          break;
        case MerchantRoute:
          screen = MerchantPage();
          break;
        case MerchantFlexRoute:
          screen = MerchantFlex();
          break;
        case MerchantStrictRoute:
          screen = MerchantStrict();
          break;
        case UserCategoryRoute:
          screen = UserCategoryPage();
          break;
        case ValidationRoute:
          screen = Validation(arguments['email'], arguments['passcode']);
          break;
        case PasswordResetRoute:
          screen = PasswordReset(arguments['email']);
          break;
        case MerchantProfileRoute:
          screen = MerchantProfilePage();
          break;
        case MerchantProfileSettingRoute:
          screen = MerchantProfileSettingPage();
          break;
        case MerchantCalendarRoute:
          screen = MerchantCalendarPage();
          break;
        case TimerRoute:
          // screen = TimerPage(arguments['shopData'], arguments['bookData']);
          screen = TimerPage();
          break;
        case QrRoute:
          screen = QrPage();
          break;
        case BookingListRoute:
          screen = BookingListPage();
          break;
        case StripeRoute:
          screen = StripePage(arguments['id'], arguments['price']);
          break;
        case StoredCardsRoute:
          screen = ExistingCardsPage();
          break;
        case BookingHistoryRoute:
          screen = BookingHistoryPage();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
