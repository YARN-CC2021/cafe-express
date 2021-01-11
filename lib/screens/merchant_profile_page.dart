import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amplify_core/amplify_core.dart';
import './merchant_calendar_page.dart';

class MerchantProfilePage extends StatefulWidget {
  @override
  _MerchantProfilePageState createState() => _MerchantProfilePageState();
}

class _MerchantProfilePageState extends State<MerchantProfilePage> {
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
  var profile = {};

  void assignVariable() {
    profile["name"] = nameController.text;
    profile["description"] = descriptionController.text;
    profile["address"] = addressController.text;
    profile["tel"] = telController.text;
    profile["email"] = emailController.text;
    profile["storeURL"] = storeUrlController.text;
    profile["category"] = categoryController.text;
    profile["depositAmountPerPerson"] = depositController.text;
    profile["imagePaths"] = imageController.text;
    profile["vacancyType"] = _vacancyType;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text("Cafe Express"),
          backgroundColor: Colors.blue,
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
                        print(profile);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MerchantCalendarPage(profile: profile),
                          ),
                        );
                      }
                    },
                    child: Text('Next Page'),
                  )
                ])));
  }
}
