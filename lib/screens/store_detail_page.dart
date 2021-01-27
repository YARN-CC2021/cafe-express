import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
// import 'package:amplify_core/amplify_core.dart';
import "package:amplify_flutter/amplify.dart";
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:io';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import '../global.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../app.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

class StoreDetailPage extends StatefulWidget {
  final String id;
  StoreDetailPage(this.id);

  @override
  _StoreDetailPageState createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  bool showSpinner = false;
  String text = 'Click the button to start the payment';
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
  Map seat;
  int seatIndex;
  var availableSeats;
  bool isSeatAvailable = false;
  var mainPhotoUrl;
  int selectedSeatIndex;
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    _getShopData(widget.id);
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            'pk_test_51I6AF5G0XjqsxliL2merfc1aPkdl7sP8G0NTZRNmVqIusc4grraVQaytizG3OmVMnT93iIbXkI6ycw1cACZK042s00vjyTJG8f',
        merchantId: 'acct_1I6AF5G0XjqsxliL',
        androidPayMode: 'test',
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }

  Future<void> _getShopData(String id) async {
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$id');
    if (response.statusCode == 200) {
      if (mounted) {
        final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
        shopData = jsonResponse['body'];
        await _showPic();
        print("shopdata in _getShopData $shopData");
        vacancyType = shopData['vacancyType'];
        availableSeats = shopData['vacancy']['$vacancyType']
            .where((seat) => seat['isVacant'] == true)
            .toList();

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
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> getSeatIndex() async {
    print("inside getSeat Index");
    seatIndex = await shopData['vacancy']['$vacancyType'].indexWhere((table) =>
        table['label'] == availableSeats[selectedSeatIndex]["label"]);
    print("seat Index : $seatIndex");
  }

  Future<void> _showPic() async {
    final getUrlOptions = GetUrlOptions(
      accessLevel: StorageAccessLevel.guest,
    );

    if (shopData["imageUrl"] != null && shopData["imageUrl"].length > 0) {
      String key = shopData["imageUrl"][0];
      var result =
          await Amplify.Storage.getUrl(key: key, options: getUrlOptions);
      setState(() {
        mainPhotoUrl = result.url;
      });
    } else {
      mainPhotoUrl = null;
    }
    print("listOfUrl: $mainPhotoUrl");
  }

  Widget getOpenClose(String day) {
    String dayJp;
    String sentence;
    switch (day) {
      case "Mon":
        dayJp = "月";
        break;
      case "Tue":
        dayJp = "火";
        break;
      case "Wed":
        dayJp = "水";
        break;
      case "Thu":
        dayJp = "木";
        break;
      case "Fri":
        dayJp = "金";
        break;
      case "Sat":
        dayJp = "土";
        break;
      case "Sun":
        dayJp = "日";
        break;
      default:
        dayJp = "祝";
    }
    if (shopData['hours'][day]['day_off']) {
      sentence = "$dayJp：定休日";
    } else {
      String bookingStart = gethours(shopData['hours'][day]['bookingStart']);
      String bookingEnd = gethours(shopData['hours'][day]['bookingEnd']);
      sentence = "$dayJp：$bookingStart ～ $bookingEnd";
    }
    return Text(
      sentence,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.w200,
        fontSize: 12,
        letterSpacing: 0.27,
        color: CafeExpressTheme.grey,
      ),
    );
  }

  String gethours(String time) {
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
    return '$first:$last';
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        100;
    return Container(
        color: CafeExpressTheme.nearlyWhite,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: shopData == null || availableSeats == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1.2,
                          child: mainPhotoUrl == null
                              ? Center(child: CircularProgressIndicator())
                              : Image.network(
                                  mainPhotoUrl,
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return Text('画像がないか、ロード中にエラーが起こりました');
                                  },
                                ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: CafeExpressTheme.nearlyWhite,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32.0),
                              topRight: Radius.circular(32.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: CafeExpressTheme.grey.withOpacity(0.2),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 10.0),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: SingleChildScrollView(
                            child: Container(
                              constraints: BoxConstraints(
                                  minHeight: infoHeight,
                                  maxHeight: tempHeight > infoHeight
                                      ? tempHeight
                                      : infoHeight),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 32.0, left: 18, right: 16),
                                    child: Text(
                                      shopData["name"],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                        letterSpacing: 0.27,
                                        color: CafeExpressTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 8,
                                        top: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start, // for left side
                                            children: [
                                              Row(children: [
                                                Icon(
                                                    FontAwesomeIcons
                                                        .mapMarkerAlt,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 14),
                                                Text(
                                                  " " + shopData["address"],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 14,
                                                    letterSpacing: 0.27,
                                                    color:
                                                        CafeExpressTheme.grey,
                                                  ),
                                                ),
                                              ]),
                                              Row(children: [
                                                Icon(FontAwesomeIcons.phone,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 14),
                                                Text(
                                                  " " + shopData["tel"],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 14,
                                                    letterSpacing: 0.27,
                                                    color:
                                                        CafeExpressTheme.grey,
                                                  ),
                                                ),
                                              ]),
                                              Row(children: [
                                                Icon(FontAwesomeIcons.envelope,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 14),
                                                Text(
                                                  " " +
                                                      shopData["contactEmail"],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 14,
                                                    letterSpacing: 0.27,
                                                    color:
                                                        CafeExpressTheme.grey,
                                                  ),
                                                ),
                                              ]),
                                            ]),
                                      ],
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 500),
                                    opacity: opacity2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 10,
                                          bottom: 8),
                                      child: new Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          shopData["description"],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w200,
                                            fontSize: 13,
                                            letterSpacing: 0.27,
                                            color: CafeExpressTheme.grey,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10, left: 16),
                                    child: Text(
                                      '営業時間',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        letterSpacing: 0.27,
                                        color: CafeExpressTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          bottom: 8,
                                          top: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start, // for left side
                                              children: [
                                                getOpenClose("Mon"),
                                                getOpenClose("Tue"),
                                                getOpenClose("Wed"),
                                              ]),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start, // for left side
                                              children: [
                                                getOpenClose("Thu"),
                                                getOpenClose("Fri"),
                                                getOpenClose("Sat"),
                                              ]),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start, // for left side
                                              children: [
                                                getOpenClose("Sun"),
                                                getOpenClose("Holiday"),
                                                Text(
                                                  "",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color:
                                                        CafeExpressTheme.grey,
                                                  ),
                                                )
                                              ]),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 16, bottom: 5),
                                    child: Text(
                                      '空席',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        letterSpacing: 0.27,
                                        color: CafeExpressTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: SingleChildScrollView(
                                          child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                          right: 16,
                                          left: 16),
                                      itemCount: availableSeats.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return getTimeBoxUI(
                                            availableSeats[index]["label"],
                                            index);
                                      },
                                    ),
                                  ))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top:
                          (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                      right: 35,
                      child: ScaleTransition(
                        alignment: Alignment.center,
                        scale: CurvedAnimation(
                            parent: animationController,
                            curve: Curves.fastOutSlowIn),
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          elevation: 10.0,
                          child: Container(
                            width: 60,
                            height: 60,
                            child: Center(
                                child: shopData["category"] == "カフェ"
                                    ? FaIcon(FontAwesomeIcons.coffee,
                                        color: Colors.white, size: 26)
                                    : shopData["category"] == "レストラン"
                                        ? FaIcon(FontAwesomeIcons.utensils,
                                            color: Colors.white, size: 26)
                                        : FaIcon(
                                            FontAwesomeIcons.glassMartiniAlt,
                                            color: Colors.white,
                                            size: 26)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: SizedBox(
                        width: AppBar().preferredSize.height,
                        height: AppBar().preferredSize.height,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                AppBar().preferredSize.height),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: CafeExpressTheme.nearlyBlack,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 7),
                  child: FloatingActionButton.extended(
                    heroTag: "hero1",
                    onPressed: () {},
                    label: selectedSeatIndex != null
                        ? Text(
                            "人数：${availableSeats[selectedSeatIndex]["Min"]}人\nデポジット：${availableSeats[selectedSeatIndex]["cancelFee"]}円",
                            textAlign: TextAlign.center)
                        : Text(
                            "席を選択してください",
                            textAlign: TextAlign.center,
                          ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                  ),
                ),
                FloatingActionButton.extended(
                  heroTag: "hero2",
                  onPressed: selectedSeatIndex == null
                      ? null
                      : () {
                          AwesomeDialog(
                            context: context,
                            title: "予約詳細",
                            customHeader: null,
                            animType: AnimType.LEFTSLIDE,
                            dialogType: DialogType.NO_HEADER,
                            body: Center(
                                child: Column(children: [
                              Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  width: 150,
                                  height: 60,
                                  child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        // The validator receives the text that the user has entered.
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          labelText: "予約名",
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                              color: CafeExpressTheme.grey,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        controller: nameController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return '名前が入力されていません';
                                          }
                                          return null;
                                        },
                                      ))),
                              Text(
                                '人数:${availableSeats[selectedSeatIndex]["Min"]}人',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'デポジット:${availableSeats[selectedSeatIndex]["cancelFee"]}円',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '予約するテーブル:${availableSeats[selectedSeatIndex]['label']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ])),
                            btnOkOnPress: () async => {
                              if (_formKey.currentState.validate())
                                {
                                  bookData["depositAmount"] =
                                      availableSeats[selectedSeatIndex]
                                          ["cancelFee"],
                                  bookData["tableType"] =
                                      availableSeats[selectedSeatIndex],
                                  await getSeatIndex(),
                                  print("done getting seat index"),
                                  bookData["index"] = seatIndex,
                                  print("bookdata index: ${bookData["index"]}"),
                                  bookData["partySize"] =
                                      availableSeats[selectedSeatIndex]["Min"],
                                  bookData["bookName"] = nameController.text,
                                  availableSeats[selectedSeatIndex]
                                              ["cancelFee"] ==
                                          0
                                      ? {
                                          bookedTime = DateTime.now(),
                                          expireTime = bookedTime
                                              .add(new Duration(minutes: 30)),
                                          bookData["bookedAt"] = "$bookedTime",
                                          bookData["bookingId"] =
                                              "${globals.userId}${bookedTime.millisecondsSinceEpoch}",
                                          bookData["createdAt"] = "$bookedTime",
                                          bookData["expiredAt"] = "$expireTime",
                                          bookData["status"] = "paid",
                                          bookData["updatedAt"] = "$bookedTime",
                                          channel.sink
                                              .add(json.encode(bookData)),
                                          _sendEmail(),
                                          Timer(Duration(seconds: 1), () {
                                            _goTimerPage(context, bookData);
                                          })
                                        }
                                      : createPaymentMethod()
                                }
                            },
                            useRootNavigator: false,
                            btnOkColor: Theme.of(context).primaryColor,
                            btnCancelOnPress: () {},
                            btnOkText: '予約',
                            btnCancelText: 'キャンセル',
                            btnCancelColor: Colors.blueGrey[400],
                            dismissOnTouchOutside: false,
                            headerAnimationLoop: false,
                            showCloseIcon: true,
                            buttonsBorderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          )..show();
                        },
                  label: Text('予約する', style: TextStyle(color: Colors.white)),
                  backgroundColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ));
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
    print("paymentMethod $paymentMethod");
    if (paymentMethod != null) {
      await processPaymentAsDirectCharge(paymentMethod);
      bookedTime = DateTime.now();
      expireTime = bookedTime.add(new Duration(minutes: 30));
      bookData["bookedAt"] = "$bookedTime";
      bookData["bookingId"] =
          "${globals.userId}${bookedTime.millisecondsSinceEpoch}";
      bookData["createdAt"] = "$bookedTime";
      bookData["expiredAt"] = "$expireTime";
      bookData["status"] = "paid";
      bookData["updatedAt"] = "$bookedTime";
      channel.sink.add(json.encode(bookData));
      _sendEmail();
      Timer(Duration(seconds: 1), () {
        _goTimerPage(context, bookData);
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
              title: 'Error',
              content:
                  'It is not possible to pay with this card. Please try again with a different card',
              buttonText: 'CLOSE'));
    }
  }

  void _goTimerPage(BuildContext context, Map bookData) {
    Navigator.pushNamed(context, TimerRoute,
        arguments: {"passedBookingData": bookData});
    print("goTimerPage was triggered");
  }

  Future<void> _sendEmail() async {
    Map sendBody = bookData;
    sendBody["contactEmail"] = shopData['contactEmail'];
    sendBody["price"] = availableSeats[selectedSeatIndex]["cancelFee"];
    var response = await http.post(
      "https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/email",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sendBody),
    );
    print("Send email status: $response");
  }

  Future<void> processPaymentAsDirectCharge(PaymentMethod paymentMethod) async {
    setState(() {
      showSpinner = true;
    });
    print(
        "amount = ${availableSeats[selectedSeatIndex]["cancelFee"]}, payMethod= ${paymentMethod.id} storeStripeId=${shopData["stripeId"]}");
    final http.Response response = await http.post(
        '$url?amount=${availableSeats[selectedSeatIndex]["cancelFee"]}&payMethod=${paymentMethod.id}&storeStripeId=${shopData["stripeId"]}'); // acct_1IAYF4QG0EUj44rM
    print("decordedBody: ${jsonDecode(response.body)}");
    if (response.body != null &&
        response.body != 'error' &&
        jsonDecode(response.body)["body"] != null) {
      final decordedBody = jsonDecode(response.body);
      final paymentIntentX = jsonDecode(decordedBody["body"]);
      final status = paymentIntentX['paymentIntent']['status'];
      final strAccount = paymentIntentX['stripeAccount'];
      if (status == 'succeeded') {
        StripePayment.completeNativePayRequest();
        setState(() {
          text =
              'Payment completed. ${paymentIntentX['paymentIntent']['amount'].toString()}p succesfully charged';
          showSpinner = false;
        });
      } else {
        StripePayment.setStripeAccount(strAccount);
        await StripePayment.confirmPaymentIntent(PaymentIntent(
                paymentMethodId: paymentIntentX['paymentIntent']
                    ['payment_method'],
                clientSecret: paymentIntentX['paymentIntent']['client_secret']))
            .then(
          (PaymentIntentResult paymentIntentResult) async {
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
        ).catchError((e) {
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

  Widget getTimeBoxUI(String text, int index) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedSeatIndex = index;
            });
          },
          child: Container(
            width: 90,
            decoration: BoxDecoration(
              color: selectedSeatIndex != index
                  ? CafeExpressTheme.nearlyWhite
                  : Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: CafeExpressTheme.grey.withOpacity(0.2),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 8.0),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 9.0, bottom: 9.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.27,
                      color: selectedSeatIndex != index
                          ? Theme.of(context).primaryColor
                          : CafeExpressTheme.nearlyWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
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
