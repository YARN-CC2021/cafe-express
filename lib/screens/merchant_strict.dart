import "package:flutter/material.dart";
import '../global.dart' as globals;
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MerchantStrict extends StatefulWidget {
  @override
  _MerchantStrictState createState() => _MerchantStrictState();
}

class _MerchantStrictState extends State<MerchantStrict> {
  final channel = IOWebSocketChannel.connect(
      "wss://gu2u8vdip2.execute-api.ap-northeast-1.amazonaws.com/CafeExpressWS?id=${globals.userId}");

  @override
  void initState() {
    super.initState();
    _getShopData();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  Map shopData;
  List vacancyInfo;

  void toggleButton(int index) {
    setState(() {
      vacancyInfo[index]["isVacant"] = !vacancyInfo[index]["isVacant"];
    });

    channel.sink.add(json.encode({
      "action": "onVacancyChange",
      "storeId": globals.userId,
      "index": index,
      "vacancyType": shopData["vacancyType"],
      "isVacant": vacancyInfo[index]["isVacant"]
    }));
  }

  Future<void> _getShopData() async {
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/${globals.userId}');
    if (response.statusCode == 200) {
      final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        shopData = jsonResponse['body'];
      });
      print("This is ShopData: $shopData");
      _mapMountedVacancyInfo();
      print("This is Vacancy Info: $vacancyInfo");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _mapMountedVacancyInfo() {
    vacancyInfo = shopData["vacancy"][shopData["vacancyType"]];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Cafe Express Control Panel",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.blue,
          elevation: 0.0,
        ),
        body: ListView(children: [
          StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  // child: Text(snapshot.hasData
                  //     ? '${json.decode(snapshot.data)["customerId"]}'
                  //     : ''),
                  child: AlertDialog(
                    title: Text("Booking Confirmation"),
                    content: Text(
                        'Party Size:${json.decode(snapshot.data)["partySize"]}\nBooked Time:${json.decode(snapshot.data)["bookedAt"]}\nArrival Time By:${json.decode(snapshot.data)["expiredAt"]}\nDeposit:${json.decode(snapshot.data)["depositAmount"]} Yen'),
                    // actions: <Widget>[
                    //   // ボタン領域
                    //   FlatButton(
                    //     child: Text("Go To Control Panel"),
                    //     onPressed: () => Navigator.pop(context),
                    //   ),
                    // ],
                  ),
                );
              }
              return Text("");
            },
          ),
          Text(
            "1 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[0]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[0]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[0]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(0)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[0]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "2 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[1]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[1]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[1]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(1)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[1]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "3 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[2]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[2]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[2]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(2)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[2]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "4 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[3]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[3]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[3]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(3)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[3]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "5 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[4]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[4]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[4]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(4)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[4]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "6 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[5]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[5]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[5]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(5)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[5]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "7 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[6]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[6]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[6]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(6)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[6]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "8 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[7]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[7]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[7]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(7)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[7]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "9 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[8]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[8]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[8]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(8)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[8]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "10 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[9]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[9]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[9]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(9)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[9]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "11 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[10]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[10]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[10]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(10)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[10]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "12 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: vacancyInfo[11]["isVacant"]
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: vacancyInfo[11]["isVacant"] ? 60.0 : 0.0,
                    right: vacancyInfo[11]["isVacant"] ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: () => {toggleButton(11)},
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: vacancyInfo[11]["isVacant"]
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ]));
  }

  // toggleButton2() {
  //   setState(() {
  //     toggle2 = !toggle2;
  //   });
  // }

  // toggleButton3() {
  //   setState(() {
  //     toggle3 = !toggle3;
  //   });
  // }

  // toggleButton4() {
  //   setState(() {
  //     toggle4 = !toggle4;
  //   });
  // }

  // toggleButton5() {
  //   setState(() {
  //     toggle5 = !toggle5;
  //   });
  // }

  // toggleButton6() {
  //   setState(() {
  //     toggle6 = !toggle6;
  //   });
  // }

  // toggleButton7() {
  //   setState(() {
  //     toggle7 = !toggle7;
  //   });
  // }

  // toggleButton8() {
  //   setState(() {
  //     toggle8 = !toggle8;
  //   });
  // }

  // toggleButton9() {
  //   setState(() {
  //     toggle9 = !toggle9;
  //   });
  // }

  // toggleButton10() {
  //   setState(() {
  //     toggle10 = !toggle10;
  //   });
  // }

  // toggleButton11() {
  //   setState(() {
  //     toggle11 = !toggle11;
  //   });
  // }

  // toggleButton12() {
  //   setState(() {
  //     toggle12 = !toggle12;
  //   });
  // }
}
