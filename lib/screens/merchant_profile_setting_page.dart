import 'package:flutter/material.dart';
import '../app.dart';

class MerchantProfileSettingPage extends StatefulWidget {
  @override
  _MerchantProfileSettingPageState createState() =>
      _MerchantProfileSettingPageState();
}

class _MerchantProfileSettingPageState
    extends State<MerchantProfileSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new Container(),
        title: Text(
          "Cafe Express Control Panel",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Padding(
                //   padding: EdgeInsets.only(left: 10.0, right: 10.0),
                //   child: Image.asset(
                //     "assets/cm4.jpeg",
                //     fit: BoxFit.cover,
                //     width: 100.0,
                //     height: 100.0,
                //   ),
                // ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Jane Doe",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "jane@doefamily.com",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return Text("");
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 13.0,
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
            Container(height: 15.0),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Account Information".toUpperCase(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Full Name",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "Jane Mary Doe",
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20.0,
                ),
                onPressed: () {},
                tooltip: "Edit",
              ),
            ),
            ListTile(
              title: Text(
                "Email",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "jane@doefamily.com",
              ),
            ),
            ListTile(
              title: Text(
                "Phone",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "+1 816-926-6241",
              ),
            ),
            ListTile(
              title: Text(
                "Address",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "1278 Loving Acres RoadKansas City, MO 64110",
              ),
            ),
            ListTile(
              title: Text(
                "Gender",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "Female",
              ),
            ),
            ListTile(
              title: Text(
                "Date of Birth",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "April 9, 1995",
              ),
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
