import 'package:flutter/material.dart';
import '../app.dart';
import '../global.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import '../app_theme.dart';

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

  Future<void> _showPic() async {
    final getUrlOptions = GetUrlOptions(
      accessLevel: StorageAccessLevel.guest,
    );
    var listOfUrl = [];
    if (shopData["imageUrl"] != null && shopData["imageUrl"].length > 0) {
      for (var key in shopData["imageUrl"]) {
        var result =
            await Amplify.Storage.getUrl(key: key, options: getUrlOptions);
        var url = result.url;
        listOfUrl.add(url);
      }
    }
    print("List of Url: $listOfUrl");
    print("done getting getting image Url");
    setState(() {
      images = listOfUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new Container(),
        title: Text("アカウント管理",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        centerTitle: true,
        backgroundColor: CafeExpressTheme.buildLightTheme().backgroundColor,
        elevation: 3.0,
      ),
      body: shopData == null && images == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    child: Row(
                      children: <Widget>[
                        images != null && images.length > 0
                            ? Padding(
                                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    images[0],
                                    width: 83,
                                    height: 83,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                          child: SizedBox(
                                        width: 83,
                                        height: 83,
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
                                  left: 3.0,
                                  right: 3.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    width: 83,
                                    height: 83,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                        images != null && images.length >= 2
                            ? Padding(
                                padding: EdgeInsets.only(
                                  left: 3.0,
                                  right: 3.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    images[1],
                                    width: 83,
                                    height: 83,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                          child: SizedBox(
                                        width: 83,
                                        height: 83,
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
                                  left: 3.0,
                                  right: 3.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    width: 83,
                                    height: 83,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                        images != null && images.length >= 3
                            ? Padding(
                                padding: EdgeInsets.only(
                                  left: 3.0,
                                  right: 3.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    images[2],
                                    width: 83,
                                    height: 83,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                          child: SizedBox(
                                        width: 83,
                                        height: 83,
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
                                  left: 3.0,
                                  right: 3.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    width: 83,
                                    height: 83,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                        images != null && images.length >= 4
                            ? Padding(
                                padding: EdgeInsets.only(
                                  left: 3.0,
                                  right: 3.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    images[3],
                                    width: 83,
                                    height: 83,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                          child: SizedBox(
                                        width: 83,
                                        height: 83,
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
                                  left: 3.0,
                                  right: 3.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    width: 83,
                                    height: 83,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
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
                          icon: FaIcon(FontAwesomeIcons.edit),
                          onPressed: () {
                            _changePage(context, MerchantProfileRoute);
                          },
                          tooltip: "掲載情報の編集",
                        ),
                        MaterialButton(
                          child: Text(
                              shopData["vacancyType"] == "strict"
                                  ? "テーブル設定：固定モード"
                                  : "テーブル設定：範囲モード",
                              style: TextStyle(fontSize: 11)),
                          onPressed: null,
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
