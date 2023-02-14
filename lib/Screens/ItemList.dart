import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prs/constant.dart';
// import 'package:dio/dio.dart';
// import 'package:prs/AnimatedContainerExample.dart';

// class ItemList extends StatefulWidget {
//   const ItemList({super.key});

//   @override
//   State<ItemList> createState() => _ItemListState();
// }

// class _ItemListState extends State<ItemList> {
//   List<dynamic> Item_list_ = [];
//   final GlobalKey<AnimatedListState> _key = GlobalKey();
//   @override
//   // ignore: must_call_super
//   initState() {
//     // ignore: avoid_print
//     super.initState();
//     Item_List();
//     print("initState Called");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedList(
//           key: _key,
//           initialItemCount: Item_list_.length,
//           itemBuilder: (_, index, animation) {
//             return SizeTransition(
//                 key: UniqueKey(),
//                 sizeFactor: animation,
//                 child: ListTile(
//                     leading: const Icon(Icons.list),
//                     trailing: Text(
//                       Item_list_[index]["standard_rate"].toString(),
//                       style: TextStyle(color: Colors.green, fontSize: 15),
//                     ),
//                     title: Text(Item_list_[index]["item_name"].toString())));
//           }),
//     );
//   }

//   Item_List() async {
//     Dio dio = Dio();
//     dio.options.headers = {
//       "Authorization": "token ddc841db67d4231:bb0987569c46dd4",
//     };

//     Response response = await dio.get(
//         "http://demo14prime.thirvusoft.co.in//api/method/oxo.custom.api.item_list");

//     setState(() {
//       Item_list_.insert(0, response.data["message"].toString());
//       _key.currentState!.insertItem(0, duration: const Duration(seconds: 1));
//     });
//   }
// }
class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  // Items in the list

  List _items = [];

  // The key of the list
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  // Add a new item to the list
  // This is trigger when the floating button is pressed
  initState() {
    // ignore: avoid_print
    super.initState();
    Item_List();
    print("initState Called");
  }

  void _addItem() {
    _items.insert(0, "dddddddddd ${_items.length + 1}");
    _key.currentState!
        .insertItem(0, duration: const Duration(milliseconds: 500));
  }

  // Remove an item
  // This is trigger when the trash icon associated with an item is tapped
  // void _removeItem(int index) {
  //   _key.currentState!.removeItem(index, (_, animation) {
  //     return SizeTransition(
  //       sizeFactor: animation,
  //       child: const Card(
  //         margin: EdgeInsets.all(10),
  //         elevation: 10,
  //         color: Colors.purple,
  //         child: ListTile(
  //           contentPadding: EdgeInsets.all(15),
  //           title: Text("Goodbye", style: TextStyle(fontSize: 24)),
  //         ),
  //       ),
  //     );
  //     ;
  //   }, duration: const Duration(seconds: 1));

  //   _items.removeAt(index);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kindacode.com'),
      ),
      body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (BuildContext context, index) {
            var i = index + 1;
            return GestureDetector(
                onTap: (() {
                  var des = {};
                  des["item_code"] = _items[index]["name"];
                  des["name"] = _items[index]["item_name"];
                  des["rate"] = _items[index]["standard_rate"];
                  selectitem.add(des);
                  Navigator.pushNamed(context, '/Homescreen');
                }),
                child: Card(
                    elevation: 3,
                    child: ListTile(
                        leading: Text(i.toString()),
                        trailing:
                            Text(_items[index]["standard_rate"].toString()),
                        title: Text(_items[index]["item_name"]))));
          }),
    );
    // floatingActionButton: FloatingActionButton(
    //     onPressed: _addItem, child: const Icon(Icons.add)),
  }

  Item_List() async {
    Dio dio = Dio();
    dio.options.headers = {
      "Authorization": "token ddc841db67d4231:bb0987569c46dd4",
    };

    Response response = await dio.get(
        "http://demo14prime.thirvusoft.co.in//api/method/oxo.custom.api.item_list");

    setState(() {
      _items = (response.data["message"]);
    });
  }
}
