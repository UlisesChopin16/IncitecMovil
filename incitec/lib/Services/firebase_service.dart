import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:incitec/Views/subir_reporte_view.dart';

class FirebaseServicesInciTec extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  FirebaseAuth auth = FirebaseAuth.instance;


  var datosAlumno = <String,dynamic>{}.obs;
  var datosCarrera = <String,dynamic>{}.obs;

  var loading = false.obs;
  var verificarTelefono = false.obs;

  var usuario = ''.obs;
  var nombre = ''.obs;
  var iniciales = ''.obs;
  var email = ''.obs;
  var mensajeError = ''.obs;
  var carrera = ''.obs;
  var periodo = ''.obs;
  var periodoIngreso = ''.obs;
  var telefono = ''.obs;

  User? user;

  snackBarSucces({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      )
    );
  }

  snackBarError({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      )
    );
  }

  Future<bool> agregarReporte({
    required String fecha,
    required String descripcion,
    required String ubicacion,
    required String estado,
    required String imagen,
    required String categoria,
    required String nombreCompleto,
    required String numeroControl,
    required String carrera,
    required String incidencia
  }) async{
    try {
      loading.value = true;
      await firestore.collection('reportes').doc(fecha).set({
        "incidencia": incidencia,
        "descripcion": descripcion,
        "fecha": fecha,
        "ubicacion": ubicacion,
        "estado": estado,
        "imagen": imagen,
        "categoria": categoria,
        "nombreCompleto": nombreCompleto,
        "numeroControl": numeroControl,
        "carrera": carrera,
      });
      loading.value = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> subirImagen(File imagen,String nombre,BuildContext context) async {

    loading.value = true;

    final Reference ref = storage.ref().child('reportes').child(nombre);
    final UploadTask uploadTask = ref.putFile(imagen);
    Future.delayed(const Duration(seconds: 20)).then((value) {
      if(loading.value){
        if(!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subiendo Reporte...')));
      }
    });
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => true);

    if(taskSnapshot.state == TaskState.success){
      final String url = await taskSnapshot.ref.getDownloadURL();
      loading.value = false;
      return url;
    }else{
      loading.value = false;
      return 'false';
    }

  }

  Future<void> loginUsingEmailPassword({required String numeroControl, required String password, required BuildContext context}) async{
    loading.value = true;
    try{
      String email = '$numeroControl@tecnamex.com';
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      if(user != null){
        usuario.value = numeroControl;
        loading.value = false;
        if(!context.mounted) return;
        snackBarSucces(message: 'Bienvenido', context: context);
        // Si el largo del numero de control esta entre 8 y 9 entonces es un alumno
        if(numeroControl.length >= 8 && numeroControl.length <= 9){
          await obtenerDatosAlumno(numeroControl: numeroControl, context: context);
          if(!context.mounted) return;
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SubirReporte()));
        }else{
          
        }

      }else{
        loading.value = false;
        if(!context.mounted) return;
        snackBarError(message: 'Error al iniciar sesión', context: context);
      }
    }catch(e){
      loading.value = false;
      if(!context.mounted) return;
      snackBarError(message: 'Algo salio mal, por favor intente de nuevo más tarde', context: context);
    }
  }

  Future<void> obtenerDatosAlumno({required String numeroControl, required BuildContext context}) async{
    String collection = '/itz/tecnamex/';
    loading.value = true;
    try{
      collection += 'estudiantes';
      DocumentSnapshot ds = await firestore.collection(collection).doc(numeroControl).get();
      datosAlumno.value = ds.data() as Map<String, dynamic>;
      obtenerPeriodoEscolar();
      obtenerNumero();
      obtenerIniciales();
      obtenerCorreoElectronico();
      if(!context.mounted) return;
      await obtenerCarrera(collection: 'planes', id: datosAlumno['clavePlanEstudios'].toString(),context: context);
      nombre.value = datosAlumno['apellidosNombre'];
      loading.value = false;
    }catch(e){
      loading.value = false;
    }
  }

  // Metodo para obtener un documento a partir de su identificador
  Future<void> obtenerCarrera({required String collection, required String id,required BuildContext context}) async {
    try {
      loading.value = true;
      String coleccionCompleta = '/itz/tecnamex/$collection';
      DocumentSnapshot document = await firestore.collection(coleccionCompleta).doc(id).get();
      datosCarrera.value = document.data() as Map<String, dynamic>;
      acortarNombreCarrera();
    } catch (e) {
      mensajeError.value = 'Algo salio mal, porfavor intente de nuevo más tarde';
      if(!context.mounted) return;
      snackBarError(message: mensajeError.value, context: context);
      loading.value = false;
    }
  }

  // metodo para obtener el periodo actual
  // 20223 significa que el periodo escolar se comprende desde Ago - Dic 2022
  // 20222 significa que el periodo escolar se comprende desde Verano 2022
  // 20221 significa que el periodo escolar se comprende desde Ene - Jun 2022
  // en el arreglo esta un campo llamado periodoIngreso donde se encuentra este dato
  obtenerPeriodoEscolar(){
    periodoIngreso.value = datosAlumno['periodoIngreso'].toString();
    String periodoYear = datosAlumno['periodoIngreso'].toString().substring(0, 4);
    String periodoMes = datosAlumno['periodoIngreso'].toString().substring(4, 5);
    if(periodoMes == '1'){
      periodo.value = 'ENE - JUN $periodoYear';
    }else if(periodoMes == '2'){
      periodo.value = 'VERANO $periodoYear';
    }else if(periodoMes == '3'){
      periodo.value = 'AGO - DIC $periodoYear';
    }
  }

  obtenerNumero(){
    // sacar la penultima posicion del arreglo;
    telefono.value = datosAlumno['celular'].toString();
    if(telefono.value.isEmpty){
      verificarTelefono.value = true;
    }else{
      verificarTelefono.value = false;
    }
  }


  // Metodo para cambiar nombre carrera por ejemplo:
  // Ingeniería en Sistemas Computacionales
  // Ing. en Sistemas Computacionales
  acortarNombreCarrera(){
    carrera.value = '';
    String nombreCarrera = datosCarrera['nombre'].toString();
    List<String> nombreCarreraSeparado = nombreCarrera.split(' ');
    for(int i = 0; i < nombreCarreraSeparado.length; i++){
      if(i == 0){
        nombreCarreraSeparado[i] = 'ING.';
      }
      carrera.value +=  '${nombreCarreraSeparado[i]} ';
    }
  }


  // metodo para obtener la primera letra del nombre y la primera letra del apellido paterno
  // el nombre completo empieza por apellidos ej: Sotelo Chopin Ulises Shie
  obtenerIniciales(){
    String nombreCompleto = datosAlumno['apellidosNombre'].toString();
    List<String> nombreCompletoSeparado = nombreCompleto.split(' ');

    // Inicial del apellido paterno
    String letraA = nombreCompletoSeparado[0].substring(0, 1);
    // Inicial del nombre
    String letraB = nombreCompletoSeparado[(nombreCompletoSeparado.length - 2)].substring(0, 1);
    // Iniciales completas ej: US
    iniciales.value = letraB + letraA;
  }

  // metodo para obtener el correo electronico a partir del numero de control
  // el correo debe ser así L19091435@zacatepec.tecnm.mx o bien LC18090562@zacatepec.tecnm.mx
  obtenerCorreoElectronico(){
    String numeroControl = usuario.value.toUpperCase();
    email.value = 'L$numeroControl@zacatepec.tecnm.mx';
  }
}


