import "package:flutter/material.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String id;
  DetailPage({Key key, this.id}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var shopData;
  @override
  void initState() {
    super.initState();

    _getShopData(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cafe Express"),
          backgroundColor: Colors.blue,
          elevation: 0.0,
        ),
        body: showShopDetail());
  }

  Widget showShopDetail() {
    if (shopData == null) {
      // 現在位置が取れるまではローディング中
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(child: Text('$shopData'));
    }
  }

  Future<void> _getShopData(String id) async {
    /////////////////////////
    print("---------");
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store?id=$id');
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      shopData = jsonResponse;
      return shopData;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
