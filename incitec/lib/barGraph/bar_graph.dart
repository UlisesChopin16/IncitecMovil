import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:incitec/barGraph/bar_data.dart';

class MyBarGraph extends StatelessWidget{
  final List edRep;
  const MyBarGraph({
    super.key, 
    required this.edRep
  });

  @override
  Widget build(BuildContext context){
    BarData myBarData = BarData(
      por1: edRep[0], 
      por2: edRep[1], 
      por3: edRep[2], 
      por4: edRep[3],
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true, 
                getTitlesWidget: getBottomTitles,
              ),
            ),
          ),
        barGroups: myBarData.barData
        .map((data) {
            List<Color> colors = [
              Color.fromRGBO(45, 48, 145, 1),
              Color.fromRGBO(51, 55, 156, 1),
              Color.fromRGBO(19, 26, 218, 1),
              Color.fromRGBO(115, 119, 241, 1)
            ];
            return BarChartGroupData(
              x: data.x,
              barRods: [
                BarChartRodData(
                  toY: data.y,
                  color: colors[data.x],
                  width: 25,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 100,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            );
          } 
        )
        .toList(),
      ),
    );
  }
  Widget getBottomTitles (double value, TitleMeta meta,){
    const Style = TextStyle(
      color: Colors.grey, 
      fontWeight: FontWeight.bold, 
      fontSize: 14,
    );

    Widget text;
    switch(value.toInt()){
      case 0: 
        text = Text('A ${edRep[0]}%', style: Style);
        break;
      case 1: 
        text = Text('E ${edRep[1]}%', style: Style);
        break;
      case 2: 
        text = Text('D ${edRep[2]}%', style: Style);
        break;
      case 3: 
        text = Text('O ${edRep[3]}%', style: Style);
        break;
      default:
        text = const Text('', style: Style);
        break;
    }
    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }
} 

