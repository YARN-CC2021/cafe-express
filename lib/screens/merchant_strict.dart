import "package:flutter/material.dart";
import '../global.dart' as globals;
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import '../app.dart';
import '../app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MerchantStrict extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  MerchantStrict({Key key, this.animationController, this.animation})
      : super(key: key);

  final channel = IOWebSocketChannel.connect(
      "wss://gu2u8vdip2.execute-api.ap-northeast-1.amazonaws.com/CafeExpressWS?id=${globals.userId}");

  @override
  _MerchantStrictState createState() => _MerchantStrictState();
}

class _MerchantStrictState extends State<MerchantStrict> {
  @override
  void initState() {
    super.initState();
    _getShopData();
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  final TextEditingController cancelFeeController = TextEditingController();

  var shopData;
  var bookingId;
  List vacancyInfo;

  Future<void> _getShopData() async {
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/${globals.userId}');
    final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      setState(() {
        shopData = jsonResponse['body'];
      });
      _mapMountedVacancyInfo();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _mapMountedVacancyInfo() {
    vacancyInfo = shopData["vacancy"][shopData["vacancyType"]];
  }

  void toggleButton(int index) {
    setState(() {
      vacancyInfo[index]["isVacant"] = !vacancyInfo[index]["isVacant"];
    });

    widget.channel.sink.add(json.encode({
      "action": "onVacancyChange",
      "storeId": globals.userId,
      "index": index,
      "vacancyType": shopData["vacancyType"],
      "isVacant": vacancyInfo[index]["isVacant"],
      "cancelFee": vacancyInfo[index]["cancelFee"]
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new Container(),
          title: Text("空席管理",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          centerTitle: true,
          backgroundColor: CafeExpressTheme.buildLightTheme().backgroundColor,
          elevation: 3.0,
        ),
        body: shopData == null
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      json.decode(snapshot.data)["bookingId"] != bookingId) {
                    print(snapshot.data);
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => AwesomeDialog(
                              context: context,
                              customHeader: null,
                              animType: AnimType.LEFTSLIDE,
                              dialogType: DialogType.SUCCES,
                              body: Center(
                                  child: Column(children: [
                                Text(
                                    '人数: ${json.decode(snapshot.data)["partySize"]}'),
                                Text(
                                    '予約時間: ${json.decode(snapshot.data)["bookedAt"]}'),
                                Text(
                                    '到着締切: ${json.decode(snapshot.data)["expiredAt"]}'),
                                Text(
                                    'キャンセル料: ${json.decode(snapshot.data)["depositAmount"]}円'),
                              ])),
                              btnOkOnPress: () {
                                _changePage(context, BookingListRoute);
                              },
                              useRootNavigator: false,
                              btnOkColor: Colors.tealAccent[400],
                              // btnCancelOnPress: () {},
                              btnOkText: '予約リストを開く',
                              // btnCancelText: 'Go To\n Booking List',
                              // btnCancelColor: Colors.blueGreyAccent[400],
                              dismissOnTouchOutside: false,
                              headerAnimationLoop: false,
                              showCloseIcon: true,
                              buttonsBorderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            )..show());
                    bookingId = json.decode(snapshot.data)["bookingId"];
                    vacancyInfo[json.decode(snapshot.data)["index"]]
                        ["isVacant"] = false;
                  }
                  return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(children: createListOfVacancyCard()));
                }));
  }

  void _changePage(BuildContext context, String route) {
    widget.channel.sink.close();
    Navigator.pushNamed(context, route);
    print("Going to $route was triggered");
  }

  createListOfVacancyCard() {
    var listOfTables = <Widget>[];
    for (var i = 0; i < vacancyInfo.length; i++) {
      listOfTables.add(createSingleVacancyCard(i));
    }
    return listOfTables;
  }

  void showDialogForCancelFee(index) {
    cancelFeeController.text = vacancyInfo[index]["cancelFee"].toString();
    AwesomeDialog(
      context: context,
      customHeader: null,
      animType: AnimType.LEFTSLIDE,
      dialogType: DialogType.NO_HEADER,
      body: Center(
          child: Column(children: [
        Container(
            padding: EdgeInsets.only(bottom: 20),
            width: 150,
            height: 60,
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "Deposit金額(円)",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2.0,
                  ),
                ),
              ),
              controller: cancelFeeController,
              validator: (value) {
                if (int.parse(value) <= 50) {
                  return '50円未満は設定できません';
                }
                return null;
              },
            )),
        Text("${vacancyInfo[index]["label"]}のDeposit金額を入力してください")
      ])),
      btnOkOnPress: () {
        _cancelFeeUpdate(index);
      },
      useRootNavigator: false,
      btnOkColor: Colors.tealAccent[400],
      btnCancelOnPress: () {},
      btnOkText: '保存',
      btnCancelText: 'キャンセル',
      btnCancelColor: Colors.blueGrey[400],
      dismissOnTouchOutside: false,
      headerAnimationLoop: false,
      showCloseIcon: true,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(100)),
    )..show();
  }

  void _cancelFeeUpdate(int index) {
    setState(() {
      switch (index) {
        case 0:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
        case 1:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
        case 2:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
        case 3:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
        case 4:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
        case 5:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
        case 6:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
        case 7:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
        case 8:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
        case 9:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
        case 10:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
        case 11:
          vacancyInfo[index]["cancelFee"] = int.parse(cancelFeeController.text);
          break;
      }
    });

    widget.channel.sink.add(json.encode({
      "action": "onVacancyChange",
      "storeId": globals.userId,
      "index": index,
      "vacancyType": shopData["vacancyType"],
      "isVacant": vacancyInfo[index]["isVacant"],
      "cancelFee": vacancyInfo[index]["cancelFee"]
    }));
  }

  Widget createSingleVacancyCard(index) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: CafeExpressTheme.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: CafeExpressTheme.grey.withOpacity(0.4),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: SizedBox(
                          height: 74,
                          child: AspectRatio(
                            aspectRatio: 0.7,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Row(
                              children: <Widget>[
                                Center(
                                    child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        left: 68,
                                        right: 10,
                                      ),
                                      child: SizedBox(
                                        width: 80,
                                        child: Text("Table",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 12)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 60,
                                        right: 10,
                                      ),
                                      child: SizedBox(
                                          width: 80,
                                          height: 40,
                                          child: Text(
                                              vacancyInfo[index]["label"],
                                              style: TextStyle(fontSize: 18))),
                                    )
                                  ],
                                )),
                                Center(
                                    child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                      ),
                                      child: SizedBox(
                                          width: 80,
                                          child: RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                              text: "Deposit",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                          ]))),
                                    ),
                                    SizedBox(
                                        width: 80,
                                        height: 40,
                                        child: Text(
                                            "${vacancyInfo[index]["cancelFee"]}円",
                                            style: TextStyle(fontSize: 18))),
                                  ],
                                )),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Center(
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      height: 40.0,
                                      width: 100.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: vacancyInfo[index]["isVacant"]
                                              ? Theme.of(context).primaryColor
                                              : Colors.blueGrey[100]
                                                  .withOpacity(0.5)),
                                      child: Stack(
                                        children: <Widget>[
                                          AnimatedPositioned(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeIn,
                                            top: 3.0,
                                            left: vacancyInfo[index]["isVacant"]
                                                ? 60.0
                                                : 0.0,
                                            right: vacancyInfo[index]
                                                    ["isVacant"]
                                                ? 0.0
                                                : 60.0,
                                            child: InkWell(
                                              onTap: () =>
                                                  {toggleButton(index)},
                                              child: AnimatedSwitcher(
                                                duration:
                                                    Duration(milliseconds: 500),
                                                transitionBuilder:
                                                    (Widget child,
                                                        Animation<double>
                                                            animation) {
                                                  return RotationTransition(
                                                      child: child,
                                                      turns: animation);
                                                },
                                                child: vacancyInfo[index]
                                                        ["isVacant"]
                                                    ? Icon(Icons.check_circle,
                                                        color: Colors.teal,
                                                        size: 32.0,
                                                        key: UniqueKey())
                                                    : Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        color: Colors.blueGrey,
                                                        size: 32.0,
                                                        key: UniqueKey()),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  child: SizedBox(
                    height: 40,
                    child: vacancyInfo[index]["isVacant"]
                        ? AspectRatio(
                            aspectRatio: 1.2,
                            child: Image.asset("assets/images/openGreen.png"),
                          )
                        : AspectRatio(
                            aspectRatio: 1.2,
                            child: Image.asset("assets/images/closeFinal.jpeg"),
                          ),
                  ),
                ),
              ),
              Positioned(
                  top: 3,
                  left: 185,
                  child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.edit, size: 12),
                    onPressed: () {
                      showDialogForCancelFee(index);
                    },
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
