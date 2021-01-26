import "package:flutter/material.dart";
import 'merchant_strict.dart';

class MerchantPage extends StatefulWidget {
  @override
  _MerchantPageState createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  String type = "strict";

  @override
  initState() {
    print('init state was called');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (type == "strict") {
      return MerchantStrict();
    }
    /* 
    once flex page is completed - flex view to deployed
    else if (type == "flex") {
    return MerchantFlex();
    }
    */
  }
}
