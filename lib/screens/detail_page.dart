import "package:flutter/material.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final Map shop;
  DetailPage({Key key, this.shop}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.shop['id']),
    );
  }

  // Widget showShopDetail() {
  //   if (shopData == null) {
  //     // 現在位置が取れるまではローディング中
  //     return Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   } else {}
  // }

  Future<void> _getShopData() async {
    /////////////////////////
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store');
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var shopData = jsonResponse;
      return shopData;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
