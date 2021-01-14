import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amplify_core/amplify_core.dart';
import '../app.dart';

class MerchantProfilePage extends StatefulWidget {
  @override
  _MerchantProfilePageState createState() => _MerchantProfilePageState();
}

Map shopData;
var _userId;

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
  final TextEditingController depositController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  var _vacancyType = "";
  // var profile = {};

  void assignVariable() {
    shopData["name"] = nameController.text;
    shopData["description"] = descriptionController.text;
    shopData["address"] = addressController.text;
    shopData["tel"] = telController.text;
    shopData["contactEmail"] = emailController.text;
    shopData["storeURL"] = storeUrlController.text;
    shopData["category"] = categoryController.text;
    shopData["depositAmountPerPerson"] = depositController.text;
    shopData["imagePaths"] = imageController.text;
    shopData["vacancyType"] = _vacancyType;
    shopData["updatedAt"] = DateTime.now().toUtc().toIso8601String();
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
        body: Form(
            key: _formKey,
            child: new ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  // Add TextFormFields and ElevatedButton here.
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Colors.blue[300]),
                      hintText: 'Enter your store name',
                      labelText: 'Name',
                    ),
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Colors.blue[300]),
                      hintText: 'Enter your store description',
                      labelText: 'Store Description',
                    ),
                    maxLines: 2,
                    controller: descriptionController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                      icon: Icon(Icons.store_mall_directory,
                          color: Colors.blue[300]),
                      hintText: 'Enter your store address',
                      labelText: 'Address',
                    ),
                    controller: addressController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                      icon: Icon(Icons.local_phone, color: Colors.blue[300]),
                      hintText: 'Enter your phone number',
                      labelText: 'Phone Number',
                    ),
                    //fillColor: Colors.green),
                    controller: telController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                      icon: Icon(Icons.alternate_email_outlined,
                          color: Colors.blue[300]),
                      hintText: 'Enter your email address',
                      labelText: 'Email',
                    ),
                    controller: emailController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                      icon: Icon(Icons.wb_cloudy_rounded,
                          color: Colors.blue[300]),
                      hintText: 'Enter your store website URLs',
                      labelText: 'Website',
                    ),
                    controller: storeUrlController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                      icon: Icon(Icons.local_restaurant_rounded,
                          color: Colors.blue[300]),
                      hintText: 'Enter your store category',
                      labelText: 'Category',
                    ),
                    controller: categoryController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                      icon: Icon(Icons.attach_money_rounded,
                          color: Colors.blue[300]),
                      hintText: 'Enter your cancellation fee per person',
                      labelText: 'Cancellation Fee',
                    ),
                    controller: depositController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
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
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                    child: Text(
                      "Vacancy Type",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[300],
                      ),
                    ),
                  ),
                  Row(children: [
                    Expanded(
                        child: ListTile(
                      title: const Text(
                        'Strict',
                        style: TextStyle(
                          fontSize: 11.5,
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
                          'Flex',
                          style: TextStyle(
                            fontSize: 11.5,
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
                    Expanded(
                      child: ListTile(
                        title: const Text(
                          'Custom',
                          style: TextStyle(
                            fontSize: 11.5,
                          ),
                        ),
                        leading: Radio(
                          value: "custom",
                          groupValue: _vacancyType,
                          onChanged: (value) {
                            setState(() {
                              _vacancyType = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ]),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        assignVariable();
                        _updateStoreProfile();
                        print("shopData in ElevatedButton onPressed $shopData");
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         MerchantCalendarPage(shopData: shopData),
                        //   ),
                        // );
                      }
                    },
                    child: Text('Next Page'),
                  )
                ])));
  }

  void _changePage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
    print("Going to $route was triggered");
  }

  Future<void> _updateStoreProfile() async {
    print("shopData in _updateStoreProfile $shopData");
    print("JSON stringiified shopdata ${jsonEncode(shopData)}");
    var response = await http.patch(
      "https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$_userId",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(shopData),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("_updateStoreProfile jsonResponse= $jsonResponse");
      _changePage(context, MerchantRoute);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _getShopData() async {
    var userData = await Amplify.Auth.getCurrentUser();
    var userId = userData.userId;
    setState(() => _userId = userId);
    var response = await http.get(
        'https://pq3mbzzsbg.execute-api.ap-northeast-1.amazonaws.com/CaffeExpressRESTAPI/store/$userId');
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

  void _mapMountedStoreData() {
    print("shopData in _mapMountedStoreData $shopData");
    nameController.text = shopData['name'];
    descriptionController.text = shopData['descripti'];
    addressController.text = shopData['address'];
    telController.text = shopData['tel'];
    emailController.text = shopData['contactEmail'];
    storeUrlController.text = shopData['storeURL'];
    categoryController.text = shopData['category'];
    depositController.text = shopData['depositAmountPerPerson'].toString();
    if (shopData['imagePaths'].length > 0) {
      imageController.text = shopData['imagePaths'][0];
    } else {
      imageController.text = "";
    }
    _vacancyType = shopData['vacancyType'];
    shopData.remove("id");
  }
}
