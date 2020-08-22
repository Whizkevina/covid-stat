import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:covid_stat/detailDailyStats.dart';



void main() => runApp(CovidData());

Future<CovidStatsData> fetchData() async {
  final response = await http.get('https://pomber.github.io/covid19/timeseries.json');
  if (response.statusCode == 200) {
    return CovidStatsData.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load covid stats');
  }
}

class DailyData {
  final String date;
  final int confirmed;
  final int deaths;
  final int recovered;
  DailyData({this.date, this.confirmed, this.deaths, this.recovered});
}

class CovidStatsData {
  final List<DailyData> nepal;
  CovidStatsData({this.nepal});
  factory CovidStatsData.fromJson(Map<String, dynamic> json) {
    List<DailyData> nepal = json['Nepal'].map<DailyData>( (data) {
      return DailyData(
        date: data["date"],
        confirmed: data["confirmed"],
        deaths: data["deaths"],
        recovered: data["recovered"]
      );
    }).toList();
    return CovidStatsData(
      nepal: nepal,
      );
  }
}


class CovidDataState extends State<CovidData> {
  Future<CovidStatsData> futureData;
  @override
void initState() {
  super.initState();
  futureData = fetchData();
}

final _Font = const TextStyle(fontSize: 18.0);
Widget _buildRow(DailyData dailyData) {
  return ListTile(
    title: Text(
      dailyData.date,
      style: _Font,
    ),
    trailing: Text(
      dailyData.confirmed.toString(),
      style: _Font,
    )
  );
}


  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Column(
          children: [
            Image(
              image: AssetImage('images/covid-stat-img.jpg'),
              fit: BoxFit.cover,
              height: 340,
            ),
          
          FutureBuilder<CovidStatsData> (
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 219,
                  child: (
                  ListView.builder(
                  itemCount: snapshot.data.nepal.length,
                  itemBuilder: (context, index) {
                    DailyData dailyData = snapshot.data.nepal[index];
                    return _buildRow(dailyData);
                    },
                  )
                )  
              );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ],
        ),
      )
    );
  }
}

class CovidData extends StatefulWidget{
@override
  CovidDataState createState() => CovidDataState();
}
