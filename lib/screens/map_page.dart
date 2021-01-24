import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../app.dart';
import '../app_theme.dart';
import 'filters_screen.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_core/amplify_core.dart';
import "package:awesome_dialog/awesome_dialog.dart";
import '../models/category.dart';
import '../global.dart' as globals;

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<dynamic> listShops = [];
  var shopData;
  Map selectedShop;
  var result;

  PageController _pageController = PageController();
  bool _isPageViewAnimating;

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

  @override
  void initState() {
    super.initState();
    // 現在位置の取得
    _getLocation();

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
    _pageController.dispose();
    _locationChangedListen?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _yourLocation == null && listOfUrl == null
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: CircularMenu(
                    alignment: Alignment.topLeft,
                    radius: 100,
                    backgroundWidget: Column(
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
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 150,
                                          child: PageView(
                                            controller: _pageController,
                                            children:
                                                listShops.map<Widget>((shop) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _onTap(context, shop['id']);
                                                  },
                                                  child: Card(
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    margin: EdgeInsets.zero,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  16.0)),
                                                    ),
                                                    child: Stack(
                                                      fit: StackFit.loose,
                                                      children: <Widget>[
                                                        Center(
                                                            child: shop["imageUrl"]
                                                                        .length ==
                                                                    0
                                                                ? Text(
                                                                    "写真がありません")
                                                                : listOfUrl ==
                                                                        null
                                                                    ? CircularProgressIndicator()
                                                                    : Container(
                                                                        constraints:
                                                                            BoxConstraints.expand(),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            onError:
                                                                                (error, stackTrace) {
                                                                              return Text("写真がありません");
                                                                            },
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            image:
                                                                                NetworkImage(listOfUrl[shop["id"]]),
                                                                          ),
                                                                        ),
                                                                      )),
                                                        Positioned(
                                                          left: 0,
                                                          right: 0,
                                                          bottom: 0,
                                                          child: Container(
                                                            child: Text(
                                                                shop['name'],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            0x99,
                                                                            0,
                                                                            0,
                                                                            0)),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
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
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              bottom: 10,
                                              top: 10),
                                          child: Container(
                                            height: 40,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              color: CafeExpressTheme
                                                      .buildLightTheme()
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(24.0)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                  blurRadius: 8,
                                                  offset: const Offset(4, 4),
                                                ),
                                              ],
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(24.0)),
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  _goToFilter(context);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    '条件を絞る',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ]),
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
                        icon: Icons.timer,
                        onTap: () {
                          _changePage(context, TimerRoute);
                        }),
                  ])));
  }

  _goToFilter(BuildContext context) async {
    result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => FiltersScreen(),
          fullscreenDialog: true),
    );
    _filterShop(result["distance"], result["category"], result["groupSize"]);
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
        // padding: EdgeInsets.only(bottom: 180.0),
        markers: listShops.map((shop) {
          return Marker(
            markerId: MarkerId(shop['id']),
            position: LatLng(shop['lat'].toDouble(), shop['lng'].toDouble()),
            icon: selectedShop != null && shop['id'] == selectedShop['id']
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
          print("MAP CREATED");
          _getAllShopData();
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
      );
    }
  }

  Map listOfUrl;

  Future<void> _showPic() async {
    print("inside Show Pic: $listOfUrl");
    final getUrlOptions = GetUrlOptions(
      accessLevel: StorageAccessLevel.guest,
    );

    Map urlMap = {};

    for (var shop in shopData) {
      if (shop["imageUrl"] != null && shop["imageUrl"].length > 0) {
        String key = shop["imageUrl"][0];
        var result =
            await Amplify.Storage.getUrl(key: key, options: getUrlOptions);
        urlMap[shop["id"]] = result.url;
      } else {
        urlMap[shop["id"]] = null;
      }
    }

    listOfUrl = urlMap;
    print("listOfUrl: $listOfUrl");
  }

  Widget imageCard(shop) {
    return Expanded(
      child: Image.network(
        listOfUrl[shop["id"]],
        // listOfUrl[shop["id"]],
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<void> _getLocation() async {
    _yourLocation = await _locationService.getLocation();
  }

  Future<void> _getAllShopData() async {
    print('allShopData called');
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store');
    if (response.statusCode == 200) {
      if (mounted && _yourLocation != null) {
        final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
        var filteredShops = await jsonResponse['body']
            .where((shop) => shop['lat'] != null && shop['lng'] != null)
            .toList();
        print('filteredShopData $filteredShops');
        setState(() {
          shopData = filteredShops;
          listShops = shopData;
        });
        await _showPic();

        _filterShop(
            500,
            [
              CategoryData(
                titleTxt: 'All',
                isSelected: true,
              ),
            ],
            1);
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _filterShop(int distance, List category, int groupNum) {
    listShops = shopData;
    listShops = _filterShopByCategory(category);
    listShops = _filterShopByDistance(distance);
    listShops = _filterShopByGroupSize(groupNum);
  }

  List _filterShopByCategory(List category) {
    List selectedCategory = [];
    if (category[0].isSelected == true) {
      return listShops;
    } else {
      for (var data in category) {
        if (data.isSelected == true) {
          selectedCategory.add(data.titleTxt);
        }
      }
      return listShops
          .where((shop) => selectedCategory
              .map((category) => category == shop['category'])
              .contains(true))
          .toList();
    }
  }

  List _filterShopByGroupSize(int groupNum) {
    if (globals.isFilterOn == false) {
      return listShops;
    } else {
      return listShops
          .where((shop) => shop["vacancy"]['${shop['vacancyType']}']
              .map((sheet) =>
                  sheet['isVacant'] == true &&
                  sheet['Min'] <= groupNum &&
                  sheet['Max'] >= groupNum)
              .toList()
              .contains(true))
          .toList();
    }
  }

  List _filterShopByDistance(int distance) {
    return listShops.where((shop) => _getDistance(shop) <= distance).toList();
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
    googlemap.animateCamera(
        CameraUpdate.newLatLng(LatLng(shop['lat'], shop['lng'])));
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
    print("inside onTap");
    Navigator.pushNamed(context, DetailRoute, arguments: {"id": shopId});
  }

  void _goHistoryPage(BuildContext context) {
    Navigator.pushNamed(context, BookingHistoryRoute);
    print("goHistoryPage was triggered");
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
}
