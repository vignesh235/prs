import 'package:flutter/material.dart';

List itemlist_ = [];
final GlobalKey<AnimatedListState> listKey = GlobalKey();
List selectitem = [];
var currentIndex = 0;
bool custbutton = true;

final customers = TextEditingController();
final date = TextEditingController();
final paidamount_ = TextEditingController();
List customerlist_ = [];
var totalamount = "";
double totalamount_ = 0.0;
double finaltotalamount_ = 0.0;
String textFieldValue = "";
String textFieldValuem = "";

List metrialitem = [];
