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
  var vacancyType;
  var tmp;
  String category = "All";
  String distance = '100m';
  String groupNum = "All";

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
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Column(children: [
        Expanded(child: _makeGoogleMap()),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            Text("Distance"),
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
                  _filterShop(distance, category, groupNum);
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
            Text("Category"),
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
                  _filterShop(distance, category, groupNum);
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
          Column(children: [
            Text("GroupSize"),
            DropdownButton<String>(
              value: groupNum,
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
                  groupNum = newValue;
                  _filterShop(distance, category, groupNum);
                });
              },
              items: <String>[
                'All',
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '10',
                '11',
                '12'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ]),
        ]),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7),
            IconButton(
              ///Timer
              icon: Icon(
                Icons.qr_code_rounded,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, QrRoute)},
            ),
            Container(
              width: 56.0,
              height: 10,
            ),
            IconButton(
              /// booking history
              icon: Icon(
                Icons.assignment,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, BookingHistoryRoute)},
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
          ///map search
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

  Widget _makeGoogleMap() {
    if (_yourLocation == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_yourLocation.latitude, _yourLocation.longitude),
          zoom: 18.0,
        ),
        markers: listShops.map((shop) {
          return Marker(
            markerId: MarkerId(shop['id']),
            position: LatLng(shop['lat'].toDouble(), shop['lng'].toDouble()),
            infoWindow: InfoWindow(
              title: '${shop['name']}',
              snippet: shop['category'],
              onTap: () {
                _onTap(context, shop['id']);
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
      shopData = listShops = shopData;
      _filterShop(distance, category, groupNum);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _filterShop(String distance, String category, String groupNum) {
    listShops = shopData;
    listShops = _filterShopByDistance(distance);
    listShops = _filterShopByCategory(category);
    listShops = _filterShopByGroupSize(groupNum);
    // print(_filterShopByGroupSize(groupNum));
  }

  List _filterShopByCategory(String category) {
    if (category == 'All') {
      return listShops;
    } else {
      return listShops.where((data) => data['category'] == category).toList();
    }
  }

  List _filterShopByDistance(String distance) {
    int numDistance;
    if (distance.contains('km')) {
      numDistance = int.parse(distance.replaceAll('km', '000'));
    } else {
      numDistance = int.parse(distance.replaceAll('m', ''));
    }
    return listShops
        .where((shop) => _getDistance(shop) <= numDistance)
        .toList();
  }

  List _filterShopByGroupSize(String groupNum) {
    if (groupNum == 'All') {
      return listShops;
    } else {
      return listShops
          .where((shop) => shop["vacancy"]['${shop['vacancyType']}']
              .map((sheet) =>
                  sheet['isVacant'] == true &&
                  sheet['Min'] <= int.parse(groupNum) &&
                  sheet['Max'] >= int.parse(groupNum))
              .toList()
              .contains(true))
          .toList();
    }
  }

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
