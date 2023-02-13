import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:prs/AnimatedContainerExample.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List Item_list_ = [];
  @override
  // ignore: must_call_super
  initState() {
    // ignore: avoid_print
    Item_List();
    print("initState Called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: Item_list_.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                child: ListTile(
                    leading: const Icon(Icons.list),
                    trailing: Text(
                      Item_list_[index]["standard_rate"].toString(),
                      style: TextStyle(color: Colors.green, fontSize: 15),
                    ),
                    title: Text(Item_list_[index]["item_name"])));
          }),
    );
  }

  Item_List() async {
    Dio dio = Dio();
    dio.options.headers = {
      "Authorization": "token ddc841db67d4231:bb0987569c46dd4",
    };

    Response response = await dio.get(
        "http://demo14prime.thirvusoft.co.in//api/method/oxo.custom.api.item_list");

    setState(() {
      Item_list_ = response.data["message"];
    });
  }
}
