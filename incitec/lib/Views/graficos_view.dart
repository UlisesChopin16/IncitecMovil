import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incitec/Constants/colors.dart';
import 'package:incitec/Services/firebase_service.dart';
import 'package:incitec/Views/login_view.dart';
import 'package:incitec/barGraph/bar_graph.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

class GraficosPage extends StatefulWidget {
  const GraficosPage({Key? key}) : super(key: key);

  @override
  _GraficosPageState createState() => _GraficosPageState();
}

class _GraficosPageState extends State<GraficosPage> {

  final servicios = Get.put(FirebaseServicesInciTec());

  

  List<Color> colors = const [
    Color.fromRGBO(119, 121, 177, 1),
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
  List<String> listaEdificios = [
    'Edificio 1',
    'Edificio 2',
    'Edificio 3',
    'Edificio 4',
    'Edificio 5',
    'Edificio 6',
    'Edificio 7',
    'Edificio 8',
    'Edificio 9',
    'Edificio 10',
  ];

  String titulo = 'Edificio 1';
  String edificio = '';


  @override
  void initState() {
    super.initState();
    servicios.getReportesEdificio(edificio: 'Edificio 1');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(
        appBar: AppBar(
          title: Text(titulo),
        ),
        drawer: drawerGraphics(),
        backgroundColor: Colors.grey[300],
        body: Center(
          child: !servicios.loading.value ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              Text('Total de reportes: ${servicios.getDataReportes.value.reportes.length.toString()}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ), 
              const SizedBox(height: 10,),
              SizedBox(
                height: 320,
                child: MyBarGraph(
                  edRep: servicios.listaPorcentajes,
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
          ) : const CircularProgressIndicator(),
        ),  
      ),
    );
  }

  drawerGraphics(){
    return Drawer(
      child: ListView(
        children: [
          partePerfil(
            nombre: servicios.nombre.value,
            email: servicios.email.value,
            iniciales: servicios.iniciales.value,
          ),
          ListTile(
            title: const Text('Volver a inicio'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          for(int i = 0; i < listaEdificios.length; i++)
          ListTile(
            title: Text(listaEdificios[i]),
            onTap: () {
              setState(() {
                titulo = listaEdificios[i];
                edificio = listaEdificios[i];
              });
              servicios.getReportesEdificio(edificio: edificio);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Cerrar sesión'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }

  partePerfil({
    required String nombre, 
    required String email,
    required String iniciales
  }){
    return SizedBox(
      height: 250,
      child: UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Palette.letras
        ),
        accountName: Text(nombre,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        accountEmail: Text(email,
          style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
        ),
        currentAccountPictureSize: const Size(150, 150),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(iniciales,
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ),
      ),
    );
  }
  
}