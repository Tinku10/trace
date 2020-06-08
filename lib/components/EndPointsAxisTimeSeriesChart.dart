// /// Example of a time series chart with an end points domain axis.
// ///
// /// An end points axis generates two ticks, one at each end of the axis range.
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:flutter/material.dart';
// import '../data/chartData.dart';

// class EndPointsAxisTimeSeriesChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;

//   EndPointsAxisTimeSeriesChart(this.seriesList, {this.animate});

//   /// Creates a [TimeSeriesChart] with sample data and no transition.
//   factory EndPointsAxisTimeSeriesChart.withSampleData() {
//     return new EndPointsAxisTimeSeriesChart(
//       _createSampleData(),
//       // Disable animations for image tests.
//       animate: false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new charts.TimeSeriesChart(
//       seriesList,
//       animate: animate,
//       // Configures an axis spec that is configured to render one tick at each
//       // end of the axis range, anchored "inside" the axis. The start tick label
//       // will be left-aligned with its tick mark, and the end tick label will be
//       // right-aligned with its tick mark.
//       domainAxis: new charts.EndPointsTimeAxisSpec(),
//     );
//   }

//   /// Create one series with sample hard coded data.
//   static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
//     final data = [
//       new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
//       new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
//       new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
//       new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
//     ];

//     return [
//       new charts.Series<ChartData, DateTime>(
//         id: 'Sales',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//         domainFn: (ChartData data, _) => data.cases,
//         measureFn: (ChartData data, _) => data.day,
//         data: data,
//       )
//     ];
//   }
// }

// /// Sample time series data type.
// class TimeSeriesSales {
//   final DateTime time;
//   final int cases;

//   TimeSeriesSales(this.day, this.cases);
// }
