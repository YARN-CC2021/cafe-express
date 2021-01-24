import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:io';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../global.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  final _scrollController = ScrollController();
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
  int groupNum = 1;
  int price = 0;
  Map seat;
  int seatIndex;
  var availableSeats;
  bool isSeatAvailable = false;
  var mainPhotoUrl;
  int selectedSeatIndex;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

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
      }
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
        24.0;
    return Container(
        color: CafeExpressTheme.nearlyWhite,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
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
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: LinearProgressIndicator());
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Text('イメージがないか、ロード中にエラーが起こりました');
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
                  // width: double.infinity,
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
                                  left: 16, right: 16, bottom: 8, top: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // for left side
                                      children: [
                                        Row(children: [
                                          Icon(FontAwesomeIcons.mapMarkerAlt,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 14),
                                          Text(
                                            " " + shopData["address"],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 13,
                                              letterSpacing: 0.27,
                                              color: CafeExpressTheme.grey,
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
                                              fontSize: 13,
                                              letterSpacing: 0.27,
                                              color: CafeExpressTheme.grey,
                                            ),
                                          ),
                                        ]),
                                        Row(children: [
                                          Icon(FontAwesomeIcons.envelope,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 14),
                                          Text(
                                            " " + shopData["contactEmail"],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 13,
                                              letterSpacing: 0.27,
                                              color: CafeExpressTheme.grey,
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
                                    left: 16, right: 16, top: 10, bottom: 8),
                                child: new Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    shopData["description"],
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14,
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
                              padding: EdgeInsets.only(top: 10, left: 18),
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
                                    top: 0, bottom: 0, right: 16, left: 16),
                                itemCount: availableSeats.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return getTimeBoxUI(
                                      availableSeats[index]["label"], index);
                                },
                              ),
                            ))),

                            // SizedBox(
                            //   height: 70,
                            // )
                            // AnimatedOpacity(
                            //   duration: const Duration(milliseconds: 500),
                            //   opacity: opacity3,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(
                            //         left: 16, bottom: 16, right: 16),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       crossAxisAlignment: CrossAxisAlignment.center,
                            //       children: <Widget>[
                            //         Container(
                            //           width: 48,
                            //           height: 48,
                            //           child: Container(
                            //             decoration: BoxDecoration(
                            //               color: CafeExpressTheme.nearlyWhite,
                            //               borderRadius: const BorderRadius.all(
                            //                 Radius.circular(16.0),
                            //               ),
                            //               border: Border.all(
                            //                   color: CafeExpressTheme.grey
                            //                       .withOpacity(0.2)),
                            //             ),
                            //             child: Icon(
                            //               Icons.add,
                            //               color: Theme.of(context).primaryColor,
                            //               size: 28,
                            //             ),
                            //           ),
                            //         ),
                            //         const SizedBox(
                            //           width: 16,
                            //         ),
                            //         Expanded(
                            //           child: Container(
                            //             height: 48,
                            //             decoration: BoxDecoration(
                            //               color: Theme.of(context).primaryColor,
                            //               borderRadius: const BorderRadius.all(
                            //                 Radius.circular(24),
                            //               ),
                            //               boxShadow: <BoxShadow>[
                            //                 BoxShadow(
                            //                     color: Theme.of(context)
                            //                         .primaryColor
                            //                         .withOpacity(0.5),
                            //                     offset: const Offset(1.1, 1.1),
                            //                     blurRadius: 10.0),
                            //               ],
                            //             ),
                            //             child: Center(
                            //               child: Text(
                            //                 'Join Course',
                            //                 textAlign: TextAlign.left,
                            //                 style: TextStyle(
                            //                   fontWeight: FontWeight.w600,
                            //                   fontSize: 18,
                            //                   letterSpacing: 0.0,
                            //                   color: CafeExpressTheme.nearlyWhite,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 80,
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                right: 35,
                child: ScaleTransition(
                  alignment: Alignment.center,
                  scale: CurvedAnimation(
                      parent: animationController, curve: Curves.fastOutSlowIn),
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
                                  : FaIcon(FontAwesomeIcons.glassMartiniAlt,
                                      color: Colors.white, size: 26)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: SizedBox(
                  width: AppBar().preferredSize.height,
                  height: AppBar().preferredSize.height,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(AppBar().preferredSize.height),
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
                  onPressed: () {},
                  label: Text('予約する', style: TextStyle(color: Colors.white)),
                  backgroundColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ));
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
