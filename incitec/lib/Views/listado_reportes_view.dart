import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incitec/Services/firebase_service.dart';
import 'package:incitec/Views/InfoReportesPage.dart';

class ReportesPage extends StatefulWidget {
  final String cat;
  final String path;
  const ReportesPage({Key? key, required this.cat, required this.path}) : super(key: key);
  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {

  final servicios = Get.put(FirebaseServicesInciTec());

  double w = 0;
  double h = 0;
 


  @override
  void initState() {
    super.initState();
    servicios.getReportes(categoria: widget.cat);
  }

  resolucion(){
    setState(() {
      w = MediaQuery.of(context).size.width;
      h = MediaQuery.of(context).size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    resolucion();
    return Obx(
      ()=> Scaffold(
        appBar: AppBar(
          title: Text(widget.cat),
        ),
        body: Center(
          child: SizedBox(
            width: w > 800 ? 800 : w,
            height: h * 0.9,
            child: !servicios.loading.value ? ListView.builder( 
              shrinkWrap: true,
              itemCount: servicios.getDataReportes.value.reportes.length,
              itemBuilder: (context, index) {
                final reportes = servicios.getDataReportes.value.reportes[index];
                if(reportes.categoria != widget.cat){
                  return Container();
                }else{
                  return  cardReportes(
                    index: index,
                    cat: widget.cat,
                    path: widget.path,
                    descripcion: reportes.descripcion,
                    estado: reportes.estado,
                    fecha: reportes.fecha.toString().split(' ')[0],
                    imagen: reportes.imagen,
                    nombreCompleto: reportes.nombreCompleto,
                    ubicacion: reportes.ubicacion,
                  );
                }
              },
            ): const Center(child: CircularProgressIndicator(),),
          ),
        ),
      ),
    );
  }

  cardReportes({required int index,required String cat, required String path, required String descripcion, required String estado, required String fecha, required String imagen, required String nombreCompleto, required String ubicacion}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InfoReportesPage(
            cat: cat,
            path: path,
            descripcion: descripcion,
            estado: estado,
            fecha: fecha,
            imagen: imagen,
            nombreCompleto: nombreCompleto,
            ubicacion: ubicacion,
          )));
        },
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: image(
                  rutaImagen: imagen
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categoria: \n$cat',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                        ),
                      ),
                      Text(
                        '$ubicacion\n$fecha\nPrioridad: $estado',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ),
    );
  }

  image({
    required String rutaImagen,
  }){
    return SizedBox(
      height: 150,
      width: 100,
      child: CachedNetworkImage(
        imageUrl: rutaImagen,
        imageBuilder: contenedorImagen,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }

  // metodos para mostrar la imagen de la api guardada en el cache
  Widget contenedorImagen(BuildContext context, ImageProvider<Object> imageProvider) {
    return Container(
      height: 250,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

}