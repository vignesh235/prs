// ignore_for_file: unnecessary_const

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prs/Screens/bottomnavigation.dart';
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
  bool isHidden = true;
  bool loding = false;

  @override
  void togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

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
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a valid mobile number!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                      ),
                      suffix: Icon(
                        PhosphorIcons.phone_light,
                        color: Color.fromARGB(255, 15, 15, 15),
                      ),
                      hintText: "Mobile Number",
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
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  obscureText: isHidden,
                  controller: password,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a valid password!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.white, width: 0.0),
                      ),
                      suffix: InkWell(
                        onTap: togglePasswordView,
                        child: Icon(
                          isHidden
                              ? PhosphorIcons.eye_slash_light
                              : PhosphorIcons.eye_light,
                        ),
                      ),
                      isDense: true,
                      filled: true,
                      hintText: "Password",
                      fillColor: Color(0xFFf0f1f5),
                      border: const OutlineInputBorder(
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
                    if (formKey.currentState!.validate()) {
                      print("object");
                      setState(() {
                        loding = true;
                      });
                      login(mobilenumber.text, password.text);
                    }
                  },
                  child: loding
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation(Colors.green),
                        )
                      : const Text('  Log in  '),
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

    Response response = await dio.get(
        "https://demo14prime.thirvusoft.co.in//api/method/oxo.custom.api.login",
        queryParameters: data);
    var responseData = response.data;
    print(response.data["token"]);
    Autho.setString('token', response.data['token'] ?? "");
    Autho.setString('full_name', response.data['full_name'] ?? "");
    print(responseData);

    if (responseData["message"] == "Logined Sucessfully") {
      Fluttertoast.showToast(
          msg: responseData["message"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFF273b69),
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        loding = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => bottomnavigation(),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        loding = false;
      });
      Fluttertoast.showToast(
          msg: responseData["message"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
