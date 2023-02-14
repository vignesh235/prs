// ignore_for_file: unnecessary_const

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final mobilenumber = TextEditingController();
  final password = TextEditingController();
  @override
  initState() {
    // ignore: avoid_print
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: Text("₹",
                          style: TextStyle(
                              color: Color(0xFFffffff),
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              letterSpacing: .2))),
                  SizedBox(
                    width: 5,
                  ),
                  Text("SALES PRO",
                      style: TextStyle(
                          color: Color(0xFF273b69),
                          fontWeight: FontWeight.w200,
                          fontSize: 25,
                          letterSpacing: .2))
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              const Text("Log in to continue",
                  style: TextStyle(
                      color: Color(0xFF273b69),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: .2)),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                      ),
                      suffix: Icon(
                        PhosphorIcons.envelope,
                        color: Color.fromARGB(255, 15, 15, 15),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: Color(0xFFf0f1f5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      )),
                  controller: mobilenumber,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: password,
                  decoration: const InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                      ),
                      suffix: Icon(
                        PhosphorIcons.password,
                        color: Color.fromARGB(255, 15, 15, 15),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: Color(0xFFf0f1f5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      )),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height / 13.5,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () {
                    print("object");
                    login(mobilenumber.text, password.text);
                  },
                  child: const Text('  Log in  '),
                ),
              ),
            ],
          )),
    );
  }

  login(mobilenumber, password) async {
    SharedPreferences Autho = await SharedPreferences.getInstance();

    print("object");
    Dio dio = Dio();

    var data = {"mobile": mobilenumber, "password": password};

    Response response = await dio.post(
        "http://demo14prime.thirvusoft.co.in//api/method/oxo.custom.api.login",
        queryParameters: data);
    var responseData = response.data;
    print(response.data["token"]);
    Autho.setString('token', response.data['token'] ?? "");
    print(responseData);
    if (responseData["message"] == "Logined Sucessfully") {
      Fluttertoast.showToast(
          msg: responseData["message"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushNamed(context, '/bottomsheeet');
    }
  }
}
