import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import '../app.dart';
import '../global.dart' as globals;
import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';

class PasswordReset extends StatefulWidget {
  final String email;

  PasswordReset(this.email);

  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String currentText = "";
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  final TextEditingController _confirmationCodeController =
      TextEditingController();
  final TextEditingController _newPassCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Confirm your email"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              Text(
                "An email confirmation code has been sent to ${widget.email}",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 80),
              Text(
                "Please type the code to confirm your email:",
                // style: Theme.of(context).textTheme.headline6,
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
                backgroundColor: Colors.blue.shade50,
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
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _newPassCodeController,
                decoration: InputDecoration(labelText: "New Password"),
                // validator: (value) => value.length != 6
                //     ? "The confirmation code is invalid"
                //     : null,
              ),
              RaisedButton(
                onPressed: () => _submitCode(context),
                child: Text("CONFIRM"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitCode(BuildContext context) async {
    //  if (_formKey.currentState.validate()) {
    final confirmationCode = _confirmationCodeController.text;
    final newPassCode = _newPassCodeController.text;

    try {
      final UpdatePasswordResult response = await Amplify.Auth.confirmPassword(
          username: widget.email,
          newPassword: newPassCode,
          confirmationCode: confirmationCode);
      if (response != null) {
        //_goToUserCategory(context);
        autoLogIn(context, newPassCode);
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

  void _goToWrapper(BuildContext context) {
    Navigator.pushNamed(context, WrapperRoute);
    print("new login move to user type page");
  }

  Future<void> autoLogIn(aContext, newPassCode) async {
    SignInResult result = await Amplify.Auth.signIn(
        username: widget.email, password: newPassCode);
    try {
      if (result.isSignedIn) {
        globals.firstSignIn = true;
        print("First Sign In!!! : ${globals.firstSignIn}");
        _goToWrapper(aContext);
        print(result.isSignedIn);
      }
    } catch (e) {
      print(e);
    }
  }
}
