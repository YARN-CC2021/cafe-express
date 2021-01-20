import 'package:flutter/material.dart';
import '../app.dart';
import '../global.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class MerchantProfileSettingPage extends StatefulWidget {
  @override
  _MerchantProfileSettingPageState createState() =>
      _MerchantProfileSettingPageState();
}

class _MerchantProfileSettingPageState
    extends State<MerchantProfileSettingPage> {
  var shopData;
  bool stripeRegister = false;
  var images;

  @override
  void initState() {
    super.initState();
    _getShopData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getShopData() async {
    print("Inside Merchant Strict: ${globals.userId}");
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
    print(clientStripeConnectUrl);
    await launch("$clientStripeConnectUrl");
  }

  Future<void> _showPic() async {
    print("inside showpic");
    final getUrlOptions = GetUrlOptions(
      accessLevel: StorageAccessLevel.guest,
    );
    var listOfUrl = [];
    print("shopData: ${shopData["imageUrl"]}");
    if (shopData["imageUrl"].length > 0) {
      var result = await Amplify.Storage.getUrl(
          key: shopData["imageUrl"][0], options: getUrlOptions);
      var url = result.url;
      listOfUrl.add(url);
    }
    print("List of Url: $listOfUrl");
    print("done getting getting image Url");
    setState(() {
      images = listOfUrl;
    });
    print("imagesssss: $images");
    print("done listing");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("アカウント管理",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: shopData == null && images == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.only(
                  top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      images != null && images.length > 0
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 3.0, right: 3.0, bottom: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  images[0],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                        child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    ));
                                  },
                                ),
                              ))
                          : Padding(
                              padding: EdgeInsets.only(
                                  left: 3.0, right: 3.0, bottom: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: IconButton(
                                      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                      iconSize: 35,
                                      color: Colors.grey,
                                      icon: FaIcon(FontAwesomeIcons.camera),
                                      onPressed: () {},
                                    )),
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "ユーザー名",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                MaterialButton(
                                  child: Text(
                                      shopData["vacancyType"] == "strict"
                                          ? "テーブル設定：固定モード"
                                          : "テーブル設定：範囲モード",
                                      style: TextStyle(fontSize: 11)),
                                  onPressed: null,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  shopData["loginEmail"],
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
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
                                      btnOkColor: Colors.tealAccent[400],
                                      btnCancelOnPress: () {},
                                      btnOkText: 'ログアウト',
                                      btnCancelText: 'キャンセル',
                                      btnCancelColor: Colors.blueGrey[400],
                                      dismissOnTouchOutside: false,
                                      headerAnimationLoop: false,
                                      showCloseIcon: false,
                                      buttonsBorderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                    )..show();
                                  },
                                  child: Text(
                                    "ログアウト",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(children: [
                        Text(
                          "アカウント情報".toUpperCase(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                          icon: FaIcon(FontAwesomeIcons.edit),
                          onPressed: () {
                            _changePage(context, MerchantProfileRoute);
                          },
                          tooltip: "掲載情報の編集",
                        )
                      ])),
                  Container(
                    height: 55,
                    child: ListTile(
                      title: Text(
                        "店名",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        "${shopData["name"]}",
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    child: ListTile(
                      title: Text(
                        "カテゴリー",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        "${shopData["category"]}",
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    child: ListTile(
                      title: Text(
                        "URL",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        "${shopData["storeURL"]}",
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    child: ListTile(
                      title: Text(
                        "公開Eメール",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        "${shopData["contactEmail"]}",
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    child: ListTile(
                      title: Text(
                        "電話番号",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        "${shopData["tel"]}",
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    child: ListTile(
                      title: Text(
                        "住所",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        "${shopData["address"]}",
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    child: ListTile(
                      title: Text(
                        "詳細",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        "${shopData["description"]}",
                      ),
                    ),
                  ),
                  Center(
                      child: Row(
                    children: [
                      SizedBox(width: 125),
                      Expanded(
                        child: ButtonTheme(
                          minWidth: 50,
                          child: RaisedButton(
                            color: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.lightBlue)),
                            child: Text("Stripeへ行く",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white)),
                            onPressed: _goToStripeLink,
                          ),
                        ),
                      ),
                      SizedBox(width: 125),
                    ],
                  )),
                ],
              ),
            ),
    );
  }

  void _changePage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
    print("Going to $route was triggered");
  }
}
