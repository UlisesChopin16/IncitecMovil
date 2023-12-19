import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incitec/Services/firebase_service.dart';
import 'package:printing/printing.dart';

class PdfReporteView extends StatefulWidget {
  final String id;
  const PdfReporteView({ 
    Key? key,
    required this.id
  }) : super(key: key);

  @override
  _PdfReporteViewState createState() => _PdfReporteViewState();
}

class _PdfReporteViewState extends State<PdfReporteView> {

  final servicios = Get.put(FirebaseServicesInciTec());

  double width = 0;
  double height = 0;

  

  @override
  void initState() {
    super.initState();
  }

  // get screen size
  getSize() {
    setState(() {
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    getSize();
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PDF del reporte'),
      ),
      body: Center(
        child: Column(
          children: [
              Expanded(
                child: PdfPreview(
                  build: (format) => servicios.pdf.value,
                  canDebug: false,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  allowSharing: false,
                  maxPageWidth: width * 0.6,
                  pdfPreviewPageDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  actions: [
                    IconButton(
                      onPressed: (){
                        Printing.sharePdf(bytes: servicios.pdf.value, filename: '${widget.id}.pdf');
                      }, 
                      icon: const Icon(Icons.download)
                    ),
                  ],
                ),
              )
          ],
        )
      ),
    );
  }

}