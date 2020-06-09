import 'package:flutter/material.dart';
import 'components/home.dart';
import 'components/search.dart';
import 'components/charts.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'keys/key.dart';

void main() {
  Secrets key = Secrets();
  SyncfusionLicense.registerLicense(key.getKey());
  runApp(MaterialApp(initialRoute: '/', routes: {
    '/': (context) => Global(),
    '/search': (context) => Search(),
    '/graph': (context) => Chart()
  }));
}
