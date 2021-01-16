import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../app.dart';
import 'package:web_socket_channel/io.dart';
import '../global.dart' as globals;

class DetailPage extends StatefulWidget {
  final String id;
  DetailPage(this.id);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _scrollController = ScrollController();

  final channel = IOWebSocketChannel.connect(
      "wss://gu2u8vdip2.execute-api.ap-northeast-1.amazonaws.com/CafeExpressWS?id=${globals.userId}");

  var bookedTime;
  var expireTime;
  Map bookData = {
    "action": "onBook",
    "coupon": {
      "codeForQR": "XXXXXXXX",
      "couponAttached": false,
      "couponId": "pk_XXXXXXXXX",
      "description": "",
      "imagePath": "",
      "title": "dummy"
    },
  };
  Map shopData;
  String vacancyType;
  int groupNum = 1;
  int price = 0;
  Map sheet;
  int sheetindex;
  var availableSheets;
  bool isSheetAvailable = false;

  @override
  void initState() {
    super.initState();
    // print(MediaQuery.of(context).size.width);
    // print(MediaQuery.of(context).size.height);
    print(widget.id);
    _getShopData(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cafe Express"),
        backgroundColor: Theme.of(context).primaryColor,
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
                                    return Text('有効なURLがありません');
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
                        '予約が可能な時間',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Text("月 : "),
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
                            Text("火 : "),
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
                            Text("水 : "),
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
                            Text("木 : "),
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
                            Text("金 : "),
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
                            Text("土 : "),
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
                            Text("日 : "),
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
                            Text("祝 : "),
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
                      '現在空いている席',
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
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '何人で予約しますか？',
                      ),
                      DropdownButton<int>(
                        value: groupNum,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (int newValue) {
                          setState(() {
                            groupNum = newValue;
                            (() {
                              if (sheet == null) {
                                price = 0;
                              } else {
                                price = newValue * sheet['cancelFee'];
                              }
                            })();
                            detectSheet(groupNum);
                          });
                        },
                        items: <int>[
                          1,
                          2,
                          3,
                          4,
                          5,
                          6,
                          7,
                          8,
                          9,
                          10,
                          11,
                          12,
                        ].map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text("$value"),
                          );
                        }).toList(),
                      ),
                      Text('Deposit : $price Yen'),
                    ],
                  ),
                ),
                OutlineButton(
                  borderSide: BorderSide(color: Colors.lightBlue),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book,
                        ),
                        Text("Book now!"),
                      ]),
                  onPressed: isSheetAvailable
                      ? () => showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("Booking Confirmation"),
                                content: Text(
                                  '人数:$groupNum人 \n 頭金:$price 円 \n 予約するテーブル:${sheet['label']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  FlatButton(
                                    child: Text("Go Payment"),
                                    onPressed: () => {
                                      bookedTime = DateTime.now(),
                                      expireTime = bookedTime
                                          .add(new Duration(minutes: 30)),
                                      bookData["bookedAt"] = "$bookedTime",
                                      bookData["bookingId"] =
                                          "${globals.userId}${bookedTime.millisecondsSinceEpoch}",
                                      bookData["bookName"] = globals.userId,
                                      bookData["createdAt"] = "$bookedTime",
                                      bookData["depositAmount"] = price,
                                      bookData["expiredAt"] = "$expireTime",
                                      bookData["index"] = sheetindex,
                                      bookData["partySize"] = groupNum,
                                      bookData["status"] = "payed",
                                      bookData["tableType"] = sheet,
                                      bookData["updatedAt"] = "$bookedTime",
                                      // debugPrint(json.encode(bookData)),
                                      channel.sink.add(json.encode(bookData)),
                                      _goTimerPage(context),
                                    },
                                  ),
                                ],
                              );
                            },
                          )
                      : null,
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
    return Card(
      child: Image.network(
        '${shopData['imagePaths'][0]}',
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(child: LinearProgressIndicator());
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace stackTrace) {
          return Text('No Image or Loading Error');
        },
      ),
    );
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
      detectSheet(groupNum);
      bookData["storeInfo"] = {
        "address": shopData['address'],
        "category": shopData['category'],
        "id": shopData['id'],
        "name": shopData['name'],
        "rating": shopData['statistics']['rating'],
        "tel": shopData['tel'],
      };
      bookData['vacancyType'] = shopData['vacancyType'];
      bookData['customerInfo'] = {
        "customerId": globals.userId,
      };
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void detectSheet(int groupNum) {
    print("detectsheet called");
    sheet = shopData['vacancy']['$vacancyType'].firstWhere(
        (sheet) =>
            sheet['isVacant'] &&
            sheet['Min'] <= groupNum &&
            sheet['Max'] >= groupNum, orElse: () {
      return null;
    });
    sheetindex = shopData['vacancy']['$vacancyType'].indexWhere((sheet) =>
        sheet['isVacant'] == true &&
        sheet['Min'] <= groupNum &&
        sheet['Max'] >= groupNum);
    setState(() {
      if (sheet != null && sheetindex != -1) {
        isSheetAvailable = true;
      } else {
        isSheetAvailable = false;
      }
    });
    print(sheet);
  }

  void _goTimerPage(BuildContext context) {
    Navigator.pushNamed(context, TimerRoute);
    print("goTimerPage was triggered");
  }

  // WidgetsBinding.instance.addPostFrameCallback((_) => AwesomeDialog(
  //                 context: context,
  //                 customHeader: null,
  //                 animType: AnimType.LEFTSLIDE,
  //                 dialogType: DialogType.SUCCES,
  //                 body: Center(
  //                     child: Column(children: [
  //                   Text(
  //                       'Party Size:${json.decode(snapshot.data)["partySize"]}\nBooked Time:${json.decode(snapshot.data)["bookedAt"]}\nArrival Time By:${json.decode(snapshot.data)["expiredAt"]}\nDeposit:${json.decode(snapshot.data)["depositAmount"]} Yen'),
  //                 ])),
  //                 btnOkOnPress: () {},
  //                 useRootNavigator: false,
  //                 btnOkColor: Colors.tealAccent[400],
  //                 // btnCancelOnPress: () {},
  //                 btnOkText: '予約リストを開く',
  //                 // btnCancelText: 'Go To\n Booking List',
  //                 // btnCancelColor: Colors.redAccent[400],
  //                 dismissOnTouchOutside: false,
  //                 headerAnimationLoop: false,
  //                 showCloseIcon: true,
  //                 buttonsBorderRadius: BorderRadius.all(Radius.circular(100)),
  //               )..show());
  //           bookingId = json.decode(snapshot.data)["bookingId"];
  //           // vacancyInfo[json.decode(snapshot.data)["index"]]["isVacant"] =
  //           //     false;
  //         }
}
