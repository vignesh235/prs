import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      body: ListView.builder(
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
                                // var des = {};
                                // des["item_code"] = _items[index]["name"];
                                // des["qty"] = value;
                                // setState(() {
                                //   metrialitem.add(des);

                                // });
                                // setState(() {
                                //   _items[index]["qty"] = value;
                                //   // Add item name and qty to des property
                                //   _items[index]["des"] =
                                //       "${_items[index]["item_name"]} - Qty: $value";
                                // });
                                // print("Qty : ${_items[index]["actual_qty"]}");
                                // print("Qty : ${_items[index]["item_name"]}");
                              },
                            ))
                      ],
                    ),
                    subtitle: Text("Qty : ${_items[index]["actual_qty"]}"),
                    title: Text(_items[index]["item_name"])));
          }),
    );
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
}
