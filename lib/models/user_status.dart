import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

class Status with ChangeNotifier {
  bool isSignedIn = false;

  void signedIn() {
    isSignedIn = true;
    notifyListeners();
  }

  void loggedOut() {
    isSignedIn = false;
    notifyListeners();
  }
}
