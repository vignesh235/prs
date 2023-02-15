import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prs/Screens/login.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'bottomnavigation.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  late Timer timer;

  void initState() {
    super.initState();
    time();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Future time() async {
    print("object");

    SharedPreferences Autho = await SharedPreferences.getInstance();
    print(Autho.getString("token"));

    if (Autho.getString('token') == null) {
      timer = Timer(
          const Duration(seconds: 2),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              )));
    } else {
      timer = Timer(
          const Duration(seconds: 2),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => bottomnavigation(),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(child: Image.asset("assets/Splash_screen1.gif")));
  }
}
