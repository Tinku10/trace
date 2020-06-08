import 'package:syncfusion_flutter_charts/charts.dart';
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
  Map country;
  bool isDataAvailable = true;
  // bool ready = false;

  void getChartData() async {
    DateTime current = DateTime.now();
    Response res = await get('https://api.covid19api.com/country/' +
        country['url'] +
        '?from=2020-03-01T00:00:00Z&to=' +
        current.toString());
    // print('api accessed');
    data = jsonDecode(res.body);
    // print(data);

    setState(() {
      // data = data;
      // print(data);
      if (data.length == 0) {
        isDataAvailable = false;
      }
      loading = false;
      if (!loading) {
        for (Map day in data) {
          cd.add(ChartData(
              country: day['Country'],
              active: day['Active'],
              recovered: day['Recovered'],
              deaths: day['Deaths'],
              date: DateTime.parse(day['Date']))); //DateTime.parse(date)
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('running');
  }

  @override
  Widget build(BuildContext context) {
    country = ModalRoute.of(context).settings.arguments;
    // print(country);
    // ready = true;
    getChartData();
    // var series = [
    //   charts.Series(
    //     id: 'Clicks',
    //     domainFn: (ChartData data, _) => data.date,
    //     measureFn: (ChartData data, _) => data.active,
    //     // colorFn: (ClicksPerYear clickData, _) => clickData.color,
    //     data: cd,

    //   ),
    // ];
    if (!isDataAvailable) {
      return Scaffold(
          appBar: AppBar(
            title: Text(country['country'],
                style: TextStyle(
                  color: Colors.grey[100],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
            centerTitle: true,
            backgroundColor: Colors.grey[800],
            elevation: 0,
          ),
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                if (index == 0) {
                  Navigator.pop(context);
                }
              },
              type: BottomNavigationBarType.fixed,
              currentIndex: 1,
              backgroundColor: Colors.grey[900],
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.crop_landscape,
                      color: Colors.grey[100], size: 25),
                  title: Text('Cards',
                      style: TextStyle(color: Colors.grey[100], fontSize: 10)),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.grain, color: Colors.blue[100], size: 25),
                    title: Text(
                      'Graph',
                      style: TextStyle(color: Colors.blue[100], fontSize: 10),
                    )),
              ]),
          body: Container(
            color: Colors.grey[900],
            child: Center(
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  color: Colors.grey[800],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
              Text('Insufficient data for plotting',
                    style: TextStyle(color: Colors.grey[100], fontSize: 20)),
              Text('Check Cards instead',
                    style: TextStyle(
                        color: Colors.green[100],
                        fontSize: 30,
                        fontWeight: FontWeight.bold))
            ]),
                )),
          ));
    }
    else{
        if (!loading) {
          return Scaffold(
              appBar: AppBar(
                title: Text(country['country'],
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                centerTitle: true,
                backgroundColor: Colors.grey[800],
                elevation: 0,
              ),
              bottomNavigationBar: BottomNavigationBar(
                  onTap: (index) {
                    if (index == 0) {
                      Navigator.pop(context);
                    }
                  },
                  type: BottomNavigationBarType.fixed,
                  currentIndex: 1,
                  backgroundColor: Colors.grey[900],
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.crop_landscape,
                          color: Colors.grey[100], size: 25),
                      title: Text('Cards',
                          style: TextStyle(color: Colors.grey[100], fontSize: 10)),
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.grain, color: Colors.blue[100], size: 25),
                        title: Text(
                          'Graph',
                          style: TextStyle(color: Colors.blue[100], fontSize: 10),
                        )),
                  ]),
              body: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  // width: MediaQuery.of(context).size.width,
                  color: Colors.grey[900],
                  child: SfCartesianChart(
                    margin: EdgeInsets.all(15),
                    plotAreaBackgroundColor: Colors.grey[800],

                    backgroundColor: Colors.grey[800],
                    // title: ChartTitle(text: 'Confirmed active', textStyle: TextStyle(color: Colors.grey[100])),
                    primaryXAxis: DateTimeAxis(
                        labelStyle: ChartTextStyle(
                          color: Colors.grey[400],
                        ),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        majorGridLines: MajorGridLines(
                          width: 1,
                          color: Colors.grey[700],
                        ),
                        maximumLabels: 5
                        // labelIntersectAction: AxisLabelIntersectAction.hide
                        ),
                    primaryYAxis: NumericAxis(
                        labelStyle: ChartTextStyle(
                          color: Colors.grey[400],
                        ),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        majorGridLines: MajorGridLines(
                          width: 1,
                          color: Colors.grey[700],
                        ),
                        maximumLabels: 1),
                    legend: Legend(
                        isVisible: true,
                        textStyle: ChartTextStyle(color: Colors.grey[400])),
                    series: <ChartSeries<ChartData, DateTime>>[
                      SplineAreaSeries<ChartData, DateTime>(
                          color: Colors.orange[200],
                          enableTooltip: true,
                          dataSource: cd,
                          xValueMapper: (ChartData data, _) => data.date,
                          yValueMapper: (ChartData data, _) => data.active,
                          name: 'Active',
                          markerSettings: MarkerSettings(color: Colors.grey[700])
                          // dataLabelSettings: DataLabelSettings(isVisible: true)
                          ),
                      SplineAreaSeries<ChartData, DateTime>(
                          color: Colors.lightGreen[200],
                          enableTooltip: true,
                          dataSource: cd,
                          xValueMapper: (ChartData data, _) => data.date,
                          yValueMapper: (ChartData data, _) => data.recovered,
                          name: 'Recovered'
                          // dataLabelSettings: DataLabelSettings(isVisible: true)
                          ),
                      SplineAreaSeries<ChartData, DateTime>(
                          color: Colors.red[200],
                          enableTooltip: true,
                          dataSource: cd,
                          xValueMapper: (ChartData data, _) => data.date,
                          yValueMapper: (ChartData data, _) => data.deaths,
                          name: 'Deaths'
                          // dataLabelSettings: DataLabelSettings(isVisible: true)
                          )
                    ],
                  )));
        } else {
          return Spinner();
        }
      }
    }

    }

// Container(
//           color: Colors.grey[900],
//           child: Center(
//             child: Column(
//               children: <Widget>[
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text('Confirmed active'),
//                     Container(
//                       height: MediaQuery.of(context).size.height*0.6,
//                       width: MediaQuery.of(context).size.height*0.6,
//                       child: charts.BarChart(series, animate: true),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: Colors.grey[800],
//                       ),
//                     )

//                   ],
//                 ),
//               ],
//             ),
//           ),
//         )
