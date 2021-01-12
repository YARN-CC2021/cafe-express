import "package:flutter/material.dart";

class MerchantFlex extends StatefulWidget {
  @override
  _MerchantFlexState createState() => _MerchantFlexState();
}

class _MerchantFlexState extends State<MerchantFlex> {
  bool toggle1 = false;
  bool toggle2 = false;
  bool toggle3Or4 = false;
  bool toggle5Or6 = false;
  bool toggle7Or8 = false;
  bool toggle9Or10 = false;
  bool toggle11Or12 = false;
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
            "3 or 4 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle3Or4
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle3Or4 ? 60.0 : 0.0,
                    right: toggle3Or4 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton3Or4,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle3Or4
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
            "5 or 6 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle5Or6
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle5Or6 ? 60.0 : 0.0,
                    right: toggle5Or6 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton5Or6,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle5Or6
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
            "7 or 8 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle7Or8
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle7Or8 ? 60.0 : 0.0,
                    right: toggle7Or8 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton7Or8,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle7Or8
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
            "9 or 10 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle9Or10
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle9Or10 ? 60.0 : 0.0,
                    right: toggle9Or10 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton9Or10,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle9Or10
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
            "11 or 12 Person",
            textAlign: TextAlign.center,
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40.0,
              width: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: toggle11Or12
                      ? Colors.blueAccent[100]
                      : Colors.redAccent[100].withOpacity(0.5)),
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggle11Or12 ? 60.0 : 0.0,
                    right: toggle11Or12 ? 0.0 : 60.0,
                    child: InkWell(
                      onTap: toggleButton11Or12,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                              child: child, turns: animation);
                        },
                        child: toggle11Or12
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

  toggleButton3Or4() {
    setState(() {
      toggle3Or4 = !toggle3Or4;
    });
  }

  toggleButton5Or6() {
    setState(() {
      toggle5Or6 = !toggle5Or6;
    });
  }

  toggleButton7Or8() {
    setState(() {
      toggle7Or8 = !toggle7Or8;
    });
  }

  toggleButton9Or10() {
    setState(() {
      toggle9Or10 = !toggle9Or10;
    });
  }

  toggleButton11Or12() {
    setState(() {
      toggle11Or12 = !toggle11Or12;
    });
  }
}
