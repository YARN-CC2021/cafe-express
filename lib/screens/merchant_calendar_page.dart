import "package:flutter/material.dart";
import '../app.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amplify_core/amplify_core.dart';

class MerchantCalendarPage extends StatefulWidget {
  @override
  _MerchantCalendarPageState createState() => _MerchantCalendarPageState();
}

Map newShopData;
var hours;
var _userId;

class _MerchantCalendarPageState extends State<MerchantCalendarPage> {
  double _height;
  double _width;

  @override
  void initState() {
    super.initState();
    _getShopData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _mapMountedHoursData() {
    hours = newShopData['hours'];
  }

  void assignNewHours() {
    newShopData["hours"] = hours;
  }

  Future<void> _getShopData() async {
    var userData = await Amplify.Auth.getCurrentUser();
    var userId = userData.userId;
    print("Calendar Page $userId");
    setState(() => _userId = userId);
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$userId');
    if (response.statusCode == 200) {
      final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        newShopData = jsonResponse['body'];
      });
      print("This is ShopData: $newShopData");
      _mapMountedHoursData();
      print("This is HoursData: $hours");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _updateStoreProfile() async {
    print("UpdateStoreProfile was called!!!!");
    print("shopData in _updateStoreProfile $newShopData");
    // print("JSON stringiified shopdata ${jsonEncode(shopData)}");
    var response = await http.patch(
      "https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$_userId",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newShopData),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("_updateStoreProfile jsonResponse= $jsonResponse");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _selectTime(String day, String openClose) async {
    String initialHour = hours[day][openClose];
    int intHour;
    initialHour = initialHour.substring(0, 2);
    intHour = int.parse(initialHour);

    String initialMinute = hours[day][openClose];
    int intMinute;
    initialMinute = initialMinute.substring(2, 4);
    intMinute = int.parse(initialMinute);

    var _time = TimeOfDay(hour: intHour, minute: intMinute);

    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    var hour;
    // hour converted to our format
    if (newTime.hour.toString().length == 1) {
      hour = "0" + newTime.hour.toString().substring(0);
    } else {
      hour = newTime.hour.toString();
    }

    // minute converted to our format
    var minute;
    if (newTime.minute.toString().length == 1) {
      minute = "0" + newTime.minute.toString().substring(0);
    } else {
      minute = newTime.minute.toString();
    }
    if (newTime != null) {
      setState(() {
        hours[day][openClose] = "$hour$minute";
        String bookingHour;
        if (hour == "00") {
          bookingHour = "23";
        } else {
          bookingHour = (int.parse(hour) - 1).toString();
          if (bookingHour.length == 1) bookingHour = "0" + bookingHour;
        }
        if (openClose == "open") hours[day]["bookingStart"] = "$hour$minute";
        if (openClose == "close") {
          hours[day]["bookingEnd"] = "$bookingHour$minute";
        }
      });
    }
  }

  _onChecked(bool newValue, String day) => setState(() {
        hours[day]["day_off"] = newValue;
      });

  _displaySetTime(String day, String openClose) {
    String fullTime = hours[day][openClose];
    String hour;
    String minute;
    hour = fullTime.substring(0, 2);
    minute = fullTime.substring(2, 4);
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cafe Express"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Center(
        child: new ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              ' ',
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                            FlatButton(
                              onPressed: () {},
                              minWidth: _width / 15,
                              height: _height / 15,
                              child: Center(
                                child: Text(
                                  'Open',
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {},
                              minWidth: _width / 15,
                              height: _height / 15,
                              child: Text(
                                'Close',
                                style: TextStyle(fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              '休',
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ])),
                  Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '月',
                              style: TextStyle(fontSize: 30),
                            ),
                            FlatButton(
                              onPressed: () => {_selectTime("Mon", "open")},
                              minWidth: _width / 15,
                              height: _height / 15,
                              color: Colors.grey[200],
                              child: Text(
                                _displaySetTime("Mon", "open"),
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            FlatButton(
                              onPressed: () => {_selectTime("Mon", "close")},
                              minWidth: _width / 15,
                              height: _height / 15,
                              color: Colors.grey[200],
                              child: Text(
                                _displaySetTime("Mon", "close"),
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Checkbox(
                              value: hours["Mon"]["day_off"],
                              onChanged: (value) => {_onChecked(value, "Mon")},
                            ),
                          ])),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '火',
                            style: TextStyle(fontSize: 30),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Tue", "open")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Tue", "open"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Tue", "close")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Tue", "close"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Checkbox(
                            value: hours["Tue"]["day_off"],
                            onChanged: (value) => {_onChecked(value, "Tue")},
                          ),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '水',
                            style: TextStyle(fontSize: 30),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Wed", "open")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Wed", "open"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Wed", "close")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Wed", "close"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Checkbox(
                            value: hours["Wed"]["day_off"],
                            onChanged: (value) => {_onChecked(value, "Wed")},
                          ),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '木',
                            style: TextStyle(fontSize: 30),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Thu", "open")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Thu", "open"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Thu", "close")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Thu", "close"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Checkbox(
                            value: hours["Thu"]["day_off"],
                            onChanged: (value) => {_onChecked(value, "Thu")},
                          ),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '金',
                            style: TextStyle(fontSize: 30),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Fri", "open")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Fri", "open"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Fri", "close")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Fri", "close"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Checkbox(
                            value: hours["Fri"]["day_off"],
                            onChanged: (value) => {_onChecked(value, "Fri")},
                          ),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '土',
                            style: TextStyle(fontSize: 30),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Sat", "open")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Sat", "open"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Sat", "close")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Sat", "close"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Checkbox(
                            value: hours["Sat"]["day_off"],
                            onChanged: (value) => {_onChecked(value, "Sat")},
                          ),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '日',
                            style: TextStyle(fontSize: 30),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Sun", "open")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Sun", "open"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Sun", "close")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Sun", "close"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Checkbox(
                            value: hours["Sun"]["day_off"],
                            onChanged: (value) => {_onChecked(value, "Sun")},
                          ),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '祝',
                            style: TextStyle(fontSize: 30),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Holiday", "open")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Holiday", "open"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {_selectTime("Holiday", "close")},
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              _displaySetTime("Holiday", "close"),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Checkbox(
                            value: hours["Holiday"]["day_off"],
                            onChanged: (value) =>
                                {_onChecked(value, "Holiday")},
                          ),
                        ]),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  assignNewHours();
                  _updateStoreProfile();
                  _goMerchantPage(context);
                },
                child: Text('保存'),
              )
            ]),
      ),
    );
  }

  void _goMerchantPage(BuildContext context) {
    Navigator.pushNamed(context, MerchantRoute);
    print("goMerchantPage was triggered");
  }
}
