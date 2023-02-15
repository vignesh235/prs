import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prs/Screens/ItemList.dart';
import 'package:prs/Screens/splashscreen.dart';
import 'Screens/SalesOrder.dart';
import 'Screens/bottomnavigation.dart';
import 'Screens/login.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFffffff),
        //google fonts lato theme...
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: createMaterialColor(const Color(0xFF273b69)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // initialRoute: '/',
      routes: {
        // '/': (context) => HomePage(),

        '/homescreen': (context) => const HomePage(),
        '/detail': (context) => test(),
        // '/itemlist': (context) => test(),
        '/bottomsheeet': (context) => bottomnavigation(),
      },
      title: 'My App',
      debugShowCheckedModeBanner: false,
      home: const splashscreen(),
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    ;
    return MaterialColor(color.value, swatch);
  }
}
