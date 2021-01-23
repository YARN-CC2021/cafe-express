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
    // timer.cancel();
    _locationChangedListen?.cancel();
    super.dispose();
  }

  Future<void> _getBookingData() async {
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
        appBar: AppBar(
          leading: new Container(),
          title: Text("タイマーページ",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          centerTitle: true,
          backgroundColor: CafeExpressTheme.buildLightTheme().backgroundColor,
          elevation: 3.0,
        ),
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
                              // callback
                            }),
                        CircularMenuItem(
                            icon: Icons.assignment,
                            onTap: () {
                              _changePage(context, BookingHistoryRoute);
                              //callback
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
                        print("snapshot.data ${snapshot.data}");
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => AwesomeDialog(
                                  context: context,
                                  customHeader: null,
                                  animType: AnimType.BOTTOMSLIDE,
                                  dialogType: DialogType.SUCCES,
                                  body: Center(
                                      child: Column(children: [
                                    Text('名前: ${bookingData["bookName"]} さん'),
                                    Text('予約したお店: ${shopingData["name"]} さん'),
                                    Text('予約番号: ${bookingData["bookingId"]}'),
                                    Text(
                                        '${_displayStatus(json.decode(snapshot.data)["status"])}が完了しました！'),
                                    Text(
                                        '${_displayStatus(json.decode(snapshot.data)["status"])}時間：${json.decode(snapshot.data)["updatedAt"]}'),
                                  ])),
                                  btnOkOnPress: () {},
                                  useRootNavigator: false,
                                  btnOkColor: Colors.tealAccent[400],
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
                                              bookingData["status"] ==
                                                          "checked_in" ||
                                                      bookingData["status"] ==
                                                          "cancelled"
                                                  ? Center(
                                                      child: Column(children: [
                                                      Text(
                                                          '予約番号: ${bookingData["bookingId"]}'),
                                                      Text(
                                                          '${shopingData["name"]}での${_displayStatus(bookingData["status"])}が完了しました！'),
                                                      Text(
                                                          '${_displayStatus(bookingData["status"])}時間：${bookingData["updatedAt"]}'),
                                                    ]))
                                                  : Center(
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                              '${bookingData["bookName"]} さん'),
                                                          Text(
                                                            '$timetodisplay\n以内にお店にチェックインしましょう。',
                                                            style: TextStyle(
                                                                fontSize: 25.0,
                                                                color: bookingData[
                                                                            "status"] ==
                                                                        "paid"
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .grey),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20.0,
                                                    horizontal: 80.0),
                                                child: RaisedButton(
                                                  child: Text("QRコードでチェックイン"),
                                                  onPressed: () => _scan(),
                                                )),
                                            Text("お店に連絡したいならアイコンをタップ"),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          icon: Icon(Icons
                                                              .local_phone),
                                                          onPressed: () {
                                                            launch(
                                                                "tel:${shopingData['tel']}");
                                                          }),
                                                      Text("電話"),
                                                    ]),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        icon: Icon(Icons.mail),
                                                        onPressed: () {
                                                          launch(
                                                              "mailto:${shopingData['contactEmail']}");
                                                        }),
                                                    Text("メール"),
                                                  ],
                                                ),
                                              ],
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
                                  // callback
                                }),
                            CircularMenuItem(
                                icon: Icons.assignment,
                                onTap: () {
                                  _changePage(context, BookingHistoryRoute);
                                  //callback
                                }),
                            CircularMenuItem(
                                icon: Icons.map,
                                onTap: () {
                                  _changePage(context, MapSearchRoute);
                                }),
                            // CircularMenuItem(icon: Icons.star, onTap: () {
                            //   //callback
                            // }),
                            // CircularMenuItem(icon: Icons.pages, onTap: () {
                            //   //callback
                            // }),
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
              // snippet: ,
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
        myLocationButtonEnabled: true,
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
            //go fail page
            timer.cancel();
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
      btnOkColor: Colors.tealAccent[400],
      btnCancelOnPress: () {},
      btnOkText: 'ログアウト',
      btnCancelText: 'キャンセル',
      btnCancelColor: Colors.blueGrey[400],
      dismissOnTouchOutside: false,
      headerAnimationLoop: false,
      showCloseIcon: false,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(100)),
    )..show();
    // Amplify.Auth.signOut();
    // Navigator.pushNamed(context, AuthRoute);

    print("triggered");
  }

  void _changePage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
    print("Going to $route was triggered");
  }
}
