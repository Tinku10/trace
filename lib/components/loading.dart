import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  // const Spinner({Key key}) : super(key: key);
  
  Widget spinkit = SpinKitDoubleBounce(
    color: Colors.white,
    size: 100.0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: spinkit
    );
  }
}