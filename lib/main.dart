import 'package:flutter/material.dart';
import 'components/home.dart';
import 'components/search.dart';
import 'components/charts.dart';


void main() {
  runApp(MaterialApp(initialRoute: '/', routes: {
    '/': (context) => Chart(),
    '/search': (context) => Search(),
  }));
}
