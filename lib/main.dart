import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'HomePage.dart';
import 'ItemList.dart';
import 'login.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      // routes: {
      //   '/Homescreen': (context) => const HomePage(),
      //   '/ItemList': (context) => const ItemList(),
      // },
      title: 'My App',
      debugShowCheckedModeBanner: false,
      home: const test(),
    );
  }
}
