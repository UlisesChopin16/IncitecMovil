// To parse this JSON data, do
//
//     final getDataModelReportes = getDataModelReportesFromJson(jsonString);

import 'dart:convert';

GetDataModelReportes getDataModelReportesFromJson(String str) => 
  GetDataModelReportes.fromJson(json.decode(str));

String getDataModelReportesToJson(GetDataModelReportes data) => 
  json.encode(data.toJson());

enum OrdenReportes { pendiente, enRevision, revisado }

class GetDataModelReportes {
    List<Reporte> reportes;

    GetDataModelReportes({
        required this.reportes,
    });

    factory GetDataModelReportes.fromJson(Map<String, dynamic> json) => GetDataModelReportes(
        reportes: List<Reporte>.from(json["Reportes"].map((x) => Reporte.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Reportes": List<dynamic>.from(reportes.map((x) => x.toJson())),
    };

    void ordenarReportes(OrdenReportes orden) {
      reportes.sort((a, b) => _compararEstados(a.estado, b.estado, orden));

      print("Después de ordenar: ${reportes.map((reporte) => reporte.estado)}");
    }

    int _compararEstados(String estadoA, String estadoB, OrdenReportes orden) {
      final estadosOrdenados = ["Pendiente", "En revisión", "Revisado"];

      if (orden == OrdenReportes.pendiente) {
        return estadosOrdenados.indexOf(estadoA).compareTo(estadosOrdenados.indexOf(estadoB));
      } else if (orden == OrdenReportes.enRevision) {
        if (estadoA == "En revisión" && estadoB == "En revisión") {
          return 0; // Igual para "En revisión"
        } else if (estadoA == "En revisión") {
          return -1; // "En revisión" debe ir antes de otros estados
        } else if (estadoB == "En revisión") {
          return 1; // Otros estados deben ir después de "En revisión"
        } else {
          return 0; // Sin cambios en el orden
        }
      } else if (orden == OrdenReportes.revisado) {
        return estadosOrdenados.indexOf(estadoB).compareTo(estadosOrdenados.indexOf(estadoA));
      } else {
        return 0; // Sin cambios en el orden
      }
    }
}

class Reporte {
    String descripcion;
    String fecha;
    String ubicacion;
    String estado;
    String categoria;
    String imagen;
    String nombreCompleto;
    String carrera;
    String numeroControl;
    String incidencia;

    Reporte({
        required this.descripcion,
        required this.fecha,
        required this.ubicacion,
        required this.estado,
        required this.categoria,
        required this.imagen,
        required this.nombreCompleto,
        required this.carrera,
        required this.numeroControl,
        required this.incidencia,
    });

    factory Reporte.fromJson(Map<String, dynamic> json) => Reporte(
        descripcion: json["descripcion"],
        fecha: (json["fecha"]),
        ubicacion: json["ubicacion"],
        estado: json["estado"],
        categoria: json["categoria"],
        imagen: json["imagen"],
        nombreCompleto: json["nombreCompleto"],
        carrera: json["carrera"],
        numeroControl: json["numeroControl"],
        incidencia: json["incidencia"],
    );

    Map<String, dynamic> toJson() => {
        "descripcion": descripcion,
        "fecha": fecha,
        "ubicacion": ubicacion,
        "estado": estado,
        "categoria": categoria,
        "imagen": imagen,
        "nombreCompleto": nombreCompleto,
        "carrera": carrera,
        "numeroControl": numeroControl,
        "incidencia": incidencia,
    };
}
