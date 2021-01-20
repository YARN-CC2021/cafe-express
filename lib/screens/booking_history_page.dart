import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import '../global.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import '../app.dart';

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
        backgroundColor: Theme.of(context).cardColor,
        brightness: Theme.of(context).brightness,
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          "Booking History",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
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
                    return buildListView();
                  }),
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
        onPressed: () => {_changePage(context, MapSearchRoute)},
      ),
    );
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
    if (booking["status"] == "expired") {
      return LinearGradient(colors: [Colors.redAccent[400], Colors.red[900]]);
    } else if (booking["status"] == "paid" &&
        DateTime.now().isAfter(DateTime.parse(booking["expiredAt"]))) {
      return LinearGradient(
          colors: [Colors.amberAccent[100], Colors.amberAccent]);
    } else if (booking["status"] == "paid") {
      return LinearGradient(colors: [Colors.white, Colors.white]);
    } else if (booking["status"] == "checked_in") {
      return LinearGradient(colors: [
        Theme.of(context).primaryColor,
        Colors.greenAccent[400],
      ]);
    } else if (booking["status"] == "cancelled") {
      return LinearGradient(
          colors: [Colors.blueGrey[100], Colors.blueGrey[300]]);
    }
  }

  Card buildItemInfo(Map booking, int index, BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        decoration: BoxDecoration(
          gradient: _changeCardColor(booking),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 8),
                        child: SizedBox(
                          width: 100,
                          child: Text(
                            // booking["bookName"],
                            "隆盛カフェ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          // "種類：${booking["tableType"]["label"]}\n人数：${booking["partySize"]}人",
                          "種類：１２人席\n人数：${booking["partySize"]}人",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ]))),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            //   child: Column(children: [
            //     MaterialButton(
            //       minWidth: 110,
            //       // disabledColor: Colors.blueGrey[100],
            //       child: Text('キャンセル',
            //           style: TextStyle(fontSize: 12, color: Colors.white)),
            //       color: Colors.redAccent,
            //       shape: const StadiumBorder(
            //         side: BorderSide(color: Colors.white),
            //       ),
            //       onPressed: DateTime.now()
            //                   .isBefore(DateTime.parse(booking["expiredAt"])) &&
            //               booking["status"] == "paid"
            //           ? () {
            //               _statusUpdate(index, "cancelled");
            //             }
            //           : null,
            //     ),
            //   ]),
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
