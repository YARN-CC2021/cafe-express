import "package:flutter/material.dart";

class MerchantPage extends StatefulWidget {
  @override
  _MerchantPageState createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cafe Express"),
          backgroundColor: Colors.blue,
          elevation: 0.0,
        ),
        body: Column(
          children: [Text("THIS IS THE MERCHANT DISPLAY")],
        ));
  }
}
