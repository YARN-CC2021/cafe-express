import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
    if (shopData == null) {
      // 現在位置が取れるまではローディング中
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    Text(
                      '${shopData['name']}',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${shopData['category']}',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "URL",
                            style: TextStyle(color: Colors.lightBlue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = shopData['storeURL'];
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  return InfoWindow(title: "No URL");
                                }
                              },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              imageCard(),
              Card(
                color: Colors.amber[100],
                child: Text('${shopData['description']}'),
              ),
              Card(
                child: Row(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          Text("Mon"),

                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Text("Tue"),
                          
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Text("Wed"),
                          
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Text("Thu"),
                          
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Text("Fri"),
                          
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Text("Sat"),
                          
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Text("Sun"),
                          
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Text("Hol"),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget imageCard() {
    if ('${shopData['imagePaths'][0]}' == null) {
      return Card(
        child: Text(''),
      );
    } else {
      return Card(
        child: Image.network('${shopData['imagePaths'][0]}'),
      );
    }
  }

  Future<void> _getShopData(String id) async {
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$id');
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        shopData = jsonResponse['body'];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
