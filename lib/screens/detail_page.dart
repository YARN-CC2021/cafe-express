import "package:flutter/material.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String id;
  DetailPage(this.id);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map shopData;
  @override
  void initState() {
    super.initState();
    print(widget.id);
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
    print('-------$shopData');
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
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$id');
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        shopData = jsonResponse;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
