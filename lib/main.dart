import 'package:flutter/material.dart';
import 'components/home.dart';
import 'components/search.dart';
import 'components/charts.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';


void main() {
  SyncfusionLicense.registerLicense(
      'NT8mJyc2IWhia31ifWN9Z2FoYmF8YGJ8ampqanNiYmlmamlmanMDHmgnOj04Jn04JSATND4yOj99MDw+');
  runApp(MaterialApp(initialRoute: '/', routes: {
    '/': (context) => Global(),
    '/search': (context) => Search(),
    '/graph': (context) => Chart()
  }));
}
