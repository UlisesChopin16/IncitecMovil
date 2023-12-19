import 'package:flutter/material.dart';
import 'package:incitec/barGraph/bar_graph.dart';

class Graphics extends StatefulWidget{
  const Graphics({super.key});

  @override
  State<Graphics> createState() => _GraphicsState();
}

class _GraphicsState extends State<Graphics>{
  // edRep = variable edificioReporte
  List <double> edRep = [
    21.60,
    13.15,
    47.93,
    17.32,
  ];
  
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center (
        child: SizedBox(
          height: 200,
        child: MyBarGraph(
          edRep: edRep,
        ),
        ),
      ),  
    );
  }
}