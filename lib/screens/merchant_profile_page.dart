import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amplify_core/amplify_core.dart';

enum VacancyType { strict, flex, custom }

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
  bool _lights = false;

  VacancyType _vacancyType = VacancyType.strict;

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
                    maxLines: 3,
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
                    padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    child: Text(
                      "Vacancy Type",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[300],
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Strict'),
                    leading: Radio(
                      value: VacancyType.strict,
                      groupValue: _vacancyType,
                      onChanged: (VacancyType value) {
                        setState(() {
                          _vacancyType = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Flex'),
                    leading: Radio(
                      value: VacancyType.flex,
                      groupValue: _vacancyType,
                      onChanged: (VacancyType value) {
                        setState(() {
                          _vacancyType = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Custom'),
                    leading: Radio(
                      value: VacancyType.custom,
                      groupValue: _vacancyType,
                      onChanged: (VacancyType value) {
                        setState(() {
                          _vacancyType = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.lock_outline,
                      color: Colors.purple,
                    ),
                    title: Text("じっけん"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      //go
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Lights'),
                    value: _lights,
                    onChanged: (bool value) {
                      setState(() {
                        _lights = value;
                      });
                    },
                    secondary: const Icon(Icons.lightbulb_outline),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        print(emailController.text);
                      }
                    },
                    child: Text('Submit'),
                  )
                ])));
  }
}
