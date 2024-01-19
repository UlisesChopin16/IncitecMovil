import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:incitec/Models/reportes_model.dart';
import 'package:incitec/Views/principal_view.dart';
import 'package:incitec/Views/subir_reporte_view.dart';

class FirebaseServicesInciTec extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  FirebaseAuth auth = FirebaseAuth.instance;


  var datosUsuario = <String,dynamic>{}.obs;
  var datosCarrera = <String,dynamic>{}.obs;

  var listaPorcentajes = <double>[].obs;

  var pdf = Uint8List(0).obs;

  var getDataReportes = GetDataModelReportes(reportes: []).obs;

  var loading = false.obs;
  var verificarTelefono = false.obs;
  var activo = false.obs;
  var estudiante = false.obs;
  var administrativoR = false.obs;
  var jefeR = false.obs;
  var empleado = false.obs;

  var usuario = ''.obs;
  var nombre = ''.obs;
  var iniciales = ''.obs;
  var email = ''.obs;
  var mensajeError = ''.obs;
  var carrera = ''.obs;
  var periodo = ''.obs;
  var periodoIngreso = ''.obs;
  var telefono = ''.obs;
  var estado = 'Pendiente'.obs;

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

  snackBarPending({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
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
        "revisadoPor": "",
      });
      loading.value = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getReportes({required String categoria}) async {
    loading.value = true;
    
    Map<String, List<Map<String, dynamic>>> resultMap = {};

    List<Map<String, dynamic>> reportesList = [];

    CollectionReference reportesRef = firestore.collection('reportes');

    QuerySnapshot querySnapshot = await reportesRef.where('categoria',isEqualTo: categoria).get();

    querySnapshot.docs.forEach((element) {
      reportesList.add(element.data() as Map<String, dynamic>);
    });

    resultMap['Reportes'] = reportesList;
    getDataReportes.value = GetDataModelReportes.fromJson(resultMap);
    getDataReportes.value.ordenarReportes(OrdenReportes.pendiente);
    loading.value = false;
  }

  // metodo para obtener todos los reportes por edificio
  Future<void> getReportesEdificio({required String edificio}) async {
    loading.value = true;
    
    Map<String, List<Map<String, dynamic>>> resultMap = {};

    List<Map<String, dynamic>> reportesList = [];

    CollectionReference reportesRef = firestore.collection('reportes');

    QuerySnapshot querySnapshot = await reportesRef.where('ubicacion',isEqualTo: edificio).get();

    querySnapshot.docs.forEach((element) {
      reportesList.add(element.data() as Map<String, dynamic>);
    });

    resultMap['Reportes'] = reportesList;
    getDataReportes.value = GetDataModelReportes.fromJson(resultMap);

    listaPorcentajes.value = getPorcentajes();

    loading.value = false;
  }

  // metodo para obtener el porcentaje de reportes por categoria, son 4 categorias y lo sacaremos con el largo de cada lista
  List<double> getPorcentajes(){
    // primero obtenemos el largo de la lista
    int largo = getDataReportes.value.reportes.length;
    // luego obtenemos el porcentaje de cada categoria: Agua, Energía Eléctrica, Desechos Peligrosos, Otros
    double porcentajeAgua = (getDataReportes.value.reportes.where((element) => element.categoria == 'Agua').length / largo) * 100;
    double porcentajeEnergia = (getDataReportes.value.reportes.where((element) => element.categoria == 'Energía Eléctrica').length / largo) * 100;
    double porcentajeDesechos = (getDataReportes.value.reportes.where((element) => element.categoria == 'Desechos Peligrosos').length / largo) * 100;
    double porcentajeOtros = (getDataReportes.value.reportes.where((element) => element.categoria == 'Otros').length / largo) * 100;

    if(porcentajeAgua.isNaN){
      porcentajeAgua = 0;
    }
    if(porcentajeEnergia.isNaN){
      porcentajeEnergia = 0;
    }
    if(porcentajeDesechos.isNaN){
      porcentajeDesechos = 0;
    }
    if(porcentajeOtros.isNaN){
      porcentajeOtros = 0;
    }
    // retornamos una lista con los porcentajes
    return [porcentajeAgua, porcentajeEnergia, porcentajeDesechos, porcentajeOtros];
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

  // Metodo para actualizar el estado de un reporte
  Future<void> updateReporte({required int index,required String id, required String nuevoEstado, required BuildContext context}) async {
    loading.value = true;
    try{
      // Primero checamos que el reporte tenga el estado mismo estado, si el estado es el mismo no se actualiza
      String estado = getDataReportes.value.reportes[index].estado;
      if(estado == nuevoEstado || estado == 'Revisado'){
        loading.value = false;
        return;
      }
      await firestore.collection('reportes').doc(id).update({'estado': nuevoEstado});

      loading.value = false;
      if(!context.mounted) return;
      if(nuevoEstado == 'En revisión'){
        snackBarPending(message: 'Reporte en revisión', context: context);
      }else if(nuevoEstado == 'Revisado'){
        snackBarSucces(message: 'Reporte revisado', context: context);
      }
    }catch(e){
      print(e);
      loading.value = false;
      if(!context.mounted) return;
      snackBarError(message: 'Algo salio mal, por favor intente de nuevo más tarde', context: context);
    }
  }

  Future<void> loginUsingEmailPassword({required String numeroControl, required String password, required BuildContext context}) async{
    loading.value = true;
    try{
      usuario.value = '';
      nombre.value = '';
      iniciales.value = '';
      email.value = '';
      carrera.value = '';
      String correo = '$numeroControl@tecnamex.com';
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: correo, password: password);
      user = userCredential.user;
      if(user != null){
        usuario.value = numeroControl;
        loading.value = false;
        
        // Verificar el tipo de usuario (Estudiante, Jefe de Recursos Materiales, Administrativo de Recursos Materiales, Docente, Administrativo)
        if(!context.mounted) return;
        await verificarTipoUsuario(numeroControl: usuario.value, context: context);
        if(!activo.value){
          loading.value = false;
          if(!context.mounted) return;
          snackBarError(message: 'Lo sentimos, no puedes ingresar al sistema', context: context);
          return;
        }
        
        if(!context.mounted) return;
        if(estudiante.value){
          await obtenerDatosAlumno(numeroControl: usuario.value, context: context);
          if(!context.mounted) return;
          snackBarSucces(message: 'Bienvenido', context: context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SubirReporte(retroceder: false,)));
        }

        else if (jefeR.value || administrativoR.value) {
          await obtenerDatosEmpleado(numeroControl: usuario.value, context: context);
          if(!context.mounted) return;
          snackBarSucces(message: 'Bienvenido', context: context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CategoriasPage()));
        }
        // sino es estudiante ni jefe de recursos materiales entonces es un empleado (Docente o Administrativo)
        else if (empleado.value){
          await obtenerDatosEmpleado(numeroControl: usuario.value, context: context);
          if(!context.mounted) return;
          snackBarSucces(message: 'Bienvenido', context: context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SubirReporte(retroceder: false,)));
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
  
  Future<void> verificarTipoUsuario({required String numeroControl, required BuildContext context}) async{
    String collection = '/itz/tecnamex/';
    loading.value = true;
    try {
      jefeR.value = false;
      administrativoR.value = false;
      empleado.value = false;
      estudiante.value = false;
      collection += 'usuarios';
      DocumentSnapshot ds = await firestore.collection(collection).doc(numeroControl).get();
      Map<String, dynamic> datosEmpleado = ds.data() as Map<String, dynamic>;
      // Verificar si el usuario esta activo
      activo.value = datosEmpleado['activo'];
      if(!activo.value){
        return ;
      }

      // verificamos el tipo de usuario que quiere ingresar al sistema
      List<String> permisos = datosEmpleado['permisos'].cast<String>();
      for(int i = 0; i < permisos.length; i++){
        if(permisos[i] == 'Estudiante'){
          estudiante.value = true;
          return;
        }
        if (permisos[i] == 'Docente' || permisos[i] == 'Administrativo') {
          empleado.value = true;
        }
        if(permisos[i] == 'JefeRecursosMateriales'){
          jefeR.value = true;
          break;
        }
        if(permisos[i] == 'AdministrativoRecursosMateriales'){
          administrativoR.value = true;
          break;
        }
      }
    } catch (e) {
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
      datosUsuario.value = ds.data() as Map<String, dynamic>;
      obtenerPeriodoEscolar();
      obtenerNumero();
      obtenerIniciales(datosUsuario['apellidosNombre'].toString());
      email.value = datosUsuario['correoInstitucional'].toString();
      if(!context.mounted) return;
      await obtenerCarrera(collection: 'planes', id: datosUsuario['clavePlanEstudios'].toString(),context: context);
      nombre.value = datosUsuario['apellidosNombre'];
      loading.value = false;
    }catch(e){
      loading.value = false;
      if(!context.mounted) return;
      snackBarError(message: 'Algo salio mal, por favor intente de nuevo más tarde', context: context);
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

  Future<void> obtenerDatosEmpleado({required String numeroControl, required BuildContext context}) async{
    String collection = '/itz/tecnamex/';
    loading.value = true;
    try{
      collection += 'empleados';
      QuerySnapshot querySnapshot = await firestore.collection(collection).where('rfc',isEqualTo: numeroControl).get();
      Map<String, dynamic> datosEmpleado = querySnapshot.docs[0].data() as Map<String, dynamic>;
      obtenerIniciales(datosEmpleado['apellidosNombre'].toString());
      email.value = datosEmpleado['correoInstitucional'].toString();
      nombre.value = datosEmpleado['apellidosNombre'];
      loading.value = false;
    }catch(e){
      loading.value = false;
    }
  }

  // metodo para obtener el periodo actual
  // 20223 significa que el periodo escolar se comprende desde Ago - Dic 2022
  // 20222 significa que el periodo escolar se comprende desde Verano 2022
  // 20221 significa que el periodo escolar se comprende desde Ene - Jun 2022
  // en el arreglo esta un campo llamado periodoIngreso donde se encuentra este dato
  obtenerPeriodoEscolar(){
    periodoIngreso.value = datosUsuario['periodoIngreso'].toString();
    String periodoYear = datosUsuario['periodoIngreso'].toString().substring(0, 4);
    String periodoMes = datosUsuario['periodoIngreso'].toString().substring(4, 5);
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
    telefono.value = datosUsuario['celular'].toString();
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
  obtenerIniciales(String nombre){
    String nombreCompleto = nombre;
    List<String> nombreCompletoSeparado = nombreCompleto.split(' ');
    int largo = nombreCompletoSeparado.length;

    // Inicial del apellido paterno
    String letraA = nombreCompletoSeparado[0].substring(0, 1);
    // Inicial del nombre
    String letraB = '';
    if (largo == 4) {
      letraB = nombreCompletoSeparado[(nombreCompletoSeparado.length - 2)].substring(0, 1);
    }else if(largo == 3){
      letraB = nombreCompletoSeparado[(nombreCompletoSeparado.length - 1)].substring(0, 1);
    }else if(largo == 2){
      letraB = nombreCompletoSeparado[(nombreCompletoSeparado.length - 1)].substring(0, 1);
    }
    
    // Iniciales completas ej: US
    iniciales.value = letraB + letraA;
  }
}


