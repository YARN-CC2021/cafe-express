import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import '../app.dart';
import '../global.dart' as globals;
import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../app_theme.dart';

class Validation extends StatefulWidget {
  final String email;
  final String passcode;

  Validation(this.email, this.passcode);

  _ValidationState createState() => _ValidationState();
}

class _ValidationState extends State<Validation> {
  String currentText = "";
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController _confirmationCodeController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("確認コード",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        centerTitle: true,
        backgroundColor: CafeExpressTheme.buildLightTheme().backgroundColor,
        elevation: 3.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
        child: Form(
          child: Column(
            children: [
              Text(
                "確認コードが${widget.email}に送信されました",
                // "An email confirmation code has been sent to ${widget.email}.",
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Text(
                "お使いの電子メールアドレスであることを確認するために、確認コードを下に入力してください:",
                // style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  inactiveFillColor: Colors.grey[200],
                  activeFillColor: Colors.white,
                  inactiveColor: Theme.of(context).primaryColor,
                  activeColor: Theme.of(context).primaryColor,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: _confirmationCodeController,
                onCompleted: (v) {
                  print("Completed");
                },
                onChanged: (value) {
                  print(value);
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 8),
                child: Container(
                  height: 48,
                  width: 200,
                  decoration: BoxDecoration(
                    color: CafeExpressTheme.buildLightTheme().primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                      highlightColor: Colors.transparent,
                      onTap: () {
                        _submitCode(context);
                      },
                      child: Center(
                        child: Text(
                          '送信',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitCode(BuildContext context) async {
    //  if (_formKey.currentState.validate()) {
    final confirmationCode = _confirmationCodeController.text;
    try {
      final SignUpResult response = await Amplify.Auth.confirmSignUp(
        username: widget.email,
        confirmationCode: confirmationCode,
      );
      if (response.isSignUpComplete) {
        //_goToUserCategory(context);
        autoLogIn(context);
      }
    } on AuthError catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.cause),
        ),
      );
    }
    //}
  }

  void _goToUserCategory(BuildContext context) {
    Navigator.pushNamed(context, UserCategoryRoute);
    print("new login move to user type page");
  }

  Future<void> autoLogIn(aContext) async {
    SignInResult result = await Amplify.Auth.signIn(
        username: widget.email, password: widget.passcode);
    try {
      if (result.isSignedIn) {
        globals.firstSignIn = true;
        print("First Sign In!!! : ${globals.firstSignIn}");
        _goToUserCategory(aContext);
        print(result.isSignedIn);
      }
    } catch (e) {
      print(e);
    }
  }
}
