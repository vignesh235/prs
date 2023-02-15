import 'package:animated_widgets/widgets/custom_animated.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
              percent: totalAmountp,
              center: CustomAnimatedWidget(
                duration: Duration(milliseconds: 1200),
                curve: Curves.easeOut,
                builder: (context, percent) {
                  //for custom animation, use builders
                  final int displayedDate = (totalAmount * percent).floor();
                  return Text(
                    " $displayedDate",
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
        value = soCount / 100;
        totalAmountp = totalAmount / 100000;
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
}
