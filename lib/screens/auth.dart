import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import '../amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import "package:flutter_login/flutter_login.dart";
import "../app.dart";
import "../global.dart" as globals;
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
    print("Very beginning auth: ${globals.userId}");
    if (!isConfigured) config();
  }

  void config() async {
    AmplifyAuthCognito amplifyAuthCognito = AmplifyAuthCognito();
    AmplifyStorageS3 storage = AmplifyStorageS3();
    amplify.addPlugin(
        authPlugins: [amplifyAuthCognito], storagePlugins: [storage]);
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
      _goToValidation(context, data.name, data.password);
    } else {
      return 'Sign up error';
    }
  }

  Future<String> logIn(LoginData data) async {
    try {
      SignInResult result = await Amplify.Auth.signIn(
          username: data.name, password: data.password);
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
      AwesomeDialog(
        context: context,
        customHeader: null,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        body: Center(
          child: Text("Log in failed. Please try again."),
        ),
        btnOkOnPress: () {
          _returnWrapper(context);
        },
        btnOkText: "Return to Log In Screen",
        btnOkColor: Colors.tealAccent[400],
        useRootNavigator: false,
        dismissOnTouchOutside: false,
        headerAnimationLoop: false,
        showCloseIcon: false,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(100)),
      )..show();
    }
  }

  Future<String> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (error) {
      return 'Sign out error';
    }
  }

  Future<String> recoverPassword(String name) async {
    try {
      ResetPasswordResult result = await Amplify.Auth.resetPassword(
        username: name,
      );
      print(result);
      print(result.isPasswordReset);
      if (!result.isPasswordReset) {
        _goResetPassword(context, name);
      } else {
        return 'Sign up error';
      }
    } on AuthError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        onLogin: logIn,
        onSignup: signUp,
        onRecoverPassword: recoverPassword,
        title: 'Cafe Express',
        theme: LoginTheme(primaryColor: Colors.teal));
  }

  void _returnWrapper(BuildContext context) {
    // Navigator.pushNamed(context, MapSearchRoute);
    Navigator.pushNamed(context, WrapperRoute);
    print("triggered");
  }

  void _goToValidation(BuildContext context, String email, String passcode) {
    Navigator.pushNamed(context, ValidationRoute,
        arguments: {"email": email, "passcode": passcode});
    print("new login move to user type page");
  }

  void _goResetPassword(BuildContext context, String email) {
    Navigator.pushNamed(context, PasswordResetRoute,
        arguments: {"email": email});
    print("new login move to user type page");
  }
}
