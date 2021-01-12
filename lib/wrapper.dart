import 'package:flutter/material.dart';
import 'screens/auth.dart';
import 'screens/map_page.dart';
import 'screens/merchant_page.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  dynamic status = false;
  dynamic userType = 1;

  @override
  initState() {
    print('init state was called');
    super.initState();
    // _fetchSession();
  }

  @override
  Widget build(BuildContext context) {
    print("this is wrapper${status}");

    //return either a main page or an authentication page
    if (!status) {
      return Auth();
    } else if (userType == 0) {
      return MapPage();
    } else {
      return MerchantPage();
    }
  }

  // void _fetchSession() async {
  //   print("Fetch SESSION IS RUNNING $status");
  //   // try {
  //   CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
  //       options: CognitoSessionOptions(getAWSCredentials: true));
  //   print("THE STATUS VARIABLE IS SET TO $res");

  //   setState(() {
  //     status = res;
  //   });
  // } on AuthError catch (e) {
  //   print(e);
  // }
  // }
}
