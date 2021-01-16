import 'package:flutter/material.dart';
import 'dart:async';
import "package:flutter_barcode_scanner/flutter_barcode_scanner.dart";

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer timer;
  int totalTime = 1800; //60;
  String timetodisplay = '';
  String barcode = "";
  String lockedTime = "";

  _scan() async {
    return FlutterBarcodeScanner.scanBarcode(
            "#000000", "cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() {
              barcode = value;
              lockedTime = timetodisplay.toString();
            }));
  }

  @override
  void initState() {
    //if (totalTime == 1800) { //初期値の時だけタイマースタート？
    start();
    //}
    super.initState();
  }

  @override
  void dispose() {
    print("disposed");
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cafe Express"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        body: Center(
          child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        children: [
                          Text(
                            "Dead Line is...",
                            style: TextStyle(
                              fontSize: 35.0,
                              color: Colors.redAccent[400],
                            ),
                          ),
                          Text(
                            '$timetodisplay',
                            style:
                                TextStyle(fontSize: 35.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 80.0),
                              child: RaisedButton(
                                child: Text("Scan Barcode"),
                                onPressed: () => _scan(),
                              )),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 80.0),
                              child: Text(barcode)),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 80.0),
                              child: Text(lockedTime)),
                          RaisedButton(
                              child: const Text(
                                'I Got Here!',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.lightBlue[200],
                              shape: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                          onPressed: () {
                            //dialog that user reach the shop
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text(''),
                                  content: Text(
                                    'Are You Here?',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("No"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    FlatButton(
                                      child: Text("Yes"),
                                      onPressed: () => {
                                        // go back to map page? or success pages
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning),
                            Text(
                              "Any Issue? Contact",
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.amber,
                              ),
                            ),
                            Icon(Icons.warning),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Icon(Icons.local_phone), onPressed: () {}),
                          IconButton(icon: Icon(Icons.mail), onPressed: () {}),
                        ],
                      )
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }

  void start() {
    timer = Timer.periodic(
        Duration(
          seconds: 1,
        ), (Timer t) {
      setState(() {
        if (totalTime < 0) {
          print('TOTAL$totalTime');
          //go fail page
          timer.cancel();
          totalTime = 1800;
        } else if (totalTime < 3600) {
          int m = totalTime ~/ 60;
          int s = totalTime - (60 * m);
          if (s == 0) {
            timetodisplay = m.toString() + ":" + "0" + s.toString();
          } else {
            timetodisplay = m.toString() + ":" + s.toString();
          }
          totalTime -= 1;
        }
      });
    });
  }
}
