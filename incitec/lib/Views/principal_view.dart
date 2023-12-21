import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incitec/Constants/colors.dart';
import 'package:incitec/Views/graficos_view.dart';
import 'package:incitec/Views/lista_reportes_view.dart';
import 'package:incitec/Views/subir_reporte_view.dart';
import 'package:incitec/Views/login_view.dart';
import 'package:incitec/Services/firebase_service.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({Key? key,}) : super(key: key);
  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {

  final servicios = Get.put(FirebaseServicesInciTec());

  double w = 0;

  resolucion() {
    setState(() {
      w = MediaQuery.of(context).size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    resolucion();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            partePerfil(
              nombre: servicios.nombre.value,
              email: servicios.email.value,
              iniciales: servicios.iniciales.value,
            ),
            ListTile(
              title: const Text('Subir reporte'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SubirReporte(retroceder: true,)));
              },
            ),
            ListTile(
              title: const Text('Estadisticas'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const GraficosPage())
                );
              },
            ),
            ListTile(
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SizedBox(
          width: w > 500 ? 500 : w,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20.0,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          categoriaApartado(nombre: 'Agua', nombreImagen: 'fuga'),
                          categoriaApartado(nombre: 'Energía Eléctrica', nombreImagen: 'energia'),
                          categoriaApartado(nombre: 'Desechos Peligrosos', nombreImagen: 'desechosPeligrosos'),
                          categoriaApartado(nombre: 'Otros', nombreImagen: 'desechos'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
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

  categoriaApartado({
    required String nombre, required String nombreImagen
  }){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Image.asset('assets/$nombreImagen.jpg',
            width: 100,
            height: 130,
            fit: BoxFit.fill,
          ),
          contentPadding: const EdgeInsets.all(0.0),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportesPage(cat: nombre,path: 'assets/$nombreImagen.jpg',)));
          },
        ),
        Text(nombre,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 20.0,),
      ],
    );
  }
}