import 'package:flutter/material.dart';

List itemlist_ = [];
final GlobalKey<AnimatedListState> listKey = GlobalKey();
List selectitem = [];
var currentIndex = 0;
bool custbutton = true;

final customers = TextEditingController();
final date = TextEditingController();
List customerlist_ = [];
var totalamount = "";

