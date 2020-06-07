import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'search.dart';
import 'loading.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGlobal();
  }

  void getGlobal() async {
    Response res = await get('https://api.covid19api.com/summary');
    data = jsonDecode(res.body);
    setState(() {
      loading = false;
      totalData = data['Countries'];
      data = data['Global'];
      globalData = data;
    });
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
        country = result;
      });
      for (Map ele in totalData) {
        if (ele['Slug'] == result['url']) {
          setState(() {
            // globalData = data;
            data = ele;
          });
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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Spinner();
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: OutlineButton(
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
              });
            },
          ),
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
        bottomNavigationBar:
            BottomNavigationBar(backgroundColor: Colors.grey[900], items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.crop_landscape, color: Colors.grey[100], size: 20),
              title: Text('Cards',
                  style: TextStyle(color: Colors.grey[100], fontSize: 15)),
              backgroundColor: Colors.grey[800]),
          BottomNavigationBarItem(
              icon: Icon(Icons.grain, color: Colors.grey[100], size: 20),
              title: Text('Graph',
                  style: TextStyle(color: Colors.grey[100], fontSize: 15))),
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
                      child: Column(
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // boxShadow: [
                          //   BoxShadow(color: Colors.grey[200], blurRadius: 10)
                          // ],
                          color: Colors.grey[800]),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
