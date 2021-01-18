import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:io';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../app.dart';
import 'package:web_socket_channel/io.dart';
import '../global.dart' as globals;
import 'package:flutter/cupertino.dart';

class DetailPage extends StatefulWidget {
  final String id;
  DetailPage(this.id);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _scrollController = ScrollController();
  bool showSpinner = false;
  String text = 'Click the button to start the payment';
  // int amount = 1000;
  String url =
      'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/paymentintent';

  final channel = IOWebSocketChannel.connect(
      "wss://gu2u8vdip2.execute-api.ap-northeast-1.amazonaws.com/CafeExpressWS?id=${globals.userId}");

  var bookedTime;
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
  int price;
  Map seat;
  int seatIndex;
  var availableSeats;
  bool isSeatAvailable = false;

  @override
  void initState() {
    super.initState();
    // print(MediaQuery.of(context).size.width);
    // print(MediaQuery.of(context).size.height);
    print(widget.id);
    _getShopData(widget.id);
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            'pk_test_51I6AF5G0XjqsxliL2merfc1aPkdl7sP8G0NTZRNmVqIusc4grraVQaytizG3OmVMnT93iIbXkI6ycw1cACZK042s00vjyTJG8f',
        merchantId: 'acct_1I6AF5G0XjqsxliL',
        androidPayMode: 'test',
      ),
    );
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
                      children: availableSeats.map<Widget>((table) {
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
                            detectSeat(newValue);
                            print('PRICE:$price');
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
                  onPressed: isSeatAvailable
                      ? () => showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("Booking Confirmation"),
                                content: Column(
                                  children: [
                                    Text(
                                      '人数:$groupNum人 \n 頭金:$price 円 \n 予約するテーブル:${seat['label']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
                                      bookData["index"] = seatIndex,
                                      bookData["partySize"] = groupNum,
                                      bookData["status"] = "paid",
                                      bookData["tableType"] = seat,
                                      bookData["updatedAt"] = "$bookedTime",
                                      debugPrint(json.encode(bookData)),
                                      channel.sink.add(json.encode(bookData)),
                                      createPaymentMethod(),
                                      // price == 0
                                      //     ? _goTimerPage(context)
                                      //     : _goStripePage(
                                      //         context, widget.id, price),
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
    print("_getShopData RUN!!");
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$id');
    if (response.statusCode == 200) {
      final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
      shopData = jsonResponse['body'];
      print("shopdata in _getShopData $shopData");
      vacancyType = shopData['vacancyType'];
      availableSeats = shopData['vacancy']['$vacancyType']
          .where((seat) => seat['isVacant'] == true)
          .toList();
      // setState(() {});
      await detectSeat(groupNum);

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

  Future<void> detectSeat(int groupNum) async {
    seatIndex = await shopData['vacancy']['$vacancyType'].indexWhere((table) =>
        table['isVacant'] == true &&
        table['Min'] <= groupNum &&
        table['Max'] >= groupNum);
    seat =
        seatIndex != -1 ? shopData['vacancy']['$vacancyType'][seatIndex] : null;
    setState(() {
      if (seat != null && seatIndex != -1) {
        isSeatAvailable = true;
      } else {
        isSeatAvailable = false;
      }
    });
    price = seat != null ? seat['cancelFee'] : 0;
    print("Seat in detectSeat $seat");
  }

  void _goStripePage(BuildContext context, id, price) {
    Navigator.pushNamed(context, StripeRoute,
        arguments: {"id": id, "price": price});
    print("goStripePage was triggered");
  }

  void _goTimerPage(BuildContext context) {
    Navigator.pushNamed(context, TimerRoute);
    print("goTimerPage was triggered");
  }

  Future<void> createPaymentMethod() async {
    StripePayment.setStripeAccount(null);
    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();
    paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    ).then((PaymentMethod paymentMethod) {
      return paymentMethod;
    }).catchError((e) {
      print('Errore Card: ${e.toString()}');
    });
    paymentMethod != null
        ? await processPaymentAsDirectCharge(paymentMethod)
        : showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: 'Error',
                content:
                    'It is not possible to pay with this card. Please try again with a different card',
                buttonText: 'CLOSE'));
    // _goTimerPage(context);
  }

  Future<void> processPaymentAsDirectCharge(PaymentMethod paymentMethod) async {
    setState(() {
      showSpinner = true;
    });
    //step 2: request to create PaymentIntent, attempt to confirm the payment & return PaymentIntent
    final http.Response response = await http.post(
        '$url?amount=$price&payMethod=${paymentMethod.id}&storeStripeId=${shopData["stripeId"]}'); // acct_1IAYF4QG0EUj44rM
    if (response.body != null && response.body != 'error') {
      final decordedBody = jsonDecode(response.body);
      print("decode paymentIntentX: ${jsonDecode(decordedBody["body"])}");
      final paymentIntentX = jsonDecode(decordedBody["body"]);
      final status = paymentIntentX['paymentIntent']['status'];
      final strAccount = paymentIntentX['stripeAccount'];
      //step 3: check if payment was succesfully confirmed
      if (status == 'succeeded') {
        //payment was confirmed by the server without need for futher authentification
        StripePayment.completeNativePayRequest();
        setState(() {
          text =
              'Payment completed. ${paymentIntentX['paymentIntent']['amount'].toString()}p succesfully charged';
          showSpinner = false;
        });
      } else {
        //step 4: there is a need to authenticate
        StripePayment.setStripeAccount(strAccount);
        await StripePayment.confirmPaymentIntent(PaymentIntent(
                paymentMethodId: paymentIntentX['paymentIntent']
                    ['payment_method'],
                clientSecret: paymentIntentX['paymentIntent']['client_secret']))
            .then(
          (PaymentIntentResult paymentIntentResult) async {
            //This code will be executed if the authentication is successful
            //step 5: request the server to confirm the payment with
            final statusFinal = paymentIntentResult.status;
            if (statusFinal == 'succeeded') {
              StripePayment.completeNativePayRequest();
              setState(() {
                showSpinner = false;
              });
            } else if (statusFinal == 'processing') {
              StripePayment.cancelNativePayRequest();
              setState(() {
                showSpinner = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => ShowDialogToDismiss(
                      title: 'Warning',
                      content:
                          'The payment is still in \'processing\' state. This is unusual. Please contact us',
                      buttonText: 'CLOSE'));
            } else {
              StripePayment.cancelNativePayRequest();
              setState(() {
                showSpinner = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => ShowDialogToDismiss(
                      title: 'Error',
                      content:
                          'There was an error to confirm the payment. Details: $statusFinal',
                      buttonText: 'CLOSE'));
            }
          },
          //If Authentication fails, a PlatformException will be raised which can be handled here
        ).catchError((e) {
          //case B1
          StripePayment.cancelNativePayRequest();
          setState(() {
            showSpinner = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) => ShowDialogToDismiss(
                  title: 'Error',
                  content:
                      'There was an error to confirm the payment. Please try again with another card',
                  buttonText: 'CLOSE'));
        });
      }
    } else {
      //case A
      StripePayment.cancelNativePayRequest();
      setState(() {
        showSpinner = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
              title: 'Error',
              content:
                  'There was an error in creating the payment. Please try again with another card',
              buttonText: 'CLOSE'));
    }
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

class ShowDialogToDismiss extends StatelessWidget {
  final String content;
  final String title;
  final String buttonText;
  ShowDialogToDismiss({this.title, this.buttonText, this.content});
  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        title: new Text(
          title,
        ),
        content: new Text(
          this.content,
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              buttonText,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
          title: Text(
            title,
          ),
          content: new Text(
            this.content,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                buttonText[0].toUpperCase() +
                    buttonText.substring(1).toLowerCase(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]);
    }
  }
}
