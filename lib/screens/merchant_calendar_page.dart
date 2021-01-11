import "package:flutter/material.dart";
import './merchant_calendar_page.dart';

class MerchantCalendarPage extends StatefulWidget {
  final Map<dynamic, dynamic> profile;
  MerchantCalendarPage({Key key, @required this.profile}) : super(key: key);

  @override
  _MerchantCalendarPageState createState() => _MerchantCalendarPageState();
}

class _MerchantCalendarPageState extends State<MerchantCalendarPage> {
  var _time = TimeOfDay(hour: 7, minute: 15);
  double _height;
  double _width;
  String _setTime;
  var test = "test";

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        print(newTime);
        _time = newTime;
        print(_time.hour);
        print(_time.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cafe Express"),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: Center(
        child: new ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
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
                              '　',
                              style: TextStyle(fontSize: 30),
                              textAlign: TextAlign.center,
                            ),
                            FlatButton(
                              onPressed: () {},
                              minWidth: _width / 15,
                              height: _height / 15,
                              child: Center(
                                child: Text(
                                  'Open',
                                  style: TextStyle(fontSize: 30),
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
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
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
                              onPressed: _selectTime,
                              minWidth: _width / 15,
                              height: _height / 15,
                              color: Colors.grey[200],
                              child: Text(
                                "${_time.hour}:${_time.minute}",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            FlatButton(
                              onPressed: _selectTime,
                              minWidth: _width / 15,
                              height: _height / 15,
                              color: Colors.grey[200],
                              child: Text(
                                "${_time.hour}:${_time.minute}",
                                style: TextStyle(fontSize: 30),
                              ),
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
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
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
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
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
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
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
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
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
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
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
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
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
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          FlatButton(
                            onPressed: _selectTime,
                            minWidth: _width / 15,
                            height: _height / 15,
                            color: Colors.grey[200],
                            child: Text(
                              "${_time.hour}:${_time.minute}",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, otherwise false.
                  // if (_formKey.currentState.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  // assignVariable();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MerchantCalendarPage(profile: widget.profile),
                    ),
                  );
                },
                child: Text('Next Page'),
              )
            ]),
      ),
    );
  }
}
