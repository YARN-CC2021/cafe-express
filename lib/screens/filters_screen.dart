import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'slider_view.dart';
import 'people_slider_view.dart';
import '../app_theme.dart';
import '../models/category.dart';
import '../global.dart' as globals;

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  List<CategoryData> categoryData = CategoryData.category;

  double distValue = 25.0;
  double peopleValue = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CafeExpressTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    peopleViewUI(),
                    const Divider(
                      height: 1,
                    ),
                    categoryFilter(),
                    const Divider(
                      height: 1,
                    ),
                    distanceViewUI(),
                    const Divider(
                      height: 1,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: CafeExpressTheme.buildLightTheme().primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context, {
                        "groupSize": globals.peopleValue.toInt(),
                        "distance": (globals.distanceValue * 100).toInt(),
                        "category": categoryData
                      });
                    },
                    child: Center(
                      child: Text(
                        '適用する',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkAppPosition(int index) {
    if (index == 0) {
      if (categoryData[0].isSelected) {
        categoryData.forEach((d) {
          d.isSelected = false;
        });
      } else {
        categoryData.forEach((d) {
          d.isSelected = true;
        });
      }
    } else {
      categoryData[index].isSelected = !categoryData[index].isSelected;

      int count = 0;
      for (int i = 0; i < categoryData.length; i++) {
        if (i != 0) {
          final CategoryData data = categoryData[i];
          if (data.isSelected) {
            count += 1;
          }
        }
      }

      if (count == categoryData.length - 1) {
        categoryData[0].isSelected = true;
      } else {
        categoryData[0].isSelected = false;
      }
    }
  }

  Widget peopleViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '人数',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize:
                          MediaQuery.of(context).size.width > 360 ? 18 : 16,
                      fontWeight: FontWeight.normal),
                ),
                Row(
                  children: [
                    Text(
                      "絞り込みON",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize:
                              MediaQuery.of(context).size.width > 360 ? 18 : 16,
                          fontWeight: FontWeight.normal),
                    ),
                    CupertinoSwitch(
                      activeColor: globals.isFilterOn
                          ? CafeExpressTheme.buildLightTheme().primaryColor
                          : Colors.grey.withOpacity(0.6),
                      onChanged: (bool value) {
                        setState(() {
                          globals.isFilterOn = !globals.isFilterOn;
                        });
                      },
                      value: globals.isFilterOn,
                    ),
                  ],
                )
              ],
            )),
        PeopleSliderView(
          peopleValue: globals.peopleValue,
          onChangePeopleValue: (double value) {
            peopleValue = value;
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget distanceViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            '現在地からの距離',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        SliderView(
          distValue: globals.distanceValue,
          onChangedistValue: (double value) {
            distValue = value;
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget categoryFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'カテゴリー',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getCategoryList(),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getCategoryList() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < categoryData.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int j = 0; j < columnCount; j++) {
        int index = count;
        try {
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        checkAppPosition(index);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            categoryData[count].isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: categoryData[count].isSelected
                                ? CafeExpressTheme.buildLightTheme()
                                    .primaryColor
                                : Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            categoryData[count].titleTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          if (count < categoryData.length - 1) {
            count += 1;
          } else {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: CafeExpressTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context, {
                      "groupSize": globals.peopleValue.toInt(),
                      "distance": (globals.distanceValue * 100).toInt(),
                      "category": categoryData
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '絞り込み条件',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}
