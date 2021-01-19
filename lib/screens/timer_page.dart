import 'package:flutter/material.dart';
import 'dart:async';
import "package:flutter_barcode_scanner/flutter_barcode_scanner.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import '../global.dart' as globals;

class TimerPage extends StatefulWidget {
  final Map shopData;
  final Map bookData;
  TimerPage(this.shopData, this.bookData);
  final channel = IOWebSocketChannel.connect(
      "wss://gu2u8vdip2.execute-api.ap-northeast-1.amazonaws.com/CafeExpressWS?id=${globals.userId}");

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer timer;
  int totalTime;
  String timetodisplay = '';
  String barcode = "";
  String lockedTime = "";

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
              setState(() {
                widget.bookData["status"] = "checked_in";
                barcode = value;
                lockedTime = timetodisplay.toString();
                timer.cancel();
              }),
              widget.channel.sink.add(json.encode({
                "action": "onBookingStatusChange",
                "bookingId": widget.bookData["bookingId"],
                "status": widget.bookData["status"],
                "updatedAt": DateTime.now().toString(),
                "storeId": barcode
              }))
            });
  }

  void initState() {
    super.initState();
    print("inside timer page, print bookData: ${widget.bookData}");
    start();

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
    timer.cancel();
    _locationChangedListen?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cafe Express"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Center(
        child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _makeGoogleMap()),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    children: [
                      Text(
                        "Dead Line is...",
                        style: TextStyle(
                          fontSize: 35.0,
                          color: Colors.redAccent[400],
                        ),
                      ),
                      Text(
                        '$timetodisplay',
                        style: TextStyle(fontSize: 35.0, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 80.0),
                          child: RaisedButton(
                            child: Text("Scan Barcode"),
                            onPressed: () => _scan(),
                          )),
                      // Container(
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: 10.0, horizontal: 80.0),
                      //     child: Text(barcode)),
                      // Container(
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: 10.0, horizontal: 80.0),
                      //     child: Text(lockedTime)),
                      // RaisedButton(
                      //     child: const Text(
                      //       'I Got Here!',
                      //       style: TextStyle(
                      //         fontSize: 20.0,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     color: Colors.lightBlue[200],
                      //     shape: const OutlineInputBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(10)),
                      //     ),
                      // onPressed: () {
                      //   //dialog that user reach the shop
                      //   showDialog(
                      //     context: context,
                      //     builder: (_) {
                      //       return AlertDialog(
                      //         title: Text(''),
                      //         content: Text(
                      //           'Are You Here?',
                      //           style: TextStyle(
                      //             fontSize: 18.0,
                      //           ),
                      //         ),
                      //         actions: <Widget>[
                      //           FlatButton(
                      //             child: Text("No"),
                      //             onPressed: () => Navigator.pop(context),
                      //           ),
                      //           FlatButton(
                      //             child: Text("Yes"),
                      //             onPressed: () => {
                      //               // go back to map page? or success pages
                      //             },
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //   );
                      // }),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning),
                            Text(
                              "Any Issue? Contact",
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.amber,
                              ),
                            ),
                            Icon(Icons.warning),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Icon(Icons.local_phone, size: 30.0),
                              onPressed: () {
                                launch("tel:${widget.shopData['tel']}");
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.mail,
                                size: 30.0,
                              ),
                              onPressed: () {
                                launch(
                                    "mailto:${widget.shopData['contactEmail']}");
                              }),
                        ],
                      )
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
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
            markerId: MarkerId(widget.shopData['id']),
            position: LatLng(widget.shopData['lat'].toDouble(),
                widget.shopData['lng'].toDouble()),
            infoWindow: InfoWindow(
              title: '${widget.shopData['name']}',
              // snippet: ,
            ),
          )
        },
        onMapCreated: (GoogleMapController controller) {
          if (widget.shopData != null) {
            _createPolylines(
                _yourLocation.latitude,
                _yourLocation.longitude,
                widget.shopData['lat'].toDouble(),
                widget.shopData['lng'].toDouble());
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
      print("Start called");
      setState(() {
        totalTime = widget.bookData['expiredAt'].difference(DateTime.now()).inSeconds;
        if (totalTime < 0) {
          //go fail page
          timer.cancel();
        } else if (totalTime < 3600) {
          int m = totalTime ~/ 60;
          int s = totalTime - (60 * m);
          if (s == 0) {
            timetodisplay = m.toString() + ":" + "0" + s.toString();
          } else {
            timetodisplay = m.toString() + ":" + s.toString();
          }
        }
      });
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
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }
}
