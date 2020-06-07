import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:country_icons/country_icons.dart';
import '../data/countries.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String typed = '';

  List<Map> filter(String search) {
    if (search == '') {
      return countries;
    } else {
      List<Map> filtered = [];
      for (Map country in countries) {
        if (country['Country'].toLowerCase().contains(search)) {
          filtered.add(country);
        }
      }
      return filtered;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
              onChanged: (context) {
                print(context);
                setState(() {
                  typed = context;
                });
              },
              style: TextStyle(color: Colors.grey[100]),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelText: 'Search',
                  hintText: 'Country Name',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  labelStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[100],
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[100]))),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
        ),
        body: Container(
          //color: Colors.grey[900],
          child: ListView.builder(
            itemCount: filter(typed).length,
            itemBuilder: (context, index) => OutlineButton(
              disabledBorderColor: Colors.grey[50],
              color: Colors.grey[50],
              focusColor: Colors.grey[50],
              highlightedBorderColor: Colors.grey[100],
              onPressed: () {
                Map rs = {
                  'country': filter(typed)[index]['Country'],
                  'url': filter(typed)[index]['Slug']
                };
                Navigator.pop(
                  context, rs
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                        backgroundImage: AssetImage(
                            'icons/flags/png/' +
                                '${filter(typed)[index]['ISO2'].toLowerCase()}' +
                                '.png',
                            package: 'country_icons'),
                        radius: 30,
                        backgroundColor: Colors.grey[800]),
                    SizedBox(width: 20),
                    Flexible(
                      child: Text('${filter(typed)[index]['Country']}',
                          style: TextStyle(color: Colors.grey[900], fontSize: 14)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
