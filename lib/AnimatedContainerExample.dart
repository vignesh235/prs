// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:prs/constant.dart';

// class ItemList extends StatefulWidget {
//   const ItemList({required Key key}) : super(key: key);

//   @override
//   _ItemListState createState() => _ItemListState();
// }

// class _ItemListState extends State<ItemList> {
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey();
//   List<Map<String, dynamic>> _itemList = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedList(
//         key: _listKey,
//         initialItemCount: _itemList.length,
//         itemBuilder: (context, index, animation) {
//           return FadeTransition(
//             opacity: animation,
//             child: ListTile(
//               trailing: Text(
//                 _itemList[index]["standard_rate"].toString(),
//                 style: TextStyle(color: Colors.green, fontSize: 15),
//               ),
//               title: Text(
//                 _itemList[index]["name"],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _fetchData() async {
//     try {
//       final response = await Dio().get(
//         '${dotenv.env['API_URL']}/api/method/visitor_management.api.Item_list',
//       );

//       final items = response.data['message'] as List;
//       setState(() {
//         _itemList = items.map((i) => Map<String, dynamic>.from(i)).toList();
//       });
//     } catch (error) {
//       // Handle the error here
//     }
//   }
// }
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prs/constant.dart';

class item_list extends StatefulWidget {
  const item_list({super.key});

  @override
  State<item_list> createState() => _item_listState();
}

class _item_listState extends State<item_list> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: itemlist_.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimatedContainer(
                duration: Duration(seconds: 15),
                curve: Curves.slowMiddle,
                child: Card(
                    child: ListTile(
                        leading: const Icon(Icons.list),
                        title: Text(itemlist_[index]["name"]))));
          }),
    );
  }

  Future<void> _fetchData() async {
    try {
      final response = await Dio().get(
        '${dotenv.env['API_URL']}/api/method/visitor_management.api.Item_list',
      );
      final items = response.data['message'] as List;
      setState(() {
        itemlist_ = items.map((i) => Map<String, dynamic>.from(i)).toList();
      });

      print(itemlist_);
    } catch (error) {
      print(error);
    }
  }
}
