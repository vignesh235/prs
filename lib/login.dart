import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login"),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: mobilenumber,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: password,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () {
                  print("object");
                  login(mobilenumber.text, password.text);
                },
                child: const Text('  Login  '),
              ),
            ],
          )),
    );
  }

  login(mobilenumber, password) async {
    print("object");
    Dio dio = Dio();

    var data = {"mobile": mobilenumber, "password": password};

    Response response = await dio.post(
        "http://demo14prime.thirvusoft.co.in//api/method/oxo.custom.api.login",
        queryParameters: data);
    var responseData = response.data;
    print(responseData);
    if (responseData["message"] == "Logined Sucessfully") {
      Navigator.pushNamed(context, '/ItemList');
    }
  }
}
