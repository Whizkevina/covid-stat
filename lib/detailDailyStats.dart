import 'package:flutter/material.dart';
import 'package:covid_stat/main.dart';

class DetailDailyStats extends StatelessWidget {
  final DailyData dailyData;
  DetailDailyStats({Key key, @required this.dailyData}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Covid19 stats for " + dailyData.date)
      ),
      body: Center(child: Text(dailyData.confirmed.toString()),),
    );
  }

  
  Widget _buildRow(BuildContext context, DailyData dailyData) {
    return ListTile(
      title: Text(
        dailyData.date,
        style: _biggerFont,
      ),
      trailing: Text(
        dailyData.confirmed.toString(),
        style: _biggerFont,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailDailyStats(dailyData: dailyData)),
        );
      },
    );
  }

}