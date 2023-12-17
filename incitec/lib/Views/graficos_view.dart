import 'package:flutter/material.dart';
import 'package:incitec/Views/login_view.dart';
import 'package:incitec/barGraph/bar_graph.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

class GraficosPage extends StatefulWidget {
  const GraficosPage({Key? key}) : super(key: key);

  @override
  _GraficosPageState createState() => _GraficosPageState();
}

class _GraficosPageState extends State<GraficosPage> {

  // final getDataController = Get.put(GetDataController());

  double numero1 = 0;
  double numero2 = 0;
  double numero3 = 0;
  double numero4 = 0;

  

  List<Color> colors = [
    Color.fromRGBO(45, 48, 145, 1),
    Color.fromRGBO(51, 55, 156, 1),
    Color.fromRGBO(19, 26, 218, 1),
    Color.fromRGBO(115, 119, 241, 1)
  ];     
  List<String> categorias = [
    "Agua",
    "Electricidad",
    "Desechos Peligrosos",
    "Otros"
  ];         
  List <double> edRep = [
    21.60,
    13.15,
    47.93,
    17.32,
  ];                 
  List <double> edRep1 = [
    41.60,
    03.15,
    27.93,
    23.32,
  ];  
    List <double> edRep2 = [
    31.60,
    3.15,
    27.93,
    87.32,
  ];
    List <double> edRep3 = [
    1.60,
    33.15,
    14.93,
    18.62,
  ];
    List <double> edRep4 = [
    31.60,
    3.15,
    22.93,
    57.32,
  ];
    List <double> edRep5 = [
    21.60,
    13.15,
    47.93,
    17.32,
  ];
    List <double> edRep6 = [
    11.60,
    16.12,
    20.93,
    13.32,
  ];
  String titulo = 'Edificio 2';
  String edificio = '';

  int opcion = 0;

  @override
  void initState() {

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await getDataController.getDataAires();
    //       numero1 = metodoPorcentaje(0);
    //       numero2 = metodoPorcentaje(1);
    //       numero3 = metodoPorcentaje(2);
    //       numero4 = metodoPorcentaje(3);
    // });

    super.initState();

  }

  opcionsSelected(){
    switch(opcion){
      case 0:
        return edRep;
      case 1:
        return edRep1;
      case 2:
        return edRep2;
      case 3:
        return edRep3;
      case 4:
        return edRep4;
      case 5:
        return edRep5;
      case 6:
        return edRep6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          title: Text(titulo),
        ),
        drawer: drawerGraphics(),
        backgroundColor: Colors.grey[300],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: MyBarGraph(
                edRep: opcionsSelected(),
              ),
            ),
            SizedBox(height: 30,),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for(int i = 0; i < colors.length; i++)
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors[i],
                          ),
                        ),
                        const SizedBox(width: 14,),
                        Text(categorias[i],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  )
                ]
              )
            )
          ],
        ),  
      );
  }

  

  drawerGraphics(){
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
              height: 250,
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue[800]
                ),
                accountName: const Text('Margarita Sotelo',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                ),
                accountEmail: const Text('17091037@zacatepec.tecnm.mx',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                ),
                currentAccountPictureSize: Size(150, 150),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text('MS',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ),
              ),
            ),
          ListTile(
            title: Text('Edificio 2'),
            onTap: () {
              setState(() {
                titulo = 'edificio 2';
                opcion = 0;
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Edificio 4'),
            onTap: () {
              setState(() {
                titulo = 'edificio 4';
                opcion = 1;
              });
              Navigator.of(context).pop();      
            },
          ),
          ListTile(
            title: Text('Edificio 5'),
            onTap: () {
              setState(() {
                titulo = 'edificio 5';
                opcion = 2;
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Edificio 6'),
            onTap: () {
              setState(() {
                titulo = 'edificio 6';
                opcion = 3;
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Edificio 8'),
            onTap: () {
              setState(() {
                titulo = 'edificio 8';
                opcion = 4;
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Edificio 9'),
            onTap: () {
              setState(() {
                titulo = 'edificio 9';
                opcion = 5;
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Edificio 10'),
            onTap: () {
              setState(() {
                titulo = 'edificio 10';
                opcion = 6;
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Cerrar Sesión'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}