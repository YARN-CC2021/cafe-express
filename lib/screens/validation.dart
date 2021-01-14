import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import '../app.dart';

class Validation extends StatelessWidget {
  final String email;
  final String passcode;

  Validation(this.email, this.passcode);

  // Validation({
  //   Key key,
  //   @required this.email,
  // }) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _confirmationCodeController =
      TextEditingController();

  final _formKey = GlobalKey<FormFieldState>();

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
                "An email confirmation code is sent to $email. Please type the code to confirm your email.",
                style: Theme.of(context).textTheme.headline6,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _confirmationCodeController,
                decoration: InputDecoration(labelText: "Confirmation Code"),
                validator: (value) => value.length != 6
                    ? "The confirmation code is invalid"
                    : null,
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
    try {
      final SignUpResult response = await Amplify.Auth.confirmSignUp(
        username: email,
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
    SignInResult result =
        await Amplify.Auth.signIn(username: email, password: passcode);
    try {
      if (result.isSignedIn) {
        _goToUserCategory(aContext);
        print(result.isSignedIn);
      }
    } catch (e) {
      print(e);
    }
  }
}
