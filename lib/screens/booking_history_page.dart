import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import '../global.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import '../app.dart';
import '../app_theme.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class BookingHistoryPage extends StatefulWidget {
  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  var bookingData;
  final channel = IOWebSocketChannel.connect(
      "wss://gu2u8vdip2.execute-api.ap-northeast-1.amazonaws.com/CafeExpressWS?id=${globals.userId}");

  var bookingId;

  @override
  void initState() {
    super.initState();
    _getBookingData();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("予約履歴",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        centerTitle: true,
        backgroundColor: CafeExpressTheme.buildLightTheme().backgroundColor,
        elevation: 3.0,
      ),
      body: bookingData == null
          ? Center(child: CircularProgressIndicator())
          : bookingData.length == 0
              ? Center(
                  child: Text("予約情報がありません", style: TextStyle(fontSize: 20)))
              : StreamBuilder(
                  stream: channel.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        json.decode(snapshot.data)["bookingId"] != bookingId) {
                      print(
                          "SNAPSHOT DATA in Stream, History Page ${snapshot.data}");
                      // _insertBooking(json.decode(snapshot.data));
                      _statusUpdate(json.decode(snapshot.data)["bookingId"],
                          json.decode(snapshot.data)["status"]);
                      bookingId = json.decode(snapshot.data)["bookingId"];
                    }
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: buildListView());
                  }),
    );
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

  void _changePage(BuildContext context, String route) {
    channel.sink.close();
    Navigator.pushNamed(context, route);
    print("Going to $route was triggered");
  }

  Future<void> _getBookingData() async {
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/booking?customerId=${globals.userId}');
    if (response.statusCode == 200) {
      final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        bookingData = jsonResponse['body'];
      });
      await _sortBookingData(bookingData);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _sortBookingData(bookingData) async {
    setState(() {
      bookingData
        ..sort((v1, v2) =>
            DateTime.parse(v2["bookedAt"]).millisecondsSinceEpoch -
            DateTime.parse(v1["bookedAt"]).millisecondsSinceEpoch);
    });
  }

  void _statusUpdate(String bookingId, String status) {
    for (final booking in bookingData) {
      if (booking["bookingId"] == bookingId) {
        booking["status"] = status;
        print("BOOKING STATUS in for loop ${booking["status"]}");
        break;
      }
    }
  }

  ListView buildListView() {
    String prevDay;
    String today = DateFormat("EEE, MMM d, y").format(DateTime.now());
    String yesterday = DateFormat("EEE, MMM d, y")
        .format(DateTime.now().add(Duration(days: -1)));

    return ListView.builder(
      cacheExtent: 250.0 * 1000.0,
      itemCount: bookingData.length,
      itemBuilder: (context, index) {
        var booking = bookingData[index];
        var bookedAt =
            DateTime.parse(booking["bookedAt"]).millisecondsSinceEpoch;
        var expiredAt =
            DateTime.parse(booking["expiredAt"]).millisecondsSinceEpoch;

        DateTime date = DateTime.fromMillisecondsSinceEpoch(bookedAt);
        DateTime date2 = DateTime.fromMillisecondsSinceEpoch(expiredAt);
        String dateString = DateFormat("EEE, MMM d, y").format(date);
        if (today == dateString) {
          dateString = "Today";
        } else if (yesterday == dateString) {
          dateString = "Yesteday";
        }
        bool showHeader = prevDay != dateString;
        prevDay = dateString;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            showHeader
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      dateString,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
                : Offstage(),
            buildItem(index, context, date, date2, booking),
          ],
        );
      },
    );
  }

  Widget buildItem(int index, BuildContext context, DateTime date,
      DateTime date2, Map booking) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(width: 20),
          buildLine(index, context),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              // color: Theme.of(context).accentColor,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(right: 26),
                  child: Text(
                    "予約時間",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        // color: Colors.white,
                        fontSize: 10),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    DateFormat("hh:mm a").format(date),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          // color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 26),
                  child: Text(
                    "到着締切",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        // color: Colors.white,
                        fontSize: 10,
                        color: Colors.red),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(),
                  child: Text(
                    DateFormat("hh:mm a").format(date2),
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          // color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )
              ])),
          Expanded(
            flex: 1,
            child: buildItemInfo(booking, index, context),
          ),
        ],
      ),
    );
  }

  _changeCardColor(Map booking) {
    if (booking["status"] == "paid" &&
        DateTime.now().isAfter(DateTime.parse(booking["expiredAt"]))) {
      return LinearGradient(
          colors: [Colors.yellow.withOpacity(0.8), Colors.yellow]);
    } else if (booking["status"] == "paid") {
      return LinearGradient(colors: [Colors.white, Colors.white]);
    } else if (booking["status"] == "checked_in") {
      return LinearGradient(colors: [
        Theme.of(context).primaryColor.withOpacity(0.5),
        Theme.of(context).primaryColor,
      ]);
    } else if (booking["status"] == "cancelled") {
      return LinearGradient(colors: [
        Colors.blueGrey[100].withOpacity(0.8),
        Colors.blueGrey[100]
      ]);
    }
  }

  Card buildItemInfo(Map booking, int index, BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        decoration: BoxDecoration(
          gradient: _changeCardColor(booking),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 30,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 8),
                        child: SizedBox(
                          width: 200,
                          height: 20,
                          child: Text(
                            booking["storeInfo"]["name"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: SizedBox(
                            width: 200,
                            child: Text(
                              "予約席：${booking["tableType"]["label"]}\n人数：${booking["partySize"]}人",
                              style: TextStyle(fontSize: 10),
                            ),
                          )),
                    ]))),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            //   child: Column(
            //     children: [SizedBox(width: 110)],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Container buildLine(int index, BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              width: 2,
              color: Theme.of(context).accentColor,
            ),
          ),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor, shape: BoxShape.circle),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 2,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
