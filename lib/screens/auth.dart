import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import '../amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import "package:flutter_login/flutter_login.dart";
import "../app.dart";

import "../models/user_status.dart";

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  Amplify amplify = Amplify();
  bool isConfigured = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Status isSignIn = Status();

  @override
  initState() {
    super.initState();
    if (!isConfigured) config();
  }

  void config() async {
    AmplifyAuthCognito amplifyAuthCognito = AmplifyAuthCognito();
    amplify.addPlugin(authPlugins: [amplifyAuthCognito]);
    amplify.configure(amplifyconfig);
    setState(() {
      isConfigured = true;
      print('Configuration is $isConfigured');
    });
    print("user signed in? ${isSignIn.isSignedIn}");
  }

  Future<String> signUp(LoginData data) async {
    Map<String, dynamic> userAttributes = {'email': emailController.text};
    SignUpResult result = await Amplify.Auth.signUp(
        username: data.name,
        password: data.password,
        options: CognitoSignUpOptions(userAttributes: userAttributes));
    if (result.isSignUpComplete) {
      print('Sign Up Complete');
    }
    return 'Sign up error';
  }

  Future<String> logIn(LoginData data) async {
    SignInResult result =
        await Amplify.Auth.signIn(username: data.name, password: data.password);
    try {
      if (result.isSignedIn) {
        print(isSignIn.isSignedIn);
        setState(() {
          //  isSignIn.isSignedIn = true;
        });
        //isSignIn.signedIn();
        print(isSignIn.isSignedIn);
        isSignIn.signedIn();
        _returnWrapper(context);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: logIn,
      onSignup: signUp,
      onRecoverPassword: (_) => null,
      title: 'Cafe Express',
    );
  }

  void _returnWrapper(BuildContext context) {
    Navigator.pushNamed(context, MapSearchRoute);
    print("triggered");
  }
}
