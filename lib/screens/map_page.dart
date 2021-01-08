import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import './detail_page.dart';
import 'package:http/http.dart' as http;
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

    _getAllShopData();

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

  String dropdownValue = 'One';
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
              value: dropdownValue,
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
                  dropdownValue = newValue;
                  //filterbynagasa
                });
              },
              items: <String>['One', 'Two', 'Free', 'Four']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ]),
          Column(children: [
            Text("Filter by Distance!"),
            DropdownButton<String>(
              value: dropdownValue,
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
                  dropdownValue = newValue;
                  //filterbynagasa
                });
              },
              items: <String>['One', 'Two', 'Free', 'Four']
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
              title: data['name'],
              snippet: data['category'],
              onTap: () {},
            ),
          );
        }).toSet(),
        onMapCreated: (GoogleMapController controller) {
          // _getAllShopData();
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
    print("----------------");
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store');
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final shopData = jsonResponse['body'];
      listShops = shopData;
      return listShops;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _filterShopData(List shops) async {}

  Future<void> _filterAvailable(List shops) async {}

  Future<void> _filterMember(List shops) async {}

  Future<void> _filterDistance(List shops) async {}
}
