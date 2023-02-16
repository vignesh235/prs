import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prs/Screens/Dashboard.dart';
import 'package:prs/Screens/SalesOrder.dart';
import 'package:prs/constant.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'Customer.dart';

void main() {
  runApp(bottomnavigation());
}

class bottomnavigation extends StatefulWidget {
  @override
  _bottomnavigationState createState() => _bottomnavigationState();
}

class _bottomnavigationState extends State<bottomnavigation> {
  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    HomePage(),
    customer(),
  ];
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        // onTap: (i) => setState(() => currentIndex = i,),
        onTap: (i) => setState(() {
          currentIndex = i;
        }),
        items: [
          SalomonBottomBarItem(
            icon: Icon(
              PhosphorIcons.list_dashes,
              size: screenwidth <= 360 ? 20 : 23,
            ),
            title: Text(
              "Dashboard",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: screenwidth <= 360 ? 9 : 10.5,
                    letterSpacing: .2,
                    color: Color(0xff19183e)),
              ),
            ),
            selectedColor: Color(0xffE19183E),
          ),
          SalomonBottomBarItem(
            icon: Icon(
              PhosphorIcons.shopping_cart_light,
              size: screenwidth <= 360 ? 20 : 23,
            ),
            title: Text(
              "Sales Order",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: screenwidth <= 360 ? 9 : 10.5,
                    letterSpacing: .2,
                    color: Color(0xff19183e)),
              ),
            ),
            selectedColor: Color(0xffE19183E),
          ),
          SalomonBottomBarItem(
            icon: Icon(
              PhosphorIcons.user_plus_light,
              size: screenwidth <= 360 ? 20 : 23,
            ),
            title: Text(
              "Customer",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: screenwidth <= 360 ? 9 : 10.5,
                    letterSpacing: .3,
                    color: Color(0xff19183e)),
              ),
            ),
            selectedColor: Color(0xffE19183E),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(currentIndex),
    );
  }
}
