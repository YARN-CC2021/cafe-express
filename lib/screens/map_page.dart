import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
//to import .jsonfile
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<dynamic> listShops = [];

  Completer<GoogleMapController> _controller = Completer();
  Location _locationService = Location();

  // 現在位置
  LocationData _yourLocation;

  // 現在位置の監視状況
  StreamSubscription _locationChangedListen;

  @override
  void initState() {
    super.initState();

    _getShopList();

    // 現在位置の取得
    _getLocation();

    // 現在位置の変化を監視
    _locationChangedListen =
        _locationService.onLocationChanged.listen((LocationData result) async {
      setState(() {
        _yourLocation = result;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    // 監視を終了
    _locationChangedListen?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cafe Express"),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: _makeGoogleMap(),
    );
  }

  Widget _makeGoogleMap() {
    if (_yourLocation == null) {
      // 現在位置が取れるまではローディング中
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Google Map ウィジェットを返す
      return GoogleMap(
        // 初期表示される位置情報を現在位置から設定
        initialCameraPosition: CameraPosition(
          target: LatLng(_yourLocation.latitude, _yourLocation.longitude),
          zoom: 18.0,
        ),
        markers: listShops.map((data) {
          print("data$data\n");
          return Marker(
              markerId: MarkerId(data['id']),
              position: LatLng(data['lat'], data['lng']),
              infoWindow: InfoWindow(
                title: data['name'],
                snippet: data['category'],
                onTap: () {
                  print(data['name']);
                },
              ),
            );
        }).toSet(),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        // 現在位置にアイコン（青い円形のやつ）を置く
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      );
    }
  }

  void _getLocation() async {
    _yourLocation = await _locationService.getLocation();
  }
  ///////////////

  Future<void> _getShopList() async {
    final response = await rootBundle.loadString('assets/testdata.json');
    final responseJson = json.decode(response);
    final Iterable shops = responseJson['store'];
    listShops = shops;
    return listShops;
  }
}
