import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:prs/Screens/Dashboard.dart';
import 'package:prs/Screens/SalesOrder.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Color mainColor = const Color(0xFFff3341);
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: const [
          Dashboard(),
          HomePage(),
        ],
        navBarHeight: 50,
        items: _navBarsItems(),
        bottomScreenMargin: 0,
        resizeToAvoidBottomInset: true,

        // navBarStyle: NavBarStyle.style12,
        // navBarStyle: NavBarStyle.style9,
        // navBarStyle: NavBarStyle.style7,
        // navBarStyle: NavBarStyle.style10,
        navBarStyle: NavBarStyle.style12,
        // navBarStyle: NavBarStyle.style13,
        // navBarStyle: NavBarStyle.style3,
        // navBarStyle: NavBarStyle.style6,
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          PhosphorIcons.house,
        ),
        title: ("Home"),
        activeColorPrimary: mainColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          PhosphorIcons.shopping_cart,
        ),
        title: ("Search"),
        activeColorPrimary: mainColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
