import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:incitec/Components/dropdown_component.dart';
import 'package:incitec/Constants/colors.dart';
import 'package:incitec/Services/firebase_service.dart';
import 'package:incitec/Views/login_view.dart';

class SubirReporte extends StatefulWidget {
  const SubirReporte({super.key,});

  @override
  State<SubirReporte> createState() => _SubirReporteState();
}

class _SubirReporteState extends State<SubirReporte> {

  final servicios = Get.put(FirebaseServicesInciTec());

  bool selectedCategory = false;

  FocusNode focusNode = FocusNode();

  Uint8List selectedImage = Uint8List(0);
  File? imagen;
  final picker = ImagePicker();
  double w = 0;
  double h = 0;
  final _formKey = GlobalKey<FormState>(); 

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

  List<String> listaCategorias = [
    'Energía Eléctrica',
    'Agua',
    'Sustancias peligrosas',
    'Otros',
  ];

  Map<String, List<String>> listadoIncidenciasPorCategoria = {
    'Energía Eléctrica': [
      'Foco prendido',
      'Falso contacto',
      'Computadora prendida en el día en salones vacios',
      'Otros',
    ],
    'Agua': [
      'Desperdicio de agua',
      'Otros',
    ],
    'Sustancias peligrosas': [
      'Manguera de gas rota',
      'Otros',
    ],
    'Otros': [
      'Otros',
    ],
  };

  String categoria = '';
  String incidencia = '';
  String descripcion = '';
  String edificios = '';

  @override
  void initState() {
    super.initState();

    // Si despues de las 6pm estan los aires acondicionados prendidos, entonces el orden de a lista sera diferente
    // 'Energía Eléctrica': [
    //   'Foco prendido',
    //   'Aire acondicionado prendido',
    //   'Falso contacto',
    //   'Computadora prendida en el día en salones vacios',
    //   'Otros',
    // ],
    if(DateTime.now().hour >= 18){
      listadoIncidenciasPorCategoria['Energía Eléctrica']!.insert(1, 'Aire acondicionado prendido');
    }

  }

  resolucion(){
    setState(() {
      w = MediaQuery.of(context).size.width;
      h = MediaQuery.of(context).size.height;
    });
  }

  Future selImagen(op) async{

    XFile? pickedFile;

    if(op == 1){
      pickedFile == await picker.pickImage(source: ImageSource.camera).then((value) {
        if (value != null) {
          setState(() {
            imagen = File(value.path);
            selectedImage = imagen!.readAsBytesSync();
          });
        }else{
        }
      });
    }else{
      pickedFile == await picker.pickImage(source: ImageSource.gallery).then((value) {
        if (value != null) {
          setState(() {
            imagen = File(value.path);
            selectedImage = imagen!.readAsBytesSync();
          });
        }else{
        }
      });
    }
    if(!context.mounted)return;
    Navigator.of(context).pop();
  }

  opciones(context) {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  selImagen(1);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: Colors.grey))),
                  child: const Row(
                    children:  [
                      Expanded(
                        child: Text(
                          'Tomar una foto',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(Icons.camera_alt, color: Colors.blue)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  selImagen(2);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Seleccionar una foto',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(Icons.image, color: Colors.blue)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  TextStyle textoNormal(double sizet) {
    return TextStyle(
      color: Colors.black,
      fontSize: sizet,
      height: 1.5,
    );
  }

  void categoriasOnChanged(dynamic selectedValue) {
    setState(() {
      selectedCategory = true;
      categoria = selectedValue!;
    });
  }

  void incidenciaOnChanged(dynamic selectedValue) {
    setState(() {
      incidencia = selectedValue!;
    });
  }

  void edificiosOnChanged(dynamic selectedValue) {
    setState(() {
      edificios = selectedValue!;
    });
  }

  void descripcionOnChanged(dynamic selectedValue) {
    setState(() {
      descripcion = selectedValue!;
    });
  }

  String? validator(dynamic value){
    if (value.isEmpty || value.trim() == '') {
      return 'Campo obligatorio *';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    resolucion();
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Subir Reporte'),
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
                  title: const Text('Cerrar Sesión'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                ),
              ],
            ),
          ),
          body: Center(
            child: !servicios.loading.value ? Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,

              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: w > 500 ? 500 : w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 20,),
                        dropEdifcios(),
                        const SizedBox(height: 20,),
                        dropCategoria(),
                        const SizedBox(height: 20,),
                        dropIncidencias(),
                        const SizedBox(height: 20,),
                        textDescripcion(),
                        const SizedBox(height: 20,),
                        
                        botonFoto(),
                        const SizedBox(height: 30,),
                        // imagen == null ? Center() : Image.file(imagen!),
                        const SizedBox(height: 20,),
                        botonSubirReporte(),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ),
            ): const CircularProgressIndicator(),
          )
        );
      },
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

  dropEdifcios(){
    return DropdownComponent(
      label: 'Edificio',
      value: edificios.isEmpty ? null : edificios,
      items: listaEdificios.map((e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      )).toList(),
      validator: validator,
      onChanged: edificiosOnChanged,
      hint: 'Edificio 1',
    );
  }

  dropCategoria(){
    return DropdownComponent(
      label: 'Categoría',
      value: categoria.isEmpty ? null : categoria,
      items: listaCategorias.map((e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      )).toList(),
      validator: validator,
      onChanged: categoriasOnChanged,
      hint: 'Energía Eléctrica',
    );
  }
 
  dropIncidencias(){
    return DropdownComponent(
      label: 'Incidencia',
      value: selectedCategory ? listadoIncidenciasPorCategoria[categoria]![0] : null,
      items: selectedCategory ? listadoIncidenciasPorCategoria[categoria]!.map((e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      )).toList() : null,
      onChanged: selectedCategory ? incidenciaOnChanged : null,
      validator: validator,
      hint: 'Foco prendido',
    );
  }

  textDescripcion(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Descripción'),
        TextFormField(
          style: textoNormal(18),
          onChanged: descripcionOnChanged,
          validator: validator,
          maxLines: 4,
          decoration: InputDecoration(
            filled: true,
            fillColor:Colors.grey[300],
            hintText: 'El foco de la sala 1 esta prendido en el día',
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontSize: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0
              )
            )
          ),
        ),
      ],
    );
  }
  
  botonFoto(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Foto'),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300)
          ),
          onPressed: () {
            opciones(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              if(imagen == null)
              Text('Agregar Imagen',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.50), 
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
              ),
              const SizedBox(height: 20,),
              if(imagen != null) 
                Image.memory(
                  selectedImage,
                  width: 401,
                  height: 343,
                )
              else
                Image.asset('assets/camara.png',
                  color: Colors.black.withOpacity(0.50),
                ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ],
    );
  }

  botonSubirReporte(){
    return ElevatedButton(
      onPressed: () async {
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CategoriasPage()));
        if(_formKey.currentState!.validate()){

          if(imagen == null){
            servicios.snackBarError(message: 'Debe agregar una imagen', context: context);
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subiendo Reporte')));

          // estampa de tiempo
          String data = await servicios.subirImagen(imagen!);
          if(data != ''){
            DateTime fecha = DateTime.now();
            bool data2 = await servicios.agregarReporte(
              descripcion: descripcion, 
              fecha: fecha,
              ubicacion: edificios, 
              estado: 'Pendiente', 
              imagen: data,
              categoria: categoria,
              nombreCompleto: servicios.nombre.value,
              carrera: servicios.carrera.value,
              numeroControl: servicios.usuario.value,
            );
            if(!context.mounted)return;
            if(data2){
              servicios.snackBarSucces(message: 'Reporte subido correctamente', context: context);
              setState(() {
                selectedCategory = false;
                imagen = null;
                descripcion = '';
                categoria = '';
                incidencia = '';
                edificios = '';
              });
            }else{
              servicios.snackBarError(message: 'Error al subir el reporte', context: context);
            }
          }else{
            if(!context.mounted)return;
            servicios.snackBarError(message: 'Error al subir la imagen', context: context);
          }
        }else{
          servicios.snackBarError(message: 'Debe de llenar todos los campos', context: context);
          if(imagen == null){
            servicios.snackBarError(message: 'Debe agregar una imagen', context: context);
            return;
          }
        }
        // Navigator.of(context).pop();
      }, 
      child: const Text('Subir Reporte')
    );
  }

}