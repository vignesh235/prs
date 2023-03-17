import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prs/Screens/bottomnavigation.dart';
import 'package:prs/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Select Ttem'),
      ),
      body:
      
       ListView.builder(
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            var i = index + 1;
            return GestureDetector(
                onTap: (() {
                  setState(() {
                    var des = {};
                    des["item_code"] = _items[index]["name"];
                    des["name"] = _items[index]["item_name"];
                    des["rate"] = _items[index]["standard_rate"];
                    selectitem.add(des);
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              bottomnavigation()));
                }),
                child: Card(
                    elevation: 3,
                    child: ListTile(
                        leading: Text(i.toString()),
                        trailing: Text("₹ : ${_items[index]["standard_rate"]}"),
                        subtitle: Text("Qty : ${_items[index]["actual_qty"]}"),
                        title: Text(_items[index]["item_name"]))));
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
      print((response.data["message"]));
      setState(() {
        _items = (response.data["message"]);
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
}
