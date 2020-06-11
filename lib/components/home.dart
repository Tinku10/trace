import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'search.dart';
import 'loading.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class Global extends StatefulWidget {
  Global({Key key}) : super(key: key);

  @override
  _GlobalState createState() => _GlobalState();
}

class _GlobalState extends State<Global> {
  Map data = {};
  List totalData = [];
  Map globalData = {};
  Map country = {'country': 'Global', 'url': null};
  bool loading = true;
  Widget about;
  bool error = false;
  Icon cc = Icon(Icons.trending_up, color: Colors.orange[200]);
  Icon dc = Icon(Icons.trending_up, color: Colors.red[200]);
  Icon rc = Icon(Icons.trending_up, color: Colors.green[200]);
  Icon flat = Icon(Icons.trending_flat, color: Colors.grey[100]);
  // String image = 'https://covid19.mathdro.id/api/og';
  Icon cci;
  Icon dci;
  Icon rci;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGlobal();
  }

  void getGlobal() async {
    try {
      Response res = await get('https://api.covid19api.com/summary');
      data = jsonDecode(res.body);
      setState(() {
        loading = false;
        totalData = data['Countries'];
        data = data['Global'];
        globalData = data;
        if (data['NewConfirmed'] > 0) {
              cci = cc;
            } else {
              cci = flat;
            }
            if (data['NewDeaths'] > 0) {
              dci = dc;
            } else {
              dci = flat;
            }
            if (data['NewRecovered'] > 0) {
              rci = rc;
            } else {
              rci = flat;
            }
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    }
    // print(totalData);
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => Search()),
    );

    if (result == null) {
      print(country);
    }

    if (result != null) {
      setState(() {
        // if (result['country'] == 'Global') {
        //   image = 'https://covid19.mathdro.id/api/og';
        // } else {
        //   image = 'https://covid19.mathdro.id/api/countries/' +
        //       result['url'] +
        //       '/og';
        // }
        country = result;
      });
      // print(totalData);
      for (Map ele in totalData) {
        // print(ele['Slug']);
        if (ele['Slug'] == result['url']) {
          setState(() {
            // globalData = data;
            data = ele;
            if (data['NewConfirmed'] > 0) {
              cci = cc;
            } else {
              cci = flat;
            }
            if (data['NewDeaths'] > 0) {
              dci = dc;
            } else {
              dci = flat;
            }
            if (data['NewRecovered'] > 0) {
              rci = rc;
            } else {
              rci = flat;
            }
            print(data);
          });
          break;
        }
      }
    }

    print(result);
  }

  String numtoRead(dynamic number) {
    if (number == null) {
      return '0';
    }
    if (number >= 1000 && number < 1000000) {
      number = number / 1000.0;
      number = double.parse((number).toStringAsFixed(1));
      return number.toString() + 'K';
    } else if (number >= 1000000.0) {
      number = number / 1000000.0;
      number = double.parse((number).toStringAsFixed(1));
      return number.toString() + 'M';
    }
    return number.toString();
  }

  String numtoPercent(dynamic number) {
    return double.parse((number).toStringAsFixed(1)).toString();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (country['country'] == 'Global') {
        about = OutlineButton(
          disabledBorderColor: Colors.grey[800],
          highlightedBorderColor: Colors.grey[800],
          child: Icon(
            Icons.info_outline,
            color: Colors.grey[50],
          ),
          onPressed: () {
            showAboutDialog(
                context: context,
                applicationName: 'Trace',
                applicationIcon: Image.asset('assets/icon/icon.png'),
                applicationLegalese: 'An Open Source Project',
                children: [
                  SizedBox(height: 10),
                  Text(
                      'Trace relies on publicly available COVID-19 data. This app consumes an API designed by Kyle Redelinghuys.',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  SizedBox(height: 10),
                  Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    textAlign: TextAlign.center,
                    text:
                        "Contribute on Github https://www.github.com/Tinku10/trace",
                    style: TextStyle(color: Colors.grey[800]),
                    linkStyle: TextStyle(color: Colors.blue),
                  )
                ]);
          },
        );
      } else {
        about = OutlineButton(
          disabledBorderColor: Colors.grey[800],
          highlightedBorderColor: Colors.grey[800],
          child: Icon(
            Icons.language,
            color: Colors.grey[50],
          ),
          onPressed: () {
            setState(() {
              data = globalData;
              country = {'country': 'Global', 'url': null};
              if (data['NewConfirmed'] > 0) {
              cci = cc;
            } else {
              cci = flat;
            }
            if (data['NewDeaths'] > 0) {
              dci = dc;
            } else {
              dci = flat;
            }
            if (data['NewRecovered'] > 0) {
              rci = rc;
            } else {
              rci = flat;
            }
              // image = 'https://covid19.mathdro.id/api/og';
            });
          },
        );
      }
    });
    if (error) {
      return Scaffold(
          backgroundColor: Colors.grey[900],
          body: Center(
              child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Colors.grey[800],
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Server busy',
                            style: TextStyle(
                                color: Colors.grey[100], fontSize: 20)),
                        Text('Check back later',
                            style: TextStyle(
                                color: Colors.grey[100], fontSize: 20))
                      ]))));
    }
    if (loading) {
      return Spinner();
    } else {
      // if (data == null) {
      //   return Scaffold(
      //       appBar: AppBar(
      //         leading: about,
      //         title: Text('${country['country']}',
      //             style: TextStyle(
      //               color: Colors.grey[100],
      //               fontWeight: FontWeight.bold,
      //               fontSize: 20,
      //             )),
      //         centerTitle: true,
      //         backgroundColor: Colors.grey[800],
      //         elevation: 0,
      //       ),
      //       bottomNavigationBar: BottomNavigationBar(
      //           onTap: (index) {
      //             if (index == 1) {
      //               Navigator.pushNamed(context, '/graph', arguments: country);
      //             }
      //           },
      //           type: BottomNavigationBarType.fixed,
      //           currentIndex: 0,
      //           backgroundColor: Colors.grey[900],
      //           items: [
      //             BottomNavigationBarItem(
      //               icon: Icon(Icons.crop_landscape,
      //                   color: Colors.blue[100], size: 25),
      //               title: Text('Cards',
      //                   style:
      //                       TextStyle(color: Colors.blue[100], fontSize: 10)),
      //             ),
      //             BottomNavigationBarItem(
      //                 icon:
      //                     Icon(Icons.grain, color: Colors.grey[100], size: 25),
      //                 title: Text(
      //                   'Graph',
      //                   style: TextStyle(color: Colors.grey[100], fontSize: 10),
      //                 )),
      //           ]),
      //       body: Container(
      //           color: Colors.grey[900],
      //           child: Center(
      //               child: Container(
      //             margin: EdgeInsets.all(10),
      //             padding: EdgeInsets.all(10),
      //             decoration: BoxDecoration(
      //               color: Colors.grey[800],
      //               borderRadius: BorderRadius.circular(5),
      //             ),
      //             child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Text('No data available for this country right now',
      //                       textAlign: TextAlign.center,
      //                       style: TextStyle(
      //                         color: Colors.grey[100],
      //                         fontSize: 20,
      //                       )),
      //                   Text('Check back later',
      //                       style: TextStyle(
      //                           color: Colors.green[100],
      //                           fontSize: 30,
      //                           fontWeight: FontWeight.bold))
      //                 ]),
      //           ))));
      // } else {
      return Scaffold(
        appBar: AppBar(
          leading: about,
          title: Text('${country['country']}',
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
              if (index == 1) {
                Navigator.pushNamed(context, '/graph', arguments: country);
              }
            },
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            backgroundColor: Colors.grey[900],
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.crop_landscape,
                    color: Colors.blue[100], size: 25),
                title: Text('Cards',
                    style: TextStyle(color: Colors.blue[100], fontSize: 10)),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.grain, color: Colors.grey[100], size: 25),
                  title: Text(
                    'Graph',
                    style: TextStyle(color: Colors.grey[100], fontSize: 10),
                  )),
            ]),
        body: Container(
          color: Colors.grey[900],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                child: OutlineButton(
                  highlightedBorderColor: Colors.white,
                  disabledBorderColor: Colors.grey[100],
                  color: Colors.grey[100],
                  onPressed: () {
                    // print('presses');
                    // Navigator.pushNamed(context, '/search');
                    _navigateAndDisplaySelection(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.location_city, color: Colors.grey[100]),
                      SizedBox(width: 10),
                      Text(
                        'Select a Country',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[100]),
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                height: 60,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(20),
                      height: 150,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('New Confirmed Cases',
                              style: TextStyle(color: Colors.grey[50])),
                          SizedBox(width: 10),
                          Text(numtoRead(data['NewConfirmed']),
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[100]))
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // boxShadow: [
                        //   BoxShadow(color: Colors.grey[200], blurRadius: 10)
                        // ],
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(20),
                      height: 150,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('New Death Cases',
                              style: TextStyle(color: Colors.grey[50])),
                          SizedBox(width: 10),
                          Text(numtoRead(data['NewDeaths']),
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[100]))
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // boxShadow: [
                          //   BoxShadow(color: Colors.grey[200], blurRadius: 10)
                          // ],
                          color: Colors.grey[800]),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(20),
                      height: 150,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('New Recovered Cases',
                              style: TextStyle(color: Colors.grey[50])),
                          SizedBox(width: 10),
                          Text(numtoRead(data['NewRecovered']),
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[100]))
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // boxShadow: [
                          //   BoxShadow(color: Colors.grey[200], blurRadius: 10)
                          // ],
                          color: Colors.grey[800]),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(20),
                      height: 150,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Total Confirmed Cases',
                                  style: TextStyle(color: Colors.grey[50])),
                              SizedBox(width: 10),
                              Text(numtoRead(data['TotalConfirmed']),
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[100]))
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              cci,
                              Text('${data['NewConfirmed']}',
                                  style: TextStyle(color: Colors.grey[100]))
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // boxShadow: [
                          //   BoxShadow(color: Colors.grey[200], blurRadius: 10)
                          // ],
                          color: Colors.grey[800]),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(20),
                      height: 150,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Total Death Cases',
                                  style: TextStyle(color: Colors.grey[50])),
                              SizedBox(width: 10),
                              Text(numtoRead(data['TotalDeaths']),
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[100]))
                            ],
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              dci,
                              Text('${data['NewDeaths']}',
                                  style: TextStyle(color: Colors.grey[100]))
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // boxShadow: [
                          //   BoxShadow(color: Colors.grey[200], blurRadius: 10)
                          // ],
                          color: Colors.grey[800]),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(20),
                      height: 150,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Total Recovered Cases',
                                  style: TextStyle(color: Colors.grey[50])),
                              SizedBox(width: 10),
                              Text(numtoRead(data['TotalRecovered']),
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[100]))
                            ],
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              rci,
                              Text('${data['NewRecovered']}',
                                  style: TextStyle(color: Colors.grey[100]))
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // boxShadow: [
                          //   BoxShadow(color: Colors.grey[200], blurRadius: 10)
                          // ],
                          color: Colors.grey[800]),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(20),
                      height: 150,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Mortality Rate',
                              style: TextStyle(color: Colors.grey[900])),
                          SizedBox(width: 10),
                          Text(
                              numtoPercent(data['TotalDeaths'] *
                                      100 /
                                      data['TotalConfirmed']) +
                                  '%',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900]))
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // boxShadow: [
                          //   BoxShadow(color: Colors.grey[200], blurRadius: 10)
                          // ],
                          color: Colors.red[100]),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(20),
                      height: 150,
                      width: double.infinity / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Survival Rate',
                              style: TextStyle(color: Colors.grey[900])),
                          SizedBox(width: 10),
                          Text(
                              numtoPercent(data['TotalRecovered'] *
                                      100 /
                                      data['TotalConfirmed']) +
                                  '%',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900]))
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // boxShadow: [
                          //   BoxShadow(color: Colors.grey[200], blurRadius: 10)
                          // ],
                          color: Colors.green[100]),
                    ),
                    // SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      // }
    }
  }
}
