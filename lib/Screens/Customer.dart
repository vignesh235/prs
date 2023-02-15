import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:math';

class customer extends StatefulWidget {
  const customer({super.key});

  @override
  State<customer> createState() => _customerState();
}

class _customerState extends State<customer> {
  final formKey = GlobalKey<FormState>();
  final customername = TextEditingController();
  final mobilenumber = TextEditingController();
  final doorno = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final districts = TextEditingController();
  final area = TextEditingController();
  final pincode = TextEditingController();
  List statelist = [];
  List districtslist = [];
  List areafinallist_ = [];
  @override
  File? _image;

  late File imageFile;

  GlobalKey<FormState> dealerkey_ = GlobalKey<FormState>();

  void initState() {
    // TODO: implement initState
    // territory_list();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEB455F),
        title: Text(
          'Dealer Creation',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 20, letterSpacing: .2, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
            key: dealerkey_,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Column(
                children: [
                  TextFormField(
                    
                    textCapitalization: TextCapitalization.characters,
                    controller: customername,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter dealer name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Dealer Name",
                      // hintText: "Enter dealer name"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: mobilenumber,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter mobile number';
                      } else if (!RegExp(
                              r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
                          .hasMatch(value)) {
                        return "Please enter a valid nhone number";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      counterText: "",
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Mobile Number",
                      // hintText: "Enter dealer mobile number"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Add Dealer Address",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF2B3467)),
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: doorno,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter doorno';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Door No",
                      // hintText: "Enter door no"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: city,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter street';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 66, 65, 65)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Street",
                      // hintText: "Enter street"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SearchField(
                    controller: state,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select State';
                      }
                      if (!statelist.contains(value)) {
                        return 'State not found';
                      }
                      return null;
                    },
                    suggestions: statelist
                        .map((String) => SearchFieldListItem(String))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    textInputAction: TextInputAction.next,
                    hasOverlay: false,
                    marginColor: Colors.white,
                    searchStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    onSuggestionTap: (x) {
                      FocusScope.of(context).unfocus();
                      // territory_list(dealerstate.text);
                    },
                    searchInputDecoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "State",
                      // hintText: "State"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SearchField(
                    controller: districts,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select district';
                      }
                      if (!districtslist.contains(value)) {
                        return 'districts not found';
                      }
                      return null;
                    },
                    suggestions: districtslist
                        .map((String) => SearchFieldListItem(String))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    marginColor: Colors.white,
                    onSuggestionTap: (x) {
                      FocusScope.of(context).unfocus();
                      // for (int g = 0; g < arealist_.length; g++) {
                      //   print(arealist_[g][districts.text]);
                      //   setState(() {
                      //     areafinallist_ = (arealist_[g][districts.text]);
                      //   });
                      // }
                      // print(districts.text);
                    },
                    textInputAction: TextInputAction.next,
                    hasOverlay: false,
                    searchStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    searchInputDecoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "District",
                      // hintText: "Select District"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SearchField(
                    controller: area,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select area';
                      }
                      if (!areafinallist_.contains(value)) {
                        return 'Area not found';
                      }
                      return null;
                    },
                    suggestions: areafinallist_
                        .map((String) => SearchFieldListItem(String))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    marginColor: Colors.white,
                    onSuggestionTap: (x) {
                      FocusScope.of(context).unfocus();
                      // pincode_text.text = dealerarea.text.split("-").last;
                    },
                    textInputAction: TextInputAction.next,
                    hasOverlay: false,
                    searchStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    searchInputDecoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Area",
                      // hintText: "Select Area"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    // readOnly: true,
                    controller: pincode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select pincode';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        //                           // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Pincode",
                      // hintText: "Pincode"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height / 13.5,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          print("object");
                        }
                      },
                      child: const Text('  Log in  '),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
