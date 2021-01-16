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
  Map selectedShop;
  String distance = '100m';
  String category = "All";
  String groupNum = "All";

  PageController _pageController = PageController();
  bool _isPageViewAnimating;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
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

    _pageController = PageController(
      viewportFraction: 0.95,
    );
    _isPageViewAnimating = false;

    // 現在位置の変化を監視 backgroundでも動くのかどうか
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
    _pageController.dispose();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(      
            child: Stack(
            fit: StackFit.loose,
            overflow: Overflow.visible,
            children: [
              _makeGoogleMap(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              child: 
              PageView(
                controller: _pageController,
                children: listShops.map<Widget>((shop) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                        onTap: () {
                          _onTap(context, shop['id']);
                        },
                        child: Card(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                imageCard(shop),
                              ]
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                child: Text(
                                  shop['name'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .subhead
                                      .merge(TextStyle(color: Colors.white)),
                                ),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(0x99, 0, 0, 0)),
                                padding: const EdgeInsets.all(8),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onPageChanged: (int page) {
                  if (_isPageViewAnimating) {
                    return;
                  }
                  _updateSelectedShopForPage(page);
                },
              ),
              decoration: BoxDecoration(color: Colors.transparent),
            ),
          ),
          ],
          ),
        ),

        //test
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
          Column(children: [
            Text("距離"),
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
            Text("カテゴリー"),
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
            Text("人数"),
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
              items: <String>['All','1','2','3','4','5','6','7','8','9','10','11','12'
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
    );
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
        padding: EdgeInsets.only(bottom: 150.0),
        markers: listShops.map((shop) {
          return Marker(
            markerId: MarkerId(shop['id']),
            position: LatLng(shop['lat'].toDouble(), shop['lng'].toDouble()),
            icon: shop['id'] == selectedShop['id']
                ? BitmapDescriptor.defaultMarker
                : BitmapDescriptor.defaultMarkerWithHue(120.0),
            onTap: () {
              selectedShop = shop;
              _pageController.jumpToPage(listShops.indexOf(shop));
            },
            infoWindow: InfoWindow(
              title: '${shop['name']}',
              snippet: shop['category'],
              onTap: () {
                _onTap(context, shop['id']);
              },
            ),
          );
        }).toSet(),
        onMapCreated: (GoogleMapController controller) {
          _getAllShopData();
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapToolbarEnabled: false,
      );
    }
  }

  Widget imageCard(shop) {
    return Center(
      child: Image.network(
          '${shop['imagePaths'][0]}',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator();
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace stackTrace) {
            return Text('写真がありません');
          },
      ),
    );
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
      selectedShop = listShops[0];
      _filterShop(distance, category, groupNum);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _filterShop(String distance, String category, String groupNum) {
    listShops = shopData;
    listShops = _filterShopByCategory(category);
    listShops = _filterShopByDistance(distance);
    listShops = _filterShopByGroupSize(groupNum);
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
    return distanceInMeters.toInt();
  }

  void _updateSelectedShopForPage(int page) {
    if (page >= 0 && page < listShops.length) {
      _updateSelectedShop(listShops.elementAt(page));
    } else {
      _updateSelectedShop(null);
    }
  }

  _updateSelectedShop(newShop) {
    if (selectedShop == newShop) {
      return;
    }
    _hideInfoWindowForSelectedShop();
    setState(() {
      selectedShop = newShop;
      _gotoLocation(selectedShop);
    });
    _showInfoWindowForSelectedShop();
  }

  Future<void> _gotoLocation(shop) async {
    final GoogleMapController googlemap = await _controller.future;
    googlemap.animateCamera(CameraUpdate.newLatLng(LatLng(shop['lat'], shop['lng'])));
  }

  Future<void> _showInfoWindowForSelectedShop() async {
    if (selectedShop != null && _controller.isCompleted) {
      final GoogleMapController googleMap = await _controller.future;

      final MarkerId selectedShopMarker = MarkerId(selectedShop['id']);
      final bool isSelectedShopMarkerShown =
          await googleMap.isMarkerInfoWindowShown(selectedShopMarker);
      if (!isSelectedShopMarkerShown) {
        await googleMap.showMarkerInfoWindow(selectedShopMarker);
      }
    }
  }

  Future<void> _hideInfoWindowForSelectedShop() async {
    if (selectedShop != null && _controller.isCompleted) {
      final GoogleMapController googleMap = await _controller.future;

      final MarkerId selectedShopMarker = MarkerId(selectedShop['id']);
      final bool isSelectedShopMarkerShown =
          await googleMap.isMarkerInfoWindowShown(selectedShopMarker);
      if (isSelectedShopMarkerShown) {
        await googleMap.hideMarkerInfoWindow(selectedShopMarker);
      }
    }
  }

  void _onTap(BuildContext context, String shopId) {
    Navigator.pushNamed(context, DetailRoute, arguments: {"id": shopId});
  }

}
