import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailPage extends StatefulWidget {
  final String id;
  DetailPage(this.id);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _scrollController = ScrollController();
  Map shopData;
  String vacancyType;
  String groupNum = '1';
  int price = 0;
  var availableSheets;
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
      body: showShopDetail(),
    );
  }

  Widget showShopDetail() {
    if (shopData == null) {
      // 現在位置が取れるまではローディング中
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            controller: _scrollController,
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
                            textAlign: TextAlign.end,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Booking Available Time',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Text("Mon : "),
                            changeTime(
                                shopData['hours']['Mon']['bookingStart']),
                            Text("~"),
                            changeTime(shopData['hours']['Mon']['bookingEnd']),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Text("Tue : "),
                            changeTime(
                                shopData['hours']['Tue']['bookingStart']),
                            Text("~"),
                            changeTime(shopData['hours']['Tue']['bookingEnd']),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Text("Wed : "),
                            changeTime(
                                shopData['hours']['Wed']['bookingStart']),
                            Text("~"),
                            changeTime(shopData['hours']['Wed']['bookingEnd']),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Text("Thu : "),
                            changeTime(
                                shopData['hours']['Thu']['bookingStart']),
                            Text("~"),
                            changeTime(shopData['hours']['Thu']['bookingEnd']),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Text("Fri : "),
                            changeTime(
                                shopData['hours']['Fri']['bookingStart']),
                            Text("~"),
                            changeTime(shopData['hours']['Fri']['bookingEnd']),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Text("Sat : "),
                            changeTime(
                                shopData['hours']['Sat']['bookingStart']),
                            Text("~"),
                            changeTime(shopData['hours']['Sat']['bookingEnd']),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Text("Sun : "),
                            changeTime(
                                shopData['hours']['Sun']['bookingStart']),
                            Text("~"),
                            changeTime(shopData['hours']['Sun']['bookingEnd']),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Text("Hol : "),
                            changeTime(
                                shopData['hours']['Holiday']['bookingStart']),
                            Text("~"),
                            changeTime(
                                shopData['hours']['Holiday']['bookingEnd']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(children: [
                    Text(
                      'Available Sheets',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      children: availableSheets.map<Widget>((table) {
                        return Card(
                          child: Text(
                            '${table['label']}',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'How Many Members ?',
                        ),
                        DropdownButton<String>(
                          value: groupNum,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              groupNum = newValue;
                              price = int.parse(newValue) *
                                  shopData['depositAmountPerPerson'];
                            });
                          },
                          items: <String>[
                            '1',
                            '2',
                            '3',
                            '4',
                            '5',
                            '6',
                            '7',
                            '8',
                            '9',
                            '10',
                            '11',
                            '12',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        Text('Deposit : $price Yen'),
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("Booking Confirmation"),
                          content:
                              Text('GroupNumber:$groupNum  Deposit:$price Yen'),
                          actions: <Widget>[
                            // ボタン領域
                            FlatButton(
                              child: Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                              child: Text("Go Payment"),
                              onPressed: () => {}, //goto payment page
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book,
                        ),
                        Text("Book now!"),
                      ]),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget changeTime(String time) {
    String first;
    String last;
    if (time.length == 4) {
      if (time.substring(0, 1) == "1") {
        first = first = time.substring(0, 2);
      } else {
        first = time.substring(1, 2);
      }
      last = time.substring(2);
    }
    return Text('$first:$last');
  }

  Widget imageCard() {
    return CachedNetworkImage(
      imageUrl: shopData['imagePaths'][0],
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
    );
    // if ('${shopData['imagePaths'][0]}' == null) {
    //   return Card(
    //     child: Text(''),
    //   );
    // } else {
    //   return Card(
    //     child: Image.network(
    //       '${shopData['imagePaths'][0]}',
    //       errorBuilder:
    //           (BuildContext context, Object exception, StackTrace stackTrace) {
    //         return Text('No Image or Loading Error');
    //       },
    //     ),
    //   );
    // }
  }

  Future<void> _getShopData(String id) async {
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$id');
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        shopData = jsonResponse['body'];
        price = shopData['depositAmountPerPerson'];
        vacancyType = shopData['vacancyType'];
        availableSheets = shopData['vacancy']['$vacancyType']
            .where((sheet) => sheet['isVacant'] == true)
            .toList();
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
