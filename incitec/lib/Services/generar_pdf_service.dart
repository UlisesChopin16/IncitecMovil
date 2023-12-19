import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:incitec/Services/firebase_service.dart';
import 'package:printing/printing.dart';
class GenerarPdfServices {

  final servicios = Get.put(FirebaseServicesInciTec());

  final pdf = pw.Document();
  PdfImage? logo;
  
  final format = PdfPageFormat.a4;
  pw.PageOrientation orientation = pw.PageOrientation.portrait;

  // widget.fecha viene de la siguiente manera: "2023-12-18 00:35:51.519058"
  // Yo quiero obtener la hora y los minutos
  // Para eso hago lo siguiente:
  obtenerHora(String fechaN){
    // parseo la fecha a un DateTime
    final fecha = DateTime.parse(fechaN);
    // obtengo la hora y los minutos de tal manera que si son las 00:00 se muestre como 12:00 am
    final hora = '${fecha.hour == 0 ? 12 : fecha.hour}:${fecha.minute == 0 ? '00' : fecha.minute} ${fecha.hour < 12 ? 'am' : 'pm'}';
    return hora;
  }

  Future<void> initPDF({
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
  }) async {
    servicios.pdf.value = await generarPDF(
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
    );
  }

  generarPDF (
    {
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
    }
  ) async {
    print(imagen);
    final netImage = await networkImage(
      imagen,
    );

    
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        orientation: orientation,
        margin:const pw.EdgeInsets.all(10),
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(top: 20.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Center(
                  child: pw.Container(
                    color: const PdfColor.fromInt(0xFF2D3091),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text('Detalles del reporte',style: pw.TextStyle(color: PdfColors.white, fontSize: 24, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(height: 20.0,),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children:<pw.Widget> [
                    pw.Image(
                      netImage,
                      height: 230,
                      width: 280,
                    ),
                    pw.SizedBox(height: 30.0,),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        campoTexto(
                          titulo: 'Incidencia:', 
                          texto: incidencia
                        ),
                        pw.SizedBox(height: 20.0,),
                        campoTexto(
                          titulo: 'Descripción:', 
                          texto: descripcion
                        ),
                        pw.SizedBox(height: 20.0,),
                        campoTexto(
                          titulo: 'Ubicación:', 
                          texto: ubicacion
                        ),
                        pw.SizedBox(height: 20.0,),
                        campoTexto(
                          titulo: 'Nombre:', 
                          texto: nombreCompleto
                        ),
                        pw.SizedBox(height: 20.0,),
                        campoTexto(
                          titulo: 'Carrera:', 
                          texto: carrera
                        ),
                        pw.SizedBox(height: 20.0,),
                        campoTexto(
                          titulo: 'Número de control:', 
                          texto: numeroControl
                        ),
                        pw.SizedBox(height: 20.0,),
                        campoTexto(
                          titulo: 'Fecha del reporte:',
                          texto: fecha.split(' ')[0]
                        ),
                        pw.SizedBox(height: 20.0,),
                        campoTexto(
                          titulo: 'Hora del reporte:',
                          texto: obtenerHora(fecha)
                        ),
                        pw.SizedBox(height: 20.0,),
                        campoTexto(
                          titulo: 'Estado del reporte:', 
                          texto: estado,
                          // Si el estado es 'pendiente' sera rojo, si es 'En revision' sera naranja y si es 'Resuelto' sera verde
                          color:  estado == 'Pendiente' ? PdfColors.red : estado == 'En revisión' ? PdfColors.orange : PdfColors.green,
                        ),
                      ],
                    )
                  ],
                ),
                
              ],
            ),
          );
        }
      )
    );

    return pdf.save();

  }

  campoTexto({
    required String titulo,
    required String texto,
    PdfColor color = PdfColors.black,
  }){
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          titulo,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold
          ),
        ),
        pw.Text(
          texto,
          style: pw.TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }



}