import 'package:animated_widgets/widgets/custom_animated.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:prs/Screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  initState() {
    // ignore: avoid_print
    super.initState();
    count();
    print("initState Called");
  }

  int soCount = 0;
  double totalAmount = 0;
  double value = 0;
  double totalAmountp = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(' Dashboard '),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              PhosphorIcons.sign_out,
              color: Colors.white,
            ),
            onPressed: () {
              _delete(context);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bill count"),
            CircularPercentIndicator(
              animation: true,
              animationDuration: 1200,
              radius: 60.0,
              lineWidth: 15.0,
              percent: value,
              center: CustomAnimatedWidget(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOut,
                builder: (context, percent) {
                  //for custom animation, use builders
                  final int displayedDate = (soCount * percent).floor();
                  return Text(
                    " $displayedDate",
                  );
                },
              ),
              progressColor: const Color(0xFF273b69),
            ),
            const SizedBox(
              height: 100,
            ),
            const Text("Total amount"),
            CircularPercentIndicator(
              animation: true,
              animationDuration: 1200,
              radius: 60.0,
              lineWidth: 15.0,
              percent: totalAmountp / 100,
              center: CustomAnimatedWidget(
                duration: Duration(milliseconds: 1200),
                curve: Curves.easeOut,
                builder: (context, percent) {
                  //for custom animation, use builders
                  final int displayedDate = (totalAmount * percent).floor();
                  return Text(
                    "₹" " $displayedDate",
                  );
                },
              ),
              progressColor: const Color(0xFF273b69),
            )
          ],
        ),
      ),
    );
  }

  count() async {
    SharedPreferences Autho = await SharedPreferences.getInstance();

    try {
      Dio dio = Dio();
      dio.options.headers = {"Authorization": Autho.getString('token') ?? ''};

      Response response = await dio.get(
          "${dotenv.env['API_URL']}/api/method/oxo.custom.api.sales_order_count",
          queryParameters: {
            "username": Autho.getString('full_name').toString()
          });
      Map<String, dynamic> data = response.data["message"];
      setState(() {
        soCount = data["so_count"];
        totalAmount = data["total_amount"];
        print(totalAmount);
        value = soCount / 100;
        print(value);
        totalAmountp = (totalAmount / 1000000.0) * 100;

        print(totalAmountp);
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

  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text("Please Confirm",
                style: TextStyle(
                    fontSize: 20, letterSpacing: .2, color: Color(0xFF2B3467))),
            content: const Text("Are you sure to logout?",
                style: TextStyle(
                    fontSize: 15, letterSpacing: .2, color: Color(0xFF2B3467))),
            actions: [
              // The "Yes" button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () async {
                  final Autho = await SharedPreferences.getInstance();
                  print(Autho.getString("token"));
                  // await token.clear();
                  await Autho.remove('token');
                  print(Autho.getString("token"));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text("Yes"),
              ),
            ],
          );
        });
  }
}
