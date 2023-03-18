import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class materialrequest extends StatefulWidget {
  const materialrequest({super.key});

  @override
  State<materialrequest> createState() => _materialrequestState();
}

class _materialrequestState extends State<materialrequest> {
  List _items = [];
  var mi_finalitem = {};
  initState() {
    // ignore: avoid_print
    super.initState();
    Item_List();
    print("initState Called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Select Item'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: requireddate, //editing controller of this TextField
                decoration: const InputDecoration(
                    prefixIcon: Icon(
                      PhosphorIcons.calendar,
                      color: Colors.grey,
                    ),
                    // icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Date" //label text of field
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
                      requireddate.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    var i = index + 1;
                    return Card(
                        elevation: 3,
                        child: ListTile(
                            leading: Text(i.toString()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                    height: 25,
                                    width: 45,
                                    child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                        hintText: "Qty",
                                        hintStyle: TextStyle(fontSize: 12),
                                        counterText: "",
                                      ),
                                      onChanged: (qty) {
                                        var item_name = _items[index]["name"];
                                        if (qty != '') {
                                          mi_finalitem[item_name] = qty;
                                        } else {
                                          mi_finalitem[item_name] = '0';
                                        }

                                        _items[index]["item_qty"] = qty;
                                        print(mi_finalitem);
                                      },
                                    ))
                              ],
                            ),
                            subtitle:
                                Text("Qty : ${_items[index]["actual_qty"]}"),
                            title: Text(_items[index]["item_name"])));
                  }),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height / 16,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  print(customers.text);
                  print(date.text);
                  print(selectitem);

                  material_request(
                      requireddate.text, json.encode(mi_finalitem));

                  print("object");
                },
                child: const Text('  Submit  '),
              ),
            ),
          ]),
        ));
  }

  Item_List() async {
    try {
      Dio dio = Dio();
      SharedPreferences Autho = await SharedPreferences.getInstance();

      dio.options.headers = {
        "Authorization": Autho.getString('token') ?? '',
      };

      Response response = await dio
          .get("${dotenv.env['API_URL']}/api/method/oxo.custom.api.item_lists");

      setState(() {
        _items = (response.data["message"]);
      });
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

  material_request(date, item) async {
    print(item);
    print("object");
    SharedPreferences Autho = await SharedPreferences.getInstance();

    try {
      var dio = Dio();
      dio.options.headers = {
        "Authorization": Autho.getString('token') ?? '',
      };
      var url =
          '${dotenv.env['API_URL']}/api/method/oxo.custom.api.material_request';
      var data = {
        'items': item,
        'delivery_date': date,
      };
      print(data);

      var response = await dio.post(url, data: data);
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        var responseData = response.data;
        Fluttertoast.showToast(
            msg: responseData["message"].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xFF273b69),
            textColor: Colors.white,
            fontSize: 16.0);
        requireddate.clear();
        metrialitem.clear();
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e);
    }
  }
}
