import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:incitec/Services/firebase_service.dart';
import 'package:incitec/Services/generar_pdf_service.dart';
import 'package:incitec/Views/pdf_reporte_view.dart';

class InfoReportesPage extends StatefulWidget {

  final int index;
  final String cat;
  final String path;
  final String descripcion;
  final String estado;
  final String fecha;
  final String imagen;
  final String nombreCompleto;
  final String ubicacion;
  final String carrera;
  final String numeroControl;
  final String incidencia;

  const InfoReportesPage({
    Key? key, 
    required this.index,
    required this.cat, 
    required this.path,
    required this.descripcion,
    required this.estado,
    required this.fecha,
    required this.imagen,
    required this.nombreCompleto,
    required this.ubicacion,
    required this.carrera,
    required this.numeroControl,
    required this.incidencia,
  })
      : super(key: key);
  @override
  State<InfoReportesPage> createState() => _InfoReportesPageState();
}

class _InfoReportesPageState extends State<InfoReportesPage> {

  final servicios = Get.put(FirebaseServicesInciTec());

  double h = 0;
  double w = 0; 

  bool cambioEstado = false;

  String estado = '';

  @override
  void initState() {
    super.initState();
    estado = widget.estado;
    if(widget.estado == 'Revisado'){
      cambioEstado = true;
    }
  }

  resolucion() {
    setState(() {
      h = MediaQuery.of(context).size.height;
      w = MediaQuery.of(context).size.width;
    });
  }

  // widget.fecha viene de la siguiente manera: "2023-12-18 00:35:51.519058"
  // Yo quiero obtener la hora y los minutos
  // Para eso hago lo siguiente:
  obtenerHora(){
    // parseo la fecha a un DateTime
    final fecha = DateTime.parse(widget.fecha);
    // obtengo la hora y los minutos de tal manera que si son las 00:00 se muestre como 12:00 am
    final hora = '${fecha.hour == 0 ? 12 : fecha.hour}:${fecha.minute == 0 ? '00' : fecha.minute} ${fecha.hour < 12 ? 'am' : 'pm'}';
    return hora;
  }

  // metodo para mostrar mensaje emergente de si esta de acuerdo en cambiar el estado de En revision a Revisado
  void mostrarDialogo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de que quieres pasar este reporte a Revisado?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra el diálogo
                await servicios.updateReporte(index: widget.index, id: widget.fecha, nuevoEstado: 'Revisado', context: context);
                setState(() {
                  cambioEstado = true;
                  estado = 'Revisado';
                });
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  


  @override
  Widget build(BuildContext context) {
    resolucion();
    return Obx(
      ()=> Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Detalles del reporte'),
          actions: [
            IconButton(
              onPressed: () async {
                servicios.loading.value = true;
                await GenerarPdfServices().initPDF(
                  index: widget.index,
                  cat: widget.cat, 
                  path: widget.path,
                  descripcion: widget.descripcion,
                  estado: estado,
                  fecha: widget.fecha,
                  imagen: widget.imagen,
                  nombreCompleto: widget.nombreCompleto,
                  ubicacion: widget.ubicacion,
                  carrera: widget.carrera,
                  numeroControl: widget.numeroControl,
                  incidencia: widget.incidencia,
                );
                servicios.loading.value = false;
                if(!context.mounted)return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PdfReporteView(
                      id: widget.fecha,
                    )
                  )
                );
              },
              icon: const Icon(Icons.picture_as_pdf)
            ),
            if(!cambioEstado)
              IconButton(
                onPressed: mostrarDialogo,
                icon: const Icon(Icons.check)
              ),
          ],
        ),
        body: Center(
          child: !servicios.loading.value ?  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: w > 500 ? w * 0.4 : w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.cat,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      SizedBox(
                        height: h * 0.4,
                        width: w * 0.8,
                        child: imagen(),
                      ),
                      const SizedBox(height: 20.0,),
                      campoTexto(
                        titulo: 'Incidencia:', 
                        texto: widget.incidencia
                      ),
                      const SizedBox(height: 20.0,),
                      campoTexto(
                        titulo: 'Descripción:', 
                        texto: widget.descripcion
                      ),
                      const SizedBox(height: 20.0,),
                      campoTexto(
                        titulo: 'Ubicación:', 
                        texto: widget.ubicacion
                      ),
                      const SizedBox(height: 20.0,),
                      campoTexto(
                        titulo: 'Nombre:', 
                        texto: widget.nombreCompleto
                      ),
                      const SizedBox(height: 20.0,),
                      campoTexto(
                        titulo: 'Carrera:', 
                        texto: widget.carrera
                      ),
                      const SizedBox(height: 20.0,),
                      campoTexto(
                        titulo: 'Número de control:', 
                        texto: widget.numeroControl
                      ),
                      const SizedBox(height: 20.0,),
                      campoTexto(
                        titulo: 'Fecha del reporte:',
                        texto: widget.fecha.split(' ')[0]
                      ),
                      const SizedBox(height: 20.0,),
                      campoTexto(
                        titulo: 'Hora del reporte:',
                        texto: obtenerHora()
                      ),
                      const SizedBox(height: 20.0,),
                      campoTexto(
                        titulo: 'Estado del reporte:', 
                        texto: estado,
                        // Si el estado es 'pendiente' sera rojo, si es 'En revision' sera naranja y si es 'Resuelto' sera verde
                        color:  estado == 'Pendiente' ? Colors.red : estado == 'En revisión' ? Colors.orange : Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ) : const CircularProgressIndicator(),
        ) 
      ),
    );
  }

  imagen(){
    if(widget.imagen.isEmpty){
      return Image.asset(
        widget.path,
        width: 100,
        height: 140,
        fit: BoxFit.cover,
      );
    }else if(widget.imagen == 'img'){
      return Image.asset(
        widget.path,
        width: 100,
        height: 140,
        fit: BoxFit.cover,
      );
    }else{
      return Hero(
        tag: widget.imagen,
        transitionOnUserGestures: true,
        child: CachedNetworkImage(
          imageUrl: widget.imagen,
          imageBuilder: contenedorImagen,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }

  // metodos para mostrar la imagen de la api guardada en el cache
  Widget contenedorImagen(BuildContext context, ImageProvider<Object> imageProvider) {
    
    return Container(
      height: 100,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          texto,
          style: TextStyle(
            fontSize: 22,
            color: color,
          ),
        ),
      ],
    );
  }


}