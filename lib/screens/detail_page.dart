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
  var bookedTime; //DateTime.now().parse('');??
  var expireTime;
  final Map bookData = {
    "action": "onBook",
    "coupon": {
      "codeForQR": "XXXXXXXX",
      "couponAttached": false,
      "couponId": "pk_XXXXXXXXX",
      "description": "",
      "imagePath": "",
      "title": "dummy",
    },
    "storeInfo": "",
    "customerInfo": "",
    "vacancyType": ""
  };
  Map shopData;
  String vacancyType;
  int groupNum = 1;
  int price = 0;
  Map sheet;
  int sheetindex;
  var availableSheets;
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
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 50.0),
                          // child:
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
                          // ),
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
                          //Return All isVacant and false onPressed:null
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
                        'How Many Members ?',
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
                            price =
                                newValue * shopData['depositAmountPerPerson'];
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("Booking Confirmation"),
                          content: Text(
                            'GroupNumber:$groupNum \n Deposit:$price Yen',
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
                                expireTime =
                                    bookedTime.add(new Duration(minutes: 30)),
                                bookData["bookedAt"] = "$bookedTime",
                                bookData["bookingId"] =
                                    "${globals.userId}${bookedTime.millisecondsSinceEpoch}",
                                bookData["bookName"] = globals.userId,
                                bookData["createdAt"] = "$bookedTime",
                                bookData["depositAmount"] = price,
                                bookData["expiredAt"] = "$expireTime",
                                bookData["index"] = sheetindex,
                                bookData["partySize"] = groupNum,
                                bookData["status"] = "paid",
                                bookData["tableType"] = sheet,
                                bookData["updatedAt"] = "$bookedTime",
                                debugPrint(json.encode(bookData)),
                                channel.sink.add(json.encode(bookData)),
                                //   "action": "onBook",
                                //   "bookedAt": "Who Knows", //same to createdAt?
                                //   "bookingId": "", //?
                                //   "bookName": "Naoto", //?
                                //   "coupon": {
                                //     "codeForQR": "XXXXXXXX",
                                //     "couponAttached": true,
                                //     "couponId": "pk_XXXXXXXXX",
                                //     "description":
                                //         "メロスは激怒した。必ず、かの邪智暴虐じゃちぼうぎゃくの王を除かなければならぬと決意した。メロスには政治がわからぬ。メロスは、村の牧人である。笛を吹き、羊と遊んで暮して来た。けれども邪悪に対しては、人一倍に敏感であった。きょう未明メロスは村を出発し、野を越え山越え、十里はなれた此このシラクスの市にやって来た。メロスには父も、母も無い。女房も無い。十六の、内気な妹と二人暮しだ。この妹は、村の或る律気な一牧人を、近々、花婿はなむことして迎える事になっていた。結婚式も間近かなのである。メロスは、それゆえ、花嫁の衣裳やら祝宴の御馳走やらを買いに、はるばる市にやって来たのだ。先ず、その品々を買い集め、それから都の大路をぶらぶら歩いた。メロスには竹馬の友があった。セリヌンティウスである。今は此のシラクスの市で、石工をしている。その友を、これから訪ねてみるつもりなのだ。久しく逢わなかったのだから、訪ねて行くのが楽しみである。歩いているうちにメロスは、まちの様子を怪しく思った。",
                                //     "imagePath": "http://....",
                                //     "title": "２万引き"
                                //   },
                                //   "createdAt": "datetime",
                                //   "customerInfo": {
                                //     "customerId":
                                //         "c7076e59-5072-42ec-86f0-944d151f7869"
                                //   },
                                //   "depositAmount": 1000,
                                //   "expiredAt": "Who Cares", //booked_At の 30分後
                                //   "index": 3, //どこのテーブルかを把握するため
                                //   "partySize": 2,
                                //   "status": "checked-in",
                                //   "storeInfo": {
                                //     "address": "六本木３－１－１",
                                //     "category": "Cafe",
                                //     "id":
                                //         "21dcac49-26a3-4eae-96b0-ee3db3da8eb3",
                                //     "name": "CCbucks",
                                //     "rating": 3.8,
                                //     "tel": "123-2313-1231"
                                //   },
                                //   "tableType": {
                                //     "isVacant": true,
                                //     "label": "1 Seat Table",
                                //     "Max": 1,
                                //     "Min": 1
                                //   },
                                //   "updatedAt": "2021-01-12-02:01:00",
                                //   "vacancyType": "strict"
                                // })),
                                _goTimerPage(context),
                              }, //goto payment page
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
    // try {
    // //Can't handle invalid URL
    //   return CachedNetworkImage(
    //     imageUrl: shopData['imagePaths'][0],
    //     placeholder: (context, url) => Center(child: LinearProgressIndicator()),
    //     errorWidget: (context, url, error) => Text('No Image or Loading Error'),
    //   );
    // } catch (e) {
    //   print(e);
    //   return Text('No Image or Loading Error');
    // }

    return Card(
      child: Image.network(
        '${shopData['imagePaths'][0]}',
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
              child: LinearProgressIndicator()); //Text('Loading...'));
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace stackTrace) {
          return Text('No Image or Loading Error');
        },
      ),
    );
  }

  Future<void> _getShopData(String id) async {
    print("_getShopData RUN!!");
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$id');
    print("RESPONSE ${response.statusCode}");
    if (response.statusCode == 200) {
      final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
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
    sheet = shopData['vacancy']['$vacancyType'].firstWhere(
        (seat) =>
            seat['isVacant'] == true &&
            seat['Min'] <= groupNum &&
            seat['Max'] >= groupNum,
        orElse: () => print('No matching element.'));
    sheetindex = shopData['vacancy']['$vacancyType'].indexWhere((seat) =>
        seat['isVacant'] == true &&
        seat['Min'] <= groupNum &&
        seat['Max'] >= groupNum);
  }

  void _goTimerPage(BuildContext context) {
    Navigator.pushNamed(context, TimerRoute);
    print("goTimerPage was triggered");
  }
}
