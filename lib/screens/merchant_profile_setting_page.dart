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

class MerchantProfileSettingPage extends StatefulWidget {
  @override
  _MerchantProfileSettingPageState createState() =>
      _MerchantProfileSettingPageState();
}

class _MerchantProfileSettingPageState
    extends State<MerchantProfileSettingPage> {
  var shopData;
  bool stripeRegister = false;

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
      print("This is ShopData: $shopData");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

//"https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/stripeaccount?storeStripeId=acct_1IAYF4QG0EUj44rM&storeId=near_azamino"
  Future<void> _goToStripeLink() async {
    var response = await http.post(
      "https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/stripeaccount?storeStripeId=${shopData["stripeId"]}&storeId=${shopData["storeId"]}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
    final myUrl = jsonDecode(jsonResponse["body"])["accountLinkURL"];
    print(myUrl);
    await launch("$myUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          "アカウント管理",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: shopData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.only(
                  top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              "https://www.sho-pat.com/e/img/attorneys/ph_takano.jpg",
                              fit: BoxFit.cover,
                              width: 100.0,
                              height: 100.0,
                            ),
                          )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      style: TextStyle(fontSize: 10)),
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
                                          _changePage(context, WrapperRoute);
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
                        flex: 3,
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
                  ListTile(
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
                  ListTile(
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
                  ListTile(
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
                  ListTile(
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
                  ListTile(
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
                  ListTile(
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
                  ListTile(
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
                  MaterialButton(
                    child: Text("Stripeへ行く", style: TextStyle(fontSize: 10)),
                    onPressed: _goToStripeLink,
                  ),
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? SizedBox()
                      : ListTile(
                          title: Text(
                            "Dark Theme",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          // trailing: Switch(
                          //   value: Provider.of<AppProvider>(context).theme == Constants.lightTheme
                          //       ? false
                          //       : true,
                          //   onChanged: (v) async{
                          //     if (v) {
                          //       Provider.of<AppProvider>(context, listen: false)
                          //           .setTheme(Constants.darkTheme, "dark");
                          //     } else {
                          //       Provider.of<AppProvider>(context, listen: false)
                          //           .setTheme(Constants.lightTheme, "light");
                          //     }
                          //   },
                          //   activeColor: Theme.of(context).accentColor,
                          // ),
                        ),
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7),
            IconButton(
              icon: Icon(
                Icons.qr_code_rounded,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, QrRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_today_rounded,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, MerchantCalendarRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                size: 24.0,
                color: Theme.of(context).primaryColor,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, MerchantCalendarRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.assignment,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () => {_changePage(context, BookingListRoute)},
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
                size: 24.0,
              ),
              color: Colors.black,
              onPressed: () =>
                  {_changePage(context, MerchantProfileSettingRoute)},
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
}
