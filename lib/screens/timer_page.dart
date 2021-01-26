import 'package:flutter/material.dart';
import 'dart:async';
import "package:flutter_barcode_scanner/flutter_barcode_scanner.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import '../global.dart' as globals;
import 'package:http/http.dart' as http;
import '../app_theme.dart';
import 'package:circular_menu/circular_menu.dart';
import '../app.dart';
import 'package:amplify_core/amplify_core.dart';

class TimerPage extends StatefulWidget {
  final bookData;
  TimerPage(this.bookData);

  final channel = IOWebSocketChannel.connect(
      "wss://gu2u8vdip2.execute-api.ap-northeast-1.amazonaws.com/CafeExpressWS?id=${globals.userId}");

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer timer;
  int totalTime;
  String timetodisplay = '';
  String lockedTime = "";
  var bookingData;
  Map shopingData;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Location _locationService = Location();

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  // 現在位置
  LocationData _yourLocation;

  // 現在位置の監視状況
  StreamSubscription _locationChangedListen;

  _scan() async {
    return FlutterBarcodeScanner.scanBarcode(
            "#000000", "cancel", true, ScanMode.BARCODE)
        .then((value) => {
              if (value == shopingData["id"])
                {
                  setState(() {
                    bookingData["status"] = "checked_in";
                    lockedTime = timetodisplay.toString();
                    timer.cancel();
                  }),
                  widget.channel.sink.add(json.encode({
                    "action": "onBookingStatusChange",
                    "bookingId": bookingData["bookingId"],
                    "status": bookingData["status"],
                    "updatedAt": DateTime.now().toString(),
                    "storeId": value
                  }))
                }
            });
  }

  String _displayStatus(String status) {
    switch (status) {
      case "paid":
        return "予約";
      case "checked_in":
        return "チェックイン";
      case "cancelled":
        return "キャンセル";
      default:
        return "";
    }
  }

  void initState() {
    super.initState();

    _getBookingData();

    _getLocation();

    _locationChangedListen =
        _locationService.onLocationChanged.listen((LocationData result) async {
      setState(() {
        _yourLocation = result;
      });
    });
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    _locationChangedListen?.cancel();
    super.dispose();
  }

  Future<void> _getBookingData() async {
    if (widget.bookData == null) {
      var response = await http.get(
          'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/booking?customerId=${globals.userId}');
      if (response.statusCode == 200) {
        final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
        bookingData = jsonResponse['body'];
        if (bookingData.length > 0) {
          await _sortBookingData(bookingData);
          bookingData = bookingData[0];
          await _getShopData();
          start();
        } else {
          shopingData = {};
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } else {
      bookingData = widget.bookData;
      await _getShopData();
      start();
    }
  }

  Future<void> _getShopData() async {
    final storeId = bookingData["storeInfo"]["id"];
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$storeId');
    if (response.statusCode == 200) {
      final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
      shopingData = jsonResponse['body'];
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _sortBookingData(bookingData) async {
    setState(() {
      bookingData
        ..sort((v1, v2) =>
            DateTime.parse(v2["bookedAt"]).millisecondsSinceEpoch -
            DateTime.parse(v1["bookedAt"]).millisecondsSinceEpoch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _yourLocation == null ||
                bookingData == null ||
                shopingData == null
            ? Center(child: CircularProgressIndicator())
            : bookingData.length == 0
                ? CircularMenu(
                    alignment: Alignment.topLeft,
                    radius: 100,
                    backgroundWidget: Center(
                        child:
                            Text("予約情報がありません", style: TextStyle(fontSize: 20))),
                    items: [
                        CircularMenuItem(
                            icon: Icons.logout,
                            onTap: () {
                              _logOut();
                            }),
                        CircularMenuItem(
                            icon: Icons.assignment,
                            onTap: () {
                              _changePage(context, BookingHistoryRoute);
                            }),
                        CircularMenuItem(
                            icon: Icons.map,
                            onTap: () {
                              _changePage(context, MapSearchRoute);
                            }),
                      ])
                : StreamBuilder(
                    stream: widget.channel.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          json.decode(snapshot.data)["bookingId"] ==
                              bookingData["bookingId"] &&
                          bookingData["status"] == "paid") {
                        print("inside stream");
                        WidgetsBinding.instance.addPostFrameCallback((_) =>
                            AwesomeDialog(
                              context: context,
                              customHeader: null,
                              animType: AnimType.BOTTOMSLIDE,
                              dialogType: DialogType.SUCCES,
                              body: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Center(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: json.decode(snapshot.data)[
                                                          "status"] ==
                                                      "cancelled"
                                                  ? Text(
                                                      '予約が${_displayStatus(bookingData["status"])}されました',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    )
                                                  : Text(
                                                      '${_displayStatus(json.decode(snapshot.data)["status"])}が完了しました！',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ))),
                                      Text(
                                          '予約名: ${bookingData["bookName"]} さん'),
                                      Text('予約したお店: ${shopingData["name"]}'),
                                      Text('予約番号: ${bookingData["bookingId"]}'),
                                      Text(
                                          '${_displayStatus(json.decode(snapshot.data)["status"])}時間：${json.decode(snapshot.data)["updatedAt"].substring(0, 16)}'),
                                    ])),
                              ),
                              btnOkOnPress: () {},
                              useRootNavigator: false,
                              btnOkColor: Theme.of(context).primaryColor,
                              // btnCancelOnPress: () {},
                              btnOkText: 'OK',
                              // btnCancelText: 'Go To\n Booking List',
                              // btnCancelColor: Colors.blueGreyAccent[400],
                              dismissOnTouchOutside: false,
                              headerAnimationLoop: false,
                              showCloseIcon: false,
                              buttonsBorderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            )..show());
                        bookingData["status"] =
                            json.decode(snapshot.data)["status"];
                        lockedTime = timetodisplay.toString();
                        timer.cancel();
                      }
                      return SafeArea(
                          child: CircularMenu(
                              alignment: Alignment.topLeft,
                              radius: 100,
                              backgroundWidget: Center(
                                child: Container(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(child: _makeGoogleMap()),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: bookingData["status"] ==
                                                        "cancelled"
                                                    ? Text(
                                                        '予約が${_displayStatus(bookingData["status"])}されました',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    : Text(
                                                        '${_displayStatus(bookingData["status"])}が完了しました！',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                              ),
                                              bookingData["status"] == "paid"
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12),
                                                      child: const Text(
                                                        '時間内にお店にチェックインしましょう。',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          EdgeInsets.all(0)),
                                              bookingData["status"] == "paid"
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      16.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      16.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          16.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      16.0)),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: Text(
                                                            '$timetodisplay',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  CafeExpressTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18,
                                                              letterSpacing:
                                                                  0.0,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          EdgeInsets.all(0)),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4.0,
                                                    left: 4.0,
                                                    top: 15.0,
                                                    bottom: 8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: CafeExpressTheme
                                                        .nearlyWhite,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                          color:
                                                              CafeExpressTheme
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.2),
                                                          offset: const Offset(
                                                              1.1, 1.1),
                                                          blurRadius: 8.0),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0,
                                                            right: 18.0,
                                                            top: 12.0,
                                                            bottom: 12.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 10),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              '${shopingData["name"]}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0.27,
                                                                color:
                                                                    CafeExpressTheme
                                                                        .darkText,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '予約名: ${bookingData["bookName"]}さん',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 12,
                                                            letterSpacing: 0.27,
                                                            color:
                                                                CafeExpressTheme
                                                                    .lightText,
                                                          ),
                                                        ),
                                                        Text(
                                                          '予約番号: ${bookingData["bookingId"]}',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 12,
                                                            letterSpacing: 0.27,
                                                            color:
                                                                CafeExpressTheme
                                                                    .lightText,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${_displayStatus(bookingData["status"])}時刻：${bookingData["updatedAt"].substring(0, 16)}',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 12,
                                                            letterSpacing: 0.27,
                                                            color:
                                                                CafeExpressTheme
                                                                    .lightText,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  bottom: 16,
                                                  top: 10),
                                              child: Container(
                                                height: 45,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  color: bookingData[
                                                                  "status"] ==
                                                              "checked_in" ||
                                                          bookingData[
                                                                  "status"] ==
                                                              "cancelled"
                                                      ? Colors.grey
                                                      : CafeExpressTheme
                                                              .buildLightTheme()
                                                          .primaryColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              24.0)),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.6),
                                                      blurRadius: 8,
                                                      offset:
                                                          const Offset(4, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                24.0)),
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () {
                                                      _scan();
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        'QRチェックイン',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: CafeExpressTheme
                                                        .buildLightTheme()
                                                    .primaryColor,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(38.0),
                                                ),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      offset:
                                                          const Offset(0, 2),
                                                      blurRadius: 8.0),
                                                ],
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(32.0),
                                                  ),
                                                  onTap: () {
                                                    AwesomeDialog(
                                                      context: context,
                                                      customHeader: null,
                                                      dialogType:
                                                          DialogType.NO_HEADER,
                                                      animType:
                                                          AnimType.BOTTOMSLIDE,
                                                      body: Center(
                                                        child: Text(
                                                            '${bookingData["storeInfo"]["name"]}に\n電話をしますか？',
                                                            textAlign: TextAlign
                                                                .center),
                                                      ),
                                                      btnOkOnPress: () {
                                                        launch(
                                                            "tel:${shopingData['tel']}");
                                                      },
                                                      useRootNavigator: false,
                                                      btnOkColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      btnCancelOnPress: () {},
                                                      btnOkText: '電話する',
                                                      btnCancelText: 'キャンセル',
                                                      btnCancelColor:
                                                          Colors.blueGrey[400],
                                                      dismissOnTouchOutside:
                                                          true,
                                                      headerAnimationLoop:
                                                          false,
                                                      showCloseIcon: false,
                                                      buttonsBorderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                    )..show();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Icon(
                                                        Icons.local_phone,
                                                        size: 20,
                                                        color: CafeExpressTheme
                                                                .buildLightTheme()
                                                            .backgroundColor),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ]),
                                ),
                              ),
                              items: [
                            CircularMenuItem(
                                icon: Icons.logout,
                                onTap: () {
                                  _logOut();
                                }),
                            CircularMenuItem(
                                icon: Icons.assignment,
                                onTap: () {
                                  _changePage(context, BookingHistoryRoute);
                                }),
                            CircularMenuItem(
                                icon: Icons.map,
                                onTap: () {
                                  _changePage(context, MapSearchRoute);
                                }),
                          ]));
                    }));
  }

  Widget _makeGoogleMap() {
    if (_yourLocation == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GoogleMap(
        polylines: Set<Polyline>.of(polylines.values),
        initialCameraPosition: CameraPosition(
          target: LatLng(_yourLocation.latitude, _yourLocation.longitude),
          zoom: 18.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId(shopingData['id']),
            position: LatLng(
                shopingData['lat'].toDouble(), shopingData['lng'].toDouble()),
            infoWindow: InfoWindow(
              title: '${shopingData['name']}',
            ),
          )
        },
        onMapCreated: (GoogleMapController controller) {
          if (shopingData != null) {
            _createPolylines(_yourLocation.latitude, _yourLocation.longitude,
                shopingData['lat'].toDouble(), shopingData['lng'].toDouble());
            _controller.complete(controller);
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
      );
    }
  }

  void start() {
    timer = Timer.periodic(
        Duration(
          seconds: 1,
        ), (Timer t) {
      if (mounted) {
        setState(() {
          totalTime = DateTime.parse(bookingData['expiredAt'])
              .difference(DateTime.now())
              .inSeconds;
          if (totalTime < 0) {
            timer.cancel();
            timetodisplay = "期限が切れています";
          } else if (totalTime < 3600) {
            int m = totalTime ~/ 60;
            int s = totalTime - (60 * m);
            if (s < 10) {
              timetodisplay = m.toString() + ":" + "0" + s.toString();
            } else {
              timetodisplay = m.toString() + ":" + s.toString();
            }
          }
        });
      }
    });
  }

  void _getLocation() async {
    _yourLocation = await _locationService.getLocation();
  }

  _createPolylines(double startLatitude, double startLongitude,
      double destinationLatitude, double destinationLongitude) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      env['GOOGLE_MAP_API_KEY'],
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Theme.of(context).primaryColor,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
  }

  void _logOut() {
    AwesomeDialog(
      context: context,
      customHeader: null,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.BOTTOMSLIDE,
      body: Center(
        child: Text('本当にログアウトしますか？'),
      ),
      btnOkOnPress: () {
        try {
          Amplify.Auth.signOut();
          _changePage(context, AuthRoute);
        } on Error catch (e) {
          print(e);
        }
      },
      useRootNavigator: false,
      btnOkColor: Theme.of(context).primaryColor,
      btnCancelOnPress: () {},
      btnOkText: 'ログアウト',
      btnCancelText: 'キャンセル',
      btnCancelColor: Colors.blueGrey[400],
      dismissOnTouchOutside: false,
      headerAnimationLoop: false,
      showCloseIcon: false,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(100)),
    )..show();
  }

  void _changePage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
    print("Going to $route was triggered");
  }
}
