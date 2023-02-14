import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:intl/intl.dart';

import '../constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final customer = TextEditingController();
  final date = TextEditingController();
  List customerlist_ = [];
  @override
  initState() {
    // ignore: avoid_print
    super.initState();
    customerlist();
    print("initState Called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('  '),
        ),
        body: ListView(
          children: [
            Form(
                key: formKey,
                child: Column(
                  
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: SearchField(
                        controller: customer,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select district';
                          }
                          // if (!customerlist_.contains(value)) {
                          //   return 'customer not found';
                          // }
                          return null;
                        },
                        suggestions: customerlist_
                            .map((String) => SearchFieldListItem(String))
                            .toList(),
                        suggestionState: Suggestion.expand,
                        marginColor: Colors.white,
                        onSuggestionTap: (x) {
                          FocusScope.of(context).unfocus();
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
                            borderSide: BorderSide(
                                color: Color(0xFFEB455F), width: 2.0),
                          ),
                          labelText: "Customer",
                          // hintText: "Select District"
                        ),
                      ),
                    ),
                    TextField(
                      controller: date, //editing controller of this TextField
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Enter Date" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            date.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height /
                          12 *
                          selectitem.length,
                      child: ListView.builder(
                          itemCount: selectitem.length,
                          itemBuilder: (BuildContext context, index) {
                            String textFieldValue =
                                selectitem[index]["qty"] ?? "";

                            return Card(
                                child: ListTile(
                                    leading: const Icon(Icons.list),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          selectitem[index]["rate"].toString(),
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: TextFormField(
                                              initialValue: textFieldValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectitem[index]["qty"] =
                                                      value;
                                                  if (selectitem[index]
                                                          ["qty"] ==
                                                      "") {
                                                    setState(() {
                                                      selectitem
                                                          .removeAt(index);
                                                    });
                                                  }
                                                  print(selectitem);
                                                });
                                              },
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              print("check");
                                              setState(() {
                                                selectitem.removeAt(index);
                                              });
                                            },
                                            icon: const Icon(Icons.delete)),
                                      ],
                                    ),
                                    title: Text(selectitem[index]["name"])));
                          }),
                    ),
                    // Text(selectitem.toString()),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ItemList');
                      },
                      child: const Text('Add Item'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        print(customer.text);
                        print(date.text);
                        print(selectitem);
                        login(
                            customer.text, date.text, json.encode(selectitem));
                        print("object");
                      },
                      child: const Text('  Login  '),
                    ),
                  ],
                )),
          ],
        ));
  }

  customerlist() async {
    Dio dio = Dio();
    dio.options.headers = {
      "Authorization": "token ddc841db67d4231:bb0987569c46dd4",
    };
    Response response = await dio.get(
        "http://demo14prime.thirvusoft.co.in//api/method/oxo.custom.api.customer_list");
    setState(() {
      customerlist_ = (response.data["message"]);
    });
  }

  login(customer, date, item) async {
    print(item);
    print("object");
    try {
      var dio = Dio();
      dio.options.headers = {
        "Authorization": "token ddc841db67d4231:bb0987569c46dd4",
      };
      var url =
          'http://demo14prime.thirvusoft.co.in//api/method/oxo.custom.api.sales_order';
      var data = {'cus_name': customer, 'items': item, 'delivery_date': date};
      print(data);

      var response = await dio.post(url, data: data);
      print(response.data);
    } catch (e) {
      print(e);
    }
  }
}
