import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import '../app.dart';
import '../global.dart' as globals;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MerchantProfilePage extends StatefulWidget {
  @override
  _MerchantProfilePageState createState() => _MerchantProfilePageState();
}

Map shopData;
var _userId;
var result;
String identityId;
var _category = "お店のカテゴリーを選択ください";
var _vacancyType = "";

class _MerchantProfilePageState extends State<MerchantProfilePage> {
  @override
  void initState() {
    super.initState();
    _getShopData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController storeUrlController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  // final TextEditingController depositController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  // var profile = {};

  Future<void> _getShopData() async {
    setState(() => _userId = globals.userId);
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$_userId');
    await _listPic();
    await _fetchSession();
    await _showPic();
    if (response.statusCode == 200) {
      final jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        shopData = jsonResponse['body'];
      });
      _mapMountedStoreData();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _filepick() async {
    print("Im in Filepick");
    try {
      // use a file selection mechanism of your choice
      print("Im in Filepick TRRYYYY");
      File file = await FilePicker.getFile(type: FileType.image);
      String key = new DateTime.now().millisecondsSinceEpoch.toString();
      key = "image/store/${globals.userId}/" + "1";

      S3UploadFileOptions options =
          S3UploadFileOptions(accessLevel: StorageAccessLevel.guest);
      UploadFileResult result = await Amplify.Storage.uploadFile(
          key: key, local: file, options: options);
      print("Im in Filepick UPLOADDEDD $result");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _fetchSession() async {
    print("Im in fetchSesssion!!!");
    try {
      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      identityId = res.identityId;
      print("IdentityId $identityId");
    } on AuthError catch (e) {
      print(e);
    }
  }

  Future<void> _showPic() async {
    final getUrlOptions = GetUrlOptions(
      accessLevel: StorageAccessLevel.guest,
    );
    try {
      result =
          await Amplify.Storage.getUrl(key: result, options: getUrlOptions);
      result = result.url;
      print("done getting $result");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _listPic() async {
    print("Im in listPic");
    try {
      S3ListOptions options = S3ListOptions(
        accessLevel: StorageAccessLevel.guest,
      );
      ListResult res = await Amplify.Storage.list(options: options);
      result = res.items[0].key;
      print("res $res");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text("Cafe Express"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        body: shopData == null || result == null
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: new ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        children: <Widget>[
                          // Add TextFormFields and ElevatedButton here.
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 3.0, right: 3.0, bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      result,
                                      width: 83,
                                      height: 83,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                            child: SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                          ),
                                        ));
                                      },
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 3.0, right: 3.0, bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      result,
                                      width: 83,
                                      height: 83,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                            child: SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                          ),
                                        ));
                                      },
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 3.0, right: 3.0, bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      result,
                                      width: 83,
                                      height: 83,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                            child: SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                          ),
                                        ));
                                      },
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 3.0, right: 3.0, bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      result,
                                      width: 83,
                                      height: 83,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                            child: SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                          ),
                                        ));
                                      },
                                    ),
                                  )),
                            ],
                          ),

                          TextFormField(
                            // The validator receives the text that the user has entered.
                            decoration: InputDecoration(
                              icon: Container(
                                width: 26,
                                child: FaIcon(
                                  FontAwesomeIcons.user,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: 'お店の名前を入力ください',
                              labelText: '店名',
                            ),
                            controller: nameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '情報を入力してください';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            decoration: InputDecoration(
                              icon: Container(
                                width: 26,
                                child: FaIcon(
                                  FontAwesomeIcons.addressCard,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: 'お店の詳細を入力下さい',
                              labelText: '詳細',
                            ),
                            maxLines: 2,
                            controller: descriptionController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '情報を入力してください';
                              }
                              return null;
                            },
                          ),
                          Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(right: 15),
                                  child: FaIcon(
                                    FontAwesomeIcons.usps,
                                    color: Colors.grey,
                                  ),
                                  width: 40),
                              Expanded(
                                child: TextFormField(
                                  maxLines: 1,
                                  controller: zipCodeController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: '郵便番号',
                                  ),
                                ),
                              ),
                              OutlineButton(
                                child: Text('検索'),
                                onPressed: () async {
                                  print(zipCodeController.text);
                                  var result = await http.get(
                                      'https://zipcloud.ibsnet.co.jp/api/search?zipcode=${zipCodeController.text}');
                                  Map<String, dynamic> map =
                                      json.decode(result.body)['results'][0];
                                  addressController.text =
                                      '${map['address1']}${map['address2']}${map['address3']}';
                                },
                              ),
                            ],
                          ),
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            decoration: InputDecoration(
                              icon: Container(
                                width: 26,
                                child: FaIcon(
                                  FontAwesomeIcons.locationArrow,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: '住所を入力してください',
                              labelText: '住所',
                            ),
                            controller: addressController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '情報を入力してください';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            decoration: InputDecoration(
                              icon: Container(
                                width: 26,
                                child: FaIcon(
                                  FontAwesomeIcons.phoneAlt,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: '電話番号を入力してください',
                              labelText: '電話番号',
                            ),
                            //fillColor: Colors.green),
                            controller: telController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '情報を入力してください';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            decoration: InputDecoration(
                              icon: Container(
                                width: 26,
                                child: FaIcon(
                                  FontAwesomeIcons.at,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: 'お店のEメールを入力ください',
                              labelText: 'Eメール',
                            ),
                            controller: emailController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '情報を入力してください';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            decoration: InputDecoration(
                              icon: Container(
                                width: 26,
                                child: FaIcon(
                                  FontAwesomeIcons.cloud,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: 'お店のURLを記載してください',
                              labelText: 'URL',
                            ),
                            controller: storeUrlController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '情報を入力してください';
                              }
                              return null;
                            },
                          ),
                          Row(children: [
                            Container(
                                padding: EdgeInsets.only(right: 15),
                                child: Container(
                                  width: 26,
                                  child: FaIcon(
                                    FontAwesomeIcons.utensils,
                                    color: Colors.grey,
                                  ),
                                ),
                                width: 40),
                            Flexible(
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(),
                                  labelText: 'カテゴリー',
                                  hintText: 'お店の種類を選択ください',
                                ),
                                items: ["お店のカテゴリーを選択ください", "カフェ", "バー", "レストラン"]
                                    .map((String category) {
                                  return new DropdownMenuItem(
                                      value: category,
                                      child: Row(
                                        children: <Widget>[
                                          Text(category),
                                        ],
                                      ));
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() => _category = newValue);
                                },
                                value: _category,
                                validator: (value) {
                                  if (value == "お店のカテゴリーを選択ください") {
                                    return 'カテゴリーを選択ください';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ]),
                          // TextFormField(
                          //   // The validator receives the text that the user has entered.
                          //   decoration: InputDecoration(
                          //     icon: Icon(Icons.attach_money_rounded,
                          //         color: Colors.blue[300]),
                          //     hintText:
                          //         'Enter your cancellation fee per person',
                          //     labelText: 'Cancellation Fee',
                          //   ),
                          //   controller: depositController,
                          //   validator: (value) {
                          //     if (value.isEmpty) {
                          //       return '情報を入力してください';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            decoration: InputDecoration(
                              icon: Icon(Icons.insert_photo_rounded,
                                  color: Colors.blue[300]),
                              hintText: 'Enter your image url',
                              labelText: 'Image',
                            ),
                            controller: imageController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '情報を入力してください';
                              }
                              return null;
                            },
                          ),
                          RaisedButton(onPressed: () {
                            _filepick();
                          }),
                          RaisedButton(onPressed: () {
                            _filepick();
                          }),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                            child: Row(children: [
                              Container(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Container(
                                    width: 26,
                                    child: FaIcon(
                                      FontAwesomeIcons.cog,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  width: 40),
                              Text(
                                "テーブル設定",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ]),
                          ),
                          Row(children: [
                            Expanded(
                                child: ListTile(
                              title: const Text(
                                '固定',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              leading: Radio(
                                value: "strict",
                                groupValue: _vacancyType,
                                onChanged: (value) {
                                  setState(() {
                                    _vacancyType = value;
                                  });
                                },
                              ),
                            )),
                            Expanded(
                              child: ListTile(
                                title: const Text(
                                  '範囲',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                leading: Radio(
                                  value: "flex",
                                  groupValue: _vacancyType,
                                  onChanged: (value) {
                                    setState(() {
                                      _vacancyType = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: ListTile(
                            //     title: const Text(
                            //       'Custom',
                            //       style: TextStyle(
                            //         fontSize: 11.5,
                            //       ),
                            //     ),
                            //     leading: Radio(
                            //       value: "custom",
                            //       groupValue: _vacancyType,
                            //       onChanged: (value) {
                            //         setState(() {
                            //           _vacancyType = value;
                            //         });
                            //       },
                            //     ),
                            //   ),
                            // ),
                          ]),
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                assignVariable();
                                _updateStoreProfile();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         MerchantCalendarPage(shopData: shopData),
                                //   ),
                                // );
                              }
                            },
                            child: Text('保存'),
                          )
                        ]))));
  }

  Future<void> _getAddress(String address) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    var first = addresses.first;
    var strCoordinates = first.coordinates
        .toString()
        .substring(1, first.coordinates.toString().length - 1);
    List coordinates = strCoordinates.split(",");
    shopData['lat'] = double.parse(coordinates[0]);
    shopData['lng'] = double.parse(coordinates[1]);
  }

  void _changePage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
    print("Going to $route was triggered");
  }

  Future<void> _updateStoreProfile() async {
    await _getAddress(shopData["address"]);
    var response = await http.patch(
      "https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$_userId",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(shopData),
    );
    if (response.statusCode == 200) {
      if (globals.firstSignIn) {
        globals.firstSignIn = false;
        _changePage(context, MerchantRoute);
      } else {
        _changePage(context, MerchantProfileSettingRoute);
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void assignVariable() {
    shopData["name"] = nameController.text;
    shopData["description"] = descriptionController.text;
    shopData["address"] = addressController.text;
    shopData["zipCode"] = zipCodeController.text;
    shopData["tel"] = telController.text;
    shopData["contactEmail"] = emailController.text;
    shopData["storeURL"] = storeUrlController.text;
    shopData["category"] = _category;
    // shopData["depositAmountPerPerson"] = depositController.text;
    shopData["imagePaths"] = imageController.text;
    shopData["vacancyType"] = _vacancyType;
    shopData["updatedAt"] = DateTime.now().toUtc().toIso8601String();
  }

  void _mapMountedStoreData() {
    nameController.text = shopData['name'];
    descriptionController.text = shopData['description'];
    addressController.text = shopData['address'];
    zipCodeController.text = shopData['zipCode'];
    telController.text = shopData['tel'];
    emailController.text = shopData['contactEmail'];
    storeUrlController.text = shopData['storeURL'];
    _category = shopData['category'];
    // depositController.text = shopData['depositAmountPerPerson'].toString();
    if (shopData['imagePaths'].length > 0) {
      imageController.text = shopData['imagePaths'][0];
    } else {
      imageController.text = "";
    }
    _vacancyType = shopData['vacancyType'];
    shopData.remove("id");
  }
}
