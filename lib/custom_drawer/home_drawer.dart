import '../app_theme.dart';
import 'package:flutter/material.dart';
// import 'package:amplify_core/amplify_core.dart';
import "package:amplify_flutter/amplify.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import '../global.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../app.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  var shopData;
  bool stripeRegister = false;
  var images;

  @override
  void initState() {
    setDrawerListArray();
    _getShopData();
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.Profile,
        labelName: 'アカウント情報',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.ControlePanel,
        labelName: '空席管理',
        icon: Icon(Icons.videogame_asset),
      ),
      DrawerList(
          index: DrawerIndex.Calendar,
          labelName: '営業時間管理',
          icon: Icon(Icons.calendar_today_rounded)),
      DrawerList(
        index: DrawerIndex.BookingList,
        labelName: '予約管理',
        icon: Icon(Icons.assignment),
      ),
      DrawerList(
        index: DrawerIndex.QRCode,
        labelName: 'QRコード',
        icon: Icon(Icons.qr_code),
      ),
    ];
  }

  Future<void> _showPic() async {
    final getUrlOptions = GetUrlOptions(
      accessLevel: StorageAccessLevel.guest,
    );
    var listOfUrl = [];
    if (shopData["imageUrl"].length > 0) {
      var result = await Amplify.Storage.getUrl(
          key: shopData["imageUrl"][0], options: getUrlOptions);
      var url = result.url;
      listOfUrl.add(url);
    }
    print("done getting getting image Url");
    print("List of Image Url: $listOfUrl");
    setState(() {
      images = listOfUrl;
    });
  }

  Future<void> _getShopData() async {
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/${globals.userId}');
    final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      setState(() {
        shopData = jsonResponse['body'];
      });
      await _showPic();
      print("This is ShopData: $shopData");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _goToStripeLink() async {
    var response = await http.post(
      "https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/stripeaccount?storeStripeId=${shopData["stripeId"]}&storeId=${shopData["storeId"]}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
    final clientStripeConnectUrl =
        await jsonDecode(jsonResponse["body"])["accountLinkURL"];
    await launch("$clientStripeConnectUrl");
  }

  void _changePage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
    print("Going to $route was triggered");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CafeExpressTheme.notWhite.withOpacity(0.5),
      body: shopData == null || images == null
          ? CircularProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: widget.iconAnimationController,
                          builder: (BuildContext context, Widget child) {
                            return ScaleTransition(
                              scale: AlwaysStoppedAnimation<double>(1.0 -
                                  (widget.iconAnimationController.value) * 0.2),
                              child: RotationTransition(
                                turns: AlwaysStoppedAnimation<double>(
                                    Tween<double>(begin: 0.0, end: 24.0)
                                            .animate(CurvedAnimation(
                                                parent: widget
                                                    .iconAnimationController,
                                                curve: Curves.fastOutSlowIn))
                                            .value /
                                        360),
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.6),
                                          offset: const Offset(2.0, 4.0),
                                          blurRadius: 8),
                                    ],
                                  ),
                                  child: images.length == 0
                                      ? Center(
                                          child: Container(
                                              height: 00,
                                              child: Text("写真がありません")))
                                      : ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(60.0)),
                                          child: Image.network(
                                            images[0],
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 8),
                          child: Text(
                            '${shopData["name"]}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).focusColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Divider(
                  height: 1,
                  color: Theme.of(context).focusColor.withOpacity(0.6),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(0.0),
                    itemCount: drawerList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return inkwell(drawerList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, left: 12),
                  child: Row(children: [
                    Column(children: [
                      ButtonTheme(
                        minWidth: 120,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text("口座管理",
                              style: TextStyle(color: Colors.white)),
                          onPressed: _goToStripeLink,
                        ),
                      )
                    ]),
                    Expanded(child: SizedBox()),
                  ]),
                ),
                Divider(
                  height: 1,
                  color: Theme.of(context).focusColor.withOpacity(0.6),
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Row(children: [
                        Icon(
                          Icons.power_settings_new,
                          color: Theme.of(context).selectedRowColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'ログアウト',
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: CafeExpressTheme.darkText,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ]),
                      onTap: () {
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
                            } on AuthError catch (e) {
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
                          buttonsBorderRadius:
                              BorderRadius.all(Radius.circular(100)),
                        )..show();
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ],
            ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Theme.of(context).primaryColor
                                  : CafeExpressTheme.nearlyBlack),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? Theme.of(context).primaryColor
                              : CafeExpressTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Theme.of(context).primaryColor
                          : CafeExpressTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  Profile,
  ControlePanel,
  Calendar,
  QRCode,
  BookingList,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
