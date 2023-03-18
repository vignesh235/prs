import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prs/Screens/ItemList.dart';
import 'package:searchfield/searchfield.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  bool total_amount_visible = false;
  int length = 0;

  @override
  initState() {
    // ignore: avoid_print
    super.initState();
    _floatprecision();
    customerlist();
    print("initState Called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(' Sales Order '),
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
                        controller: customers,
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
                          prefixIcon: Icon(
                            PhosphorIcons.user,
                            color: Colors.grey,
                          ), // icon is 48px widget.

                          labelText: "Customer",
                          // hintText: "Select District"
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        controller: date, //editing controller of this TextField
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
                              date.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        controller: paidamount_,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              PhosphorIcons.currency_inr,
                              color: Colors.grey,
                            ),
                            labelText: "Paid amount" //label text of field
                            ),
                      ),
                    ),
                    (selectitem.isEmpty)
                        ? const SizedBox()
                        : const Text("Selected Item"),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffe6f0ff),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 100.0,
                              color: Color(0xffe6ecff),
                              spreadRadius: 1,
                              offset: Offset(
                                20,
                                20,
                              ),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height /
                                  12 *
                                  selectitem.length,
                              child: ListView.builder(
                                  itemCount: selectitem.length,
                                  shrinkWrap: true,
                                  key: UniqueKey(),
                                  itemBuilder: (BuildContext context, index) {
                                    int i = index + 1;
                                    textFieldValue =
                                        selectitem[index]["qty"] ?? "";
                                    print(selectitem);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      child: Card(
                                          child: ListTile(
                                              leading: Text(i.toString()),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    selectitem[index]["rate"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF273b69),
                                                        fontSize: 15),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                      height: 25,
                                                      width: 60,
                                                      child: TextFormField(
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: "Qty",
                                                          hintStyle: TextStyle(
                                                              fontSize: 12),
                                                          counterText: "",
                                                        ),
                                                        maxLength: (length > 0)
                                                            ? length
                                                            : 4,
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        initialValue:
                                                            textFieldValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            print(selectitem[
                                                                index]["name"]);
                                                            double prevQty =
                                                                double.tryParse(
                                                                        selectitem[index]["qty"] ??
                                                                            "0") ??
                                                                    0.0;
                                                            selectitem[index]
                                                                ["qty"] = value;
                                                            print(selectitem[
                                                                index]["qty"]);
                                                            double newQty =
                                                                double.tryParse(
                                                                        selectitem[index]["qty"] ??
                                                                            "0") ??
                                                                    0.0;
                                                            double rate =
                                                                selectitem[
                                                                        index]
                                                                    ["rate"];
                                                            double itemTotal =
                                                                (newQty -
                                                                        prevQty) *
                                                                    rate;
                                                            finaltotalamount_ +=
                                                                itemTotal;
                                                            print(itemTotal);
                                                            print(
                                                                finaltotalamount_);
                                                            // if (selectitem[
                                                            //             index]
                                                            //         ["qty"] ==
                                                            //     "") {
                                                            //   setState(() {
                                                            //     selectitem
                                                            //         .removeAt(
                                                            //             index);
                                                            //   });
                                                            // }

                                                            // Print the updated list of items
                                                            print(selectitem);
                                                          });
                                                        },
                                                      )),
                                                  IconButton(
                                                      color: const Color(
                                                          0xff273b69),
                                                      onPressed: () {
                                                        print("check");
                                                        setState(() {
                                                          double newQty = double
                                                                  .tryParse(selectitem[
                                                                              index]
                                                                          [
                                                                          "qty"] ??
                                                                      "0") ??
                                                              0.0;
                                                          double rate =
                                                              selectitem[index]
                                                                  ["rate"];
                                                          finaltotalamount_ =
                                                              finaltotalamount_ -
                                                                  (newQty) *
                                                                      rate;
                                                          selectitem
                                                              .removeAt(index);
                                                          textFieldValue =
                                                              newQty.toString();
                                                        });
                                                        print(
                                                            "00000000000000000000000000000000000000000000000000000");
                                                        print(selectitem);
                                                        print(textFieldValue);
                                                      },
                                                      icon: const Icon(
                                                          PhosphorIcons
                                                              .trash_light)),
                                                ],
                                              ),
                                              title: Text(
                                                  selectitem[index]["name"]))),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height / 16,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFF273b69)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => test()),
                              );
                            },
                            child: const Text('Add Item'),
                          ),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height / 16,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              print(customers.text);
                              print(date.text);
                              print(selectitem);

                              login(customers.text, date.text,
                                  json.encode(selectitem), paidamount_.text);

                              print("object");
                            },
                            child: const Text('  Submit  '),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                        "Total Amount : ${finaltotalamount_.toStringAsFixed(2)}"),
                    // Visibility(
                    //     visible: total_amount_visible,
                    //     child: Text("Total Amount:  $totalamount"))
                  ],
                )),
          ],
        ));
  }

  customerlist() async {
    SharedPreferences Autho = await SharedPreferences.getInstance();
    Dio dio = Dio();
    dio.options.headers = {
      "Authorization": Autho.getString('token') ?? '',
    };
    Response response = await dio.get(
        "${dotenv.env['API_URL']}/api/method/oxo.custom.api.customer_list");
    setState(() {
      customerlist_ = (response.data["message"]);
    });
  }

  Future<int> _floatprecision() async {
    SharedPreferences Autho = await SharedPreferences.getInstance();
    Dio dio = Dio();
    dio.options.headers = {
      "Authorization": Autho.getString('token') ?? '',
    };
    Response response = await dio.get(
        "${dotenv.env['API_URL']}/api/method/frappe.client.get_value?doctype=System%20Settings&fieldname=float_precision");
    setState(() {
      length = int.parse(response.data["message"]["float_precision"]);
    });
    return length;
  }

  login(customer, date, item, paidamount) async {
    print(item);
    print("object");
    SharedPreferences Autho = await SharedPreferences.getInstance();

    try {
      var dio = Dio();
      dio.options.headers = {
        "Authorization": Autho.getString('token') ?? '',
      };
      var url =
          '${dotenv.env['API_URL']}/api/method/oxo.custom.api.sales_order';
      var data = {
        'cus_name': customer,
        'items': item,
        'delivery_date': date,
        'amount': paidamount
      };
      print(data);

      var response = await dio.post(url, data: data);
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          total_amount_visible = true;
        });

        var responseData = response.data;
        totalamount = responseData["Total"].toString();

        Fluttertoast.showToast(
            msg: responseData["message"].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xFF273b69),
            textColor: Colors.white,
            fontSize: 16.0);
        cleardata();
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

  cleardata() {
    Timer(const Duration(seconds: 4), () {
      setState(() {
        customers.clear();
        date.clear();
        selectitem.clear();
        finaltotalamount_ = 0.0;

        total_amount_visible = false;
      });
    });
  }
}
