import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math' as math;
import './detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../app.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<dynamic> listShops = [];
  var shopData;
  String category = "All";
  String distance = '100m';

  Completer<GoogleMapController> _controller = Completer();
  Location _locationService = Location();

  // 現在位置
  LocationData _yourLocation;

  // 現在位置の監視状況
  StreamSubscription _locationChangedListen;

  @override
  void initState() {
    super.initState();

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
      body: Column(children: [
        Expanded(child: _makeGoogleMap()),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            Text("Filter by Distance!"),
            DropdownButton<String>(
              value: distance,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  distance = newValue;
                  _filterShop(distance, category);
                });
              },
              items: <String>['100m', '500m', '1km', '2km']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ]),
          Column(children: [
            Text("Filter by Category"),
            DropdownButton<String>(
              value: category,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  category = newValue;
                  _filterShop(distance, category);
                });
              },
              items: <String>['All', 'Cafe', 'Restaurant', 'Bar']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ]),
        ]),
      ]),
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
          return Marker(
            markerId: MarkerId(data['id']),
            position: LatLng(data['lat'], data['lng']),
            infoWindow: InfoWindow(
              title: '${data['name']}',
              snippet: data['category'],
              onTap: () {
                _onTap(context, data['id']);
                //move to detail page with its id
              },
            ),
          );
        }).toSet(),
        onMapCreated: (GoogleMapController controller) {
          print('Map Created');
          _getAllShopData();
          _controller.complete(controller);
        },
        // 現在位置にアイコン（青い円形のやつ）を置く
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapToolbarEnabled: false,
      );
    }
  }

  void _getLocation() async {
    _yourLocation = await _locationService.getLocation();
  }

  Future<void> _getAllShopData() async {
    print('allShopData called');
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store');
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      shopData = await jsonResponse['body']
          .where((shop) => shop['lat'] != null && shop['lng'] != null)
          .toList();
      listShops = shopData;
      _filterShop(distance, category);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _filterShop(String distance, String category) {
    if (category == 'All') {
      listShops = _filterShopByDistance(distance, shopData);
    } else {
      final tmp = _filterShopByDistance(distance, shopData);
      listShops = _filterShopByCategory(category, tmp);
    }
  }

  List _filterShopByCategory(String category, List shops) {
    return shops.where((data) => data['category'] == category).toList();
  }

  List _filterShopByDistance(String distance, List shops) {
    int numDistance;
    if (distance.contains('km')) {
      numDistance = int.parse(distance.replaceAll('km', '000'));
    } else {
      numDistance = int.parse(distance.replaceAll('m', ''));
    }

    return shops.where((shop) => _getDistance(shop) <= numDistance).toList();
  }

  Future<void> _filterAvailable(List shops) async {}

  Future<void> _filterGroupSize(List shops) async {}

  int _getDistance(Map shop) {
    double distanceInMeters = Geolocator.distanceBetween(
      _yourLocation.latitude,
      _yourLocation.longitude,
      shop['lat'].toDouble(),
      shop['lng'].toDouble(),
    );
    // print(distanceInMeters.toInt());
    return distanceInMeters.toInt();
  }
  void _onTap(BuildContext context, String shopId) {
    Navigator.pushNamed(context, DetailRoute, arguments: {"id": shopId});
  }
}
