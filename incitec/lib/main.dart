
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
//import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:incitec/Constants/colors.dart';
import 'package:incitec/Views/listado_reportes_view.dart';
import 'package:incitec/Views/login_view.dart';
import 'package:incitec/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Ocultamos la barra de navegacion y la barra de status
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Palette.letras,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Palette.blueTec,
        useMaterial3: false,
      ),
      // home: const ReportesPage(cat: 'Energía Eléctrica', path:  'assets/energia.jpg')
      home: const LoginPage()
      // home: const Prueba()
      //  home: const CategoriasPage(),
      //home: const Graphics(),
      // home: const GraficosPage(),
      // home: const SubirReporte(),
    );
  }
}