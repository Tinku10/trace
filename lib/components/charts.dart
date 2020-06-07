import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../data/chartData.dart';
import 'loading.dart';

class Chart extends StatefulWidget {
  // Chart({Key key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List data = [];
  bool loading = true;
  List<ChartData> cd = [];

  void getChartData() async {
    Response res = await get(
        'https://api.covid19api.com/total/country/india/status/confirmed?from=2020-01-01T00:00:00Z&to=2020-06-07T00:00:00Z');

    data = jsonDecode(res.body);
    // print(data);

    setState(() {
      data = data;
      // print(data);
      loading = false;

      if (!loading) {
        for (Map day in data) {
          cd.add(ChartData(
              country: day['Country'], cases: day['Cases'], date: DateTime.parse(day['Date'])));
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('running');
    getChartData();
  }

  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series(
        id: 'Clicks',
        domainFn: (ChartData data, _) => data.date,
        measureFn: (ChartData data, _) => data.cases,
        // colorFn: (ClicksPerYear clickData, _) => clickData.color,
        data: cd,
        
      ),
    ];
    if (!loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('India')
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Text('Confirmed Cases'),
                  Container(
                    height: MediaQuery.of(context).size.height*0.6,
                    width: MediaQuery.of(context).size.height*0.6,
                    child: charts.TimeSeriesChart(series, animate: true),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[800],
                    ),
                  )

                ],
              ),
            ),
          ],
        )
      );
    } else {
      return Spinner();
    }
  }
}
