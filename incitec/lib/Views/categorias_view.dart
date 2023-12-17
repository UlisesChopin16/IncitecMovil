import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incitec/Services/firebase_service.dart';
import 'package:incitec/Views/graficos_view.dart';
import 'package:incitec/Views/listado_reportes_view.dart';
import 'package:incitec/Views/login_view.dart';

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
    return Obx(
      ()=> Scaffold(
        appBar: AppBar(
          title: const Text('Categorias'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              partePerfil(
                nombre: servicios.usuario.value,
                email: servicios.email.value,
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
            width: w > 800 ? 800 : w,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Buscar',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)
                      )
                    ),
                
                  ),
                ),
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
      ),
    );
  }

  partePerfil({
    required String nombre, 
    required String email,
  }){
    return SizedBox(
      height: 250,
      child: UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue[800]
        ),
        accountName: Text(nombre,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        accountEmail: Text(email,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
        ),
        currentAccountPictureSize: const Size(150, 150),
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
            height: 160,
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