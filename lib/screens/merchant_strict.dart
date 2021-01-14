import "package:flutter/material.dart";
import '../global.dart' as globals;
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'merchant_calendar_page.dart';
import 'qr_page.dart';
import 'merchant_page.dart';
import '../app.dart';

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

  final TextEditingController table1Controller = TextEditingController();
  final TextEditingController table2Controller = TextEditingController();
  final TextEditingController table3Controller = TextEditingController();
  final TextEditingController table4Controller = TextEditingController();
  final TextEditingController table5Controller = TextEditingController();
  final TextEditingController table6Controller = TextEditingController();
  final TextEditingController table7Controller = TextEditingController();
  final TextEditingController table8Controller = TextEditingController();
  final TextEditingController table9Controller = TextEditingController();
  final TextEditingController table10Controller = TextEditingController();
  final TextEditingController table11Controller = TextEditingController();
  final TextEditingController table12Controller = TextEditingController();

  Map shopData;
  List vacancyInfo;

  void toggleButton(int index) {
    setState(() {
      vacancyInfo[index]["isVacant"] = !vacancyInfo[index]["isVacant"];
      switch (index) {
        case 0:
          vacancyInfo[index]["cancelFee"] = int.parse(table1Controller.text);
          break;
        case 1:
          vacancyInfo[index]["cancelFee"] = int.parse(table2Controller.text);
          break;
        case 2:
          vacancyInfo[index]["cancelFee"] = int.parse(table3Controller.text);
          break;
        case 3:
          vacancyInfo[index]["cancelFee"] = int.parse(table4Controller.text);
          break;
        case 4:
          vacancyInfo[index]["cancelFee"] = int.parse(table5Controller.text);
          break;
        case 5:
          vacancyInfo[index]["cancelFee"] = int.parse(table6Controller.text);
          break;
        case 6:
          vacancyInfo[index]["cancelFee"] = int.parse(table7Controller.text);
          break;
        case 7:
          vacancyInfo[index]["cancelFee"] = int.parse(table8Controller.text);
          break;
        case 8:
          vacancyInfo[index]["cancelFee"] = int.parse(table9Controller.text);
          break;
        case 9:
          vacancyInfo[index]["cancelFee"] = int.parse(table10Controller.text);
          break;
        case 10:
          vacancyInfo[index]["cancelFee"] = int.parse(table11Controller.text);
          break;
        case 11:
          vacancyInfo[index]["cancelFee"] = int.parse(table12Controller.text);
          break;
      }
    });

    channel.sink.add(json.encode({
      "action": "onVacancyChange",
      "storeId": globals.userId,
      "index": index,
      "vacancyType": shopData["vacancyType"],
      "isVacant": vacancyInfo[index]["isVacant"],
      "cancelFee": vacancyInfo[index]["cancelFee"]
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
    table1Controller.text =
        shopData["vacancy"][shopData["vacancyType"]][0]["cancelFee"].toString();
    table2Controller.text =
        shopData["vacancy"][shopData["vacancyType"]][1]["cancelFee"].toString();
    table3Controller.text =
        shopData["vacancy"][shopData["vacancyType"]][2]["cancelFee"].toString();
    table4Controller.text =
        shopData["vacancy"][shopData["vacancyType"]][3]["cancelFee"].toString();
    table5Controller.text =
        shopData["vacancy"][shopData["vacancyType"]][4]["cancelFee"].toString();
    table6Controller.text =
        shopData["vacancy"][shopData["vacancyType"]][5]["cancelFee"].toString();
    table7Controller.text =
        shopData["vacancy"][shopData["vacancyType"]][6]["cancelFee"].toString();
    table8Controller.text =
        shopData["vacancy"][shopData["vacancyType"]][7]["cancelFee"].toString();
    table9Controller.text =
        shopData["vacancy"][shopData["vacancyType"]][8]["cancelFee"].toString();
    table10Controller.text =
        shopData["vacancy"][shopData["vacancyType"]][9]["cancelFee"].toString();
    table11Controller.text = shopData["vacancy"][shopData["vacancyType"]][10]
            ["cancelFee"]
        .toString();
    table12Controller.text = shopData["vacancy"][shopData["vacancyType"]][11]
            ["cancelFee"]
        .toString();
  }

  var bookingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new Container(),
        title: Text(
          "Cafe Express Control Panel",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              json.decode(snapshot.data)["bookingId"] != bookingId) {
            print(snapshot.data);
            WidgetsBinding.instance.addPostFrameCallback((_) => AwesomeDialog(
                  context: context,
                  customHeader: null,
                  animType: AnimType.LEFTSLIDE,
                  dialogType: DialogType.SUCCES,
                  body: Center(
                      child: Column(children: [
                    Text(
                        'Party Size:${json.decode(snapshot.data)["partySize"]}\nBooked Time:${json.decode(snapshot.data)["bookedAt"]}\nArrival Time By:${json.decode(snapshot.data)["expiredAt"]}\nDeposit:${json.decode(snapshot.data)["depositAmount"]} Yen'),
                  ])),
                  btnOkOnPress: () {},
                  useRootNavigator: false,
                  btnOkColor: Colors.tealAccent[400],
                  // btnCancelOnPress: () {},
                  btnOkText: '予約リストを開く',
                  // btnCancelText: 'Go To\n Booking List',
                  // btnCancelColor: Colors.redAccent[400],
                  dismissOnTouchOutside: false,
                  headerAnimationLoop: false,
                  showCloseIcon: true,
                  buttonsBorderRadius: BorderRadius.all(Radius.circular(100)),
                )..show());
            bookingId = json.decode(snapshot.data)["bookingId"];
            // vacancyInfo[json.decode(snapshot.data)["index"]]["isVacant"] =
            //     false;
          }
          return ListView(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              children: [
                Card(
                  child: Container(
                      width: 300,
                      height: 70,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Badge(
                              toAnimate: false,
                              shape: BadgeShape.square,
                              badgeColor: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(8),
                              badgeContent: Text('一人席',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                  )),
                            ),
                            Container(
                                width: 70,
                                child: TextFormField(
                                  // The validator receives the text that the user has entered.
                                  decoration: InputDecoration(
                                    hintText: '0',
                                  ),
                                  controller: table1Controller,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Input Cancel Fee.';
                                    }
                                    return null;
                                  },
                                )),
                            Center(
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                height: 40.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: vacancyInfo[0]["isVacant"]
                                        ? Colors.blueAccent[100]
                                        : Colors.redAccent[100]
                                            .withOpacity(0.5)),
                                child: Stack(
                                  children: <Widget>[
                                    AnimatedPositioned(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeIn,
                                      top: 3.0,
                                      left: vacancyInfo[0]["isVacant"]
                                          ? 60.0
                                          : 0.0,
                                      right: vacancyInfo[0]["isVacant"]
                                          ? 0.0
                                          : 60.0,
                                      child: InkWell(
                                        onTap: () => {toggleButton(0)},
                                        child: AnimatedSwitcher(
                                          duration: Duration(milliseconds: 500),
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            return RotationTransition(
                                                child: child, turns: animation);
                                          },
                                          child: vacancyInfo[0]["isVacant"]
                                              ? Icon(Icons.check_circle,
                                                  color: Colors.blue,
                                                  size: 32.0,
                                                  key: UniqueKey())
                                              : Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.red,
                                                  size: 32.0,
                                                  key: UniqueKey()),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ])),
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
              ]);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7),
            IconButton(
              icon: Icon(
                Icons.qr_code_rounded,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, QrRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_today_rounded,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, MerchantCalendarRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                size: 24.0,
                color: Theme.of(context).primaryColor,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, MerchantCalendarRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.assignment,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, BookingListRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () =>
                  {_changePage(context, MerchantProfileSettingRoute)},
            ),
            SizedBox(width: 7),
          ],
        ),
        color: Theme.of(context).primaryColor,
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 4.0,
        child: Icon(
          Icons.videogame_asset,
        ),
        onPressed: () => {_changePage(context, MerchantRoute)},
      ),
    );
  }

  void _changePage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
    print("Going to $route was triggered");
  }
}
