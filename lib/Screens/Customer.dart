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

import '../constant.dart';

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
  List arealist_ = [];
  List areafinallist_ = [];
  @override
  File? _image;

  late File imageFile;

  GlobalKey<FormState> dealerkey_ = GlobalKey<FormState>();

  void initState() {
    setState(() {
      custbutton = true;
    });
    temp();
    // TODO: implement initState
    statelist_();
    // territory_list();
  }

  temp() async {
    SharedPreferences Autho = await SharedPreferences.getInstance();
    print(Autho.getString('token'));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Customer Creation',
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

                      prefixIcon: Icon(
                        PhosphorIcons.user,
                        color: Colors.grey,
                      ),
                      labelText: "Customer Name",
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
                      // focusedBorder: UnderlineInputBorder(
                      //     // borderRadius: BorderRadius.all(Radius.circular(8)),
                      //     //   borderSide:
                      //     //       BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      //     ),
                      prefixIcon: Icon(
                        PhosphorIcons.phone,
                        color: Colors.grey,
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

                      prefixIcon: Icon(
                        PhosphorIcons.door,
                        color: Colors.grey,
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

                          ),
                      prefixIcon: Icon(
                        PhosphorIcons.map_pin,
                        color: Colors.grey,
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
                      territory_list(state.text);
                    },
                    searchInputDecoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),

                      prefixIcon: Icon(
                        PhosphorIcons.map_pin,
                        color: Colors.grey,
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
                      for (int g = 0; g < arealist_.length; g++) {
                        print(arealist_[g][districts.text]);
                        setState(() {
                          areafinallist_ = (arealist_[g][districts.text]);
                        });
                      }
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

                      prefixIcon: Icon(
                        PhosphorIcons.map_pin,
                        color: Colors.grey,
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
                      pincode.text = area.text.split("-").last;
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

                      prefixIcon: Icon(
                        PhosphorIcons.map_pin_line,
                        color: Colors.grey,
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
                          // borderSide:
                          //     BorderSide(color: Color(0xFFEB455F), width: 2.0),
                          ),
                      prefixIcon: Icon(
                        PhosphorIcons.list_numbers,
                        color: Colors.grey,
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
                      onPressed: custbutton
                          ? () {
                              if (dealerkey_.currentState!.validate()) {
                                customercreation(
                                    customername.text,
                                    mobilenumber.text,
                                    doorno.text,
                                    city.text,
                                    state.text,
                                    districts.text,
                                    area.text,
                                    pincode.text);
                                print("object");
                              }
                            }
                          : null,
                      child: const Text('  Submit  '),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  statelist_() async {
    print("check");
    try {
      Dio dio = Dio();
      SharedPreferences Autho = await SharedPreferences.getInstance();

      dio.options.headers = {
        "Authorization": Autho.getString('token') ?? '',
      };

      Response response = await dio
          .get("${dotenv.env['API_URL']}/api/method/oxo.custom.api.state_list");
      print((response.data["message"]));
      setState(() {
        statelist = (response.data["state"]);
      });
      print(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  territory_list(state) async {
    print("check");
    try {
      Dio dio = Dio();
      SharedPreferences Autho = await SharedPreferences.getInstance();

      dio.options.headers = {
        "Authorization": Autho.getString('token') ?? '',
      };

      Response response = await dio.get(
          "${dotenv.env['API_URL']}/api/method/oxo.custom.api.territory",
          queryParameters: {"state": state});
      // print((response.data["message"]));
      print((response.data["State"]));

      print(
          "-----------------------------------------------------------------------------------------------");
      print((response.data["Area"]));
      setState(() {
        districtslist = response.data["State"];
        arealist_ = response.data["Area"];
      });
      print(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  customercreation(customername, mobilenumber, doorno, city, state, district,
      area, pincode) async {
    try {
      setState(() {
        custbutton = false;
      });
      Dio dio = Dio();

      SharedPreferences Autho = await SharedPreferences.getInstance();

      dio.options.headers = {
        "Authorization": Autho.getString('token') ?? '',
      };
      final params = {
        'full_name': customername,
        'phone_number': mobilenumber,
        'doorno': doorno,
        'address': city,
        'districts': district,
        'territory': area,
        'Manual_Data': '',
        'user': Autho.getString('full_name').toString(),
        'pincode': pincode,
      };

      // Make the request
      final response = await dio.get(
          "${dotenv.env['API_URL']}/api/method/oxo.custom.api.new_customer",
          queryParameters: params);

      // Print the response
      if (response.statusCode == 200) {
        setState(() {
          custbutton = true;
        });
        cleardata();
        var responseData = response.data;
        Fluttertoast.showToast(
            msg: responseData["message"].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xFF273b69),
            textColor: Colors.white,
            fontSize: 16.0);
      }
      print(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  cleardata() {
    customername.clear();
    mobilenumber.clear();
    doorno.clear();
    city.clear();
    state.clear();
    districts.clear();
    area.clear();
    pincode.clear();
  }
}
