import "package:flutter/material.dart";

class MerchantStrict extends StatefulWidget {
  @override
  _MerchantStrictState createState() => _MerchantStrictState();
}

class _MerchantStrictState extends State<MerchantStrict> {
  bool toggle1 = false;
  bool toggle2 = false;
  bool toggle3 = false;
  bool toggle4 = false;
  bool toggle5 = false;
  bool toggle6 = false;
  bool toggle7 = false;
  bool toggle8 = false;
  bool toggle9 = false;
  bool toggle10 = false;
  bool toggle11 = false;
  bool toggle12 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Cafe Express Control Panel",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.blue,
          elevation: 0.0,
        ),
        body: ListView(children: [
          Text(
            "1 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle1
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle1 ? 60.0 : 0.0,
                    right: toggle1 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton1,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle1
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "2 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle2
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle2 ? 60.0 : 0.0,
                    right: toggle2 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton2,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle2
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "3 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle3
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle3 ? 60.0 : 0.0,
                    right: toggle3 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton3,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle3
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "4 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle4
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle4 ? 60.0 : 0.0,
                    right: toggle4 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton4,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle4
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "5 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle5
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle5 ? 60.0 : 0.0,
                    right: toggle5 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton5,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle5
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "6 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle6
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle6 ? 60.0 : 0.0,
                    right: toggle6 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton6,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle6
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "7 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle7
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle7 ? 60.0 : 0.0,
                    right: toggle7 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton7,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle7
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "8 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle8
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle8 ? 60.0 : 0.0,
                    right: toggle8 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton8,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle8
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "9 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle9
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle9 ? 60.0 : 0.0,
                    right: toggle9 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton9,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle9
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "10 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle10
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle10 ? 60.0 : 0.0,
                    right: toggle10 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton10,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle10
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "11 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle11
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle11 ? 60.0 : 0.0,
                    right: toggle11 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton11,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle11
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "12 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle12
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle12 ? 60.0 : 0.0,
                    right: toggle12 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton12,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle12
                            ? Icon(Icons.check_circle,
                                color: Colors.blue,
                                size: 35.0,
                                key: UniqueKey())
                            : Icon(Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 35.0,
                                key: UniqueKey()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ]));
  }

  toggleButton1() {
    setState(() {
      toggle1 = !toggle1;
    });
  }

  toggleButton2() {
    setState(() {
      toggle2 = !toggle2;
    });
  }

  toggleButton3() {
    setState(() {
      toggle3 = !toggle3;
    });
  }

  toggleButton4() {
    setState(() {
      toggle4 = !toggle4;
    });
  }

  toggleButton5() {
    setState(() {
      toggle5 = !toggle5;
    });
  }

  toggleButton6() {
    setState(() {
      toggle6 = !toggle6;
    });
  }

  toggleButton7() {
    setState(() {
      toggle7 = !toggle7;
    });
  }

  toggleButton8() {
    setState(() {
      toggle8 = !toggle8;
    });
  }

  toggleButton9() {
    setState(() {
      toggle9 = !toggle9;
    });
  }

  toggleButton10() {
    setState(() {
      toggle10 = !toggle10;
    });
  }

  toggleButton11() {
    setState(() {
      toggle11 = !toggle11;
    });
  }

  toggleButton12() {
    setState(() {
      toggle12 = !toggle12;
    });
  }
}
