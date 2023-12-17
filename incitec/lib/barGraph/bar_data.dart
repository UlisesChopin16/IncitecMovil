

import 'package:incitec/barGraph/individual_bar.dart';

class BarData{
  final double por1;
  final double por2;
  final double por3;
  final double por4;

  BarData({
    required this.por1,
    required this.por2,
    required this.por3,
    required this.por4,
  });

  List<IndividualBar> barData = [];

  void initializeBarData(){
    barData = [
      IndividualBar(x: 0, y: por1),
      IndividualBar(x: 1, y: por2),
      IndividualBar(x: 2, y: por3),
      IndividualBar(x: 3, y: por4),
    ];
  }
}