import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incitec/Constants/colors.dart';
import 'package:incitec/Models/reportes_model.dart';
import 'package:incitec/Services/firebase_service.dart';
import 'package:incitec/Views/info_reportes_view.dart';

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
          centerTitle: true,
          title: Text(widget.cat),
        ),
        body: Center(
          child: !servicios.loading.value ? CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                  child: DropdownButtonFormField<String>(
                    value: servicios.estado.value,
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: Palette.letras,
                    ),
                    iconSize: 34,
                    // isExpanded: true,
                    style: TextStyle(
                      color: Palette.letras,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        servicios.estado.value = newValue!;
                        if(newValue == 'Pendiente'){
                          servicios.getDataReportes.value.ordenarReportes(OrdenReportes.pendiente);
                        }else if(newValue == 'En revisión'){
                          servicios.getDataReportes.value.ordenarReportes(OrdenReportes.enRevision);
                        }else if(newValue == 'Revisado'){
                          servicios.getDataReportes.value.ordenarReportes(OrdenReportes.revisado);
                        }
                      });
                      
                    },
                    items: <String>['Pendiente', 'En revisión', 'Revisado']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    // Le damos un estilo al dropdown
                    decoration: InputDecoration(
                      // ponemos el fondo del dropdown transparente
                      filled: true,
                      
                      // le damos un color al fondo del dropdown
                      fillColor:Colors.white,
                      
                      // Le damos un icono al dropdown
                      hintText: 'Filtrar por estado',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
                ),
              ),
              SliverList.builder(
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
                      fecha: reportes.fecha,
                      imagen: reportes.imagen,
                      nombreCompleto: reportes.nombreCompleto,
                      ubicacion: reportes.ubicacion,
                      carrera: reportes.carrera,
                      numeroControl: reportes.numeroControl,
                      incidencia: reportes.incidencia,
                    );
                  }
                },
              ),
            ],
          ): const Center(child: CircularProgressIndicator(),),
        ),
      ),
    );
  }

  cardReportes({
    required int index,
    required String cat, 
    required String path, 
    required String descripcion, 
    required String estado, 
    required String fecha, 
    required String imagen, 
    required String nombreCompleto, 
    required String ubicacion,
    required String carrera,
    required String numeroControl,
    required String incidencia,
  }){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: w,
          child: InkWell(
            onTap: () async {
              await servicios.updateReporte(index: index,id: fecha, nuevoEstado: 'En revisión', context: context);
              if(!context.mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => InfoReportesPage(
                index: index,
                cat: cat,
                path: path,
                descripcion: descripcion,
                estado: estado,
                fecha: fecha,
                imagen: imagen,
                nombreCompleto: nombreCompleto,
                ubicacion: ubicacion,
                carrera: carrera,
                numeroControl: numeroControl,
                incidencia: incidencia,
              ))).then((value) {
                servicios.getReportes(categoria: widget.cat);
              });
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
                    // padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                    padding: const EdgeInsets.only(left: 30,right: 10,top: 20,bottom: 20),
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
                          campoTexto(
                            titulo: 'Incidencia:', 
                            texto: incidencia,
                          ),
                          const SizedBox(height: 10.0,),
                          campoTexto(
                            titulo: 'Ubicación:', 
                            texto: ubicacion,
                          ),
                          const SizedBox(height: 10.0,),
                          campoTexto(
                            titulo: 'descripcion:', 
                            texto: descripcion,
                          ),
                          const SizedBox(height: 10.0,),
                          campoTexto(
                            titulo: 'Estado:', 
                            texto: estado,
                            color: estado == 'Pendiente' ? Colors.red : estado == 'En revisión' ? Colors.orange : Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  image({
    required String rutaImagen,
  }){
    return SizedBox(
      height: 140,
      width: 170,
      child: Hero(
        transitionOnUserGestures: true,
        tag: rutaImagen,
        child: CachedNetworkImage(
          imageUrl: rutaImagen,
          imageBuilder: contenedorImagen,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
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
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget campoTexto({
    required String titulo,
    required String texto,
    Color color = Colors.black,
  }){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          texto,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }

}