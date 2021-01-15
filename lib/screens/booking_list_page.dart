import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app.dart';

class BookingListPage extends StatefulWidget {
  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  // String status;
  // final TextEditingController _searchControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BookingPage();
  }
}

// Booking Name, BookingTime ExpiiryTime, Date, Status, CheckingButton, Cancel Button,
class Booking {
  String bookName;
  int partySize;
  int bookedAt;
  int expiredAt;
  String status;
  Booking(
      {this.bookName,
      this.partySize,
      this.bookedAt,
      this.expiredAt,
      this.status});
}

// List<Booking> bookings = List.generate(20, (index) {
//   bool isRedeem = false;
//   String name = isRedeem ? "Redeem PS" : "Awarded Point";
//   double point = isRedeem ? -140000.0 : 1000.0;
//   return Booking(
//       name: name,
//       point: point,
//       createdMillis: DateTime.now().millisecondsSinceEpoch);
// })
//   ..sort((v1, v2) => v2.createdMillis - v1.createdMillis);

class BookingPage extends StatefulWidget {
  BookingPage({Key key}) : super(key: key);
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
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
      body: buildListView(),
    );
  }

  Future<void> _getBookingData() async {
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/booking/${globals.userId}');
    if (response.statusCode == 200) {
      final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        bookingData = jsonResponse['body'];
      });
      _mapMountedStoreData();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  ListView buildListView() {
    String prevDay;
    String today = DateFormat("EEE, MMM d, y").format(DateTime.now());
    String yesterday = DateFormat("EEE, MMM d, y")
        .format(DateTime.now().add(Duration(days: -1)));
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        Booking booking = bookings[index];
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(booking.createdMillis);
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
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
                : Offstage(),
            buildItem(index, context, date, booking),
          ],
        );
      },
    );
  }

  Widget buildItem(
      int index, BuildContext context, DateTime date, Booking booking) {
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
                Text(
                  DateFormat("hh:mm a").format(date),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        // color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  DateFormat("hh:mm a").format(date),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        // color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ])),
          Expanded(
            flex: 1,
            child: buildItemInfo(booking, context),
          ),
        ],
      ),
    );
  }

  Card buildItemInfo(Booking booking, BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: booking.point.isNegative
                  ? [Colors.deepOrange, Colors.red]
                  : [Colors.green, Colors.teal]),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  booking.name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                NumberFormat("###,###,#### P").format(booking.point),
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
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
