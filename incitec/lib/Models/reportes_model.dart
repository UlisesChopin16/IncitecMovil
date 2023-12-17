// To parse this JSON data, do
//
//     final getDataModelReportes = getDataModelReportesFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

GetDataModelReportes getDataModelReportesFromJson(String str) => 
  GetDataModelReportes.fromJson(json.decode(str));

String getDataModelReportesToJson(GetDataModelReportes data) => 
  json.encode(data.toJson());

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
}

class Reporte {
    String descripcion;
    DateTime fecha;
    String ubicacion;
    String estado;
    String categoria;
    String imagen;
    String nombreCompleto;

    Reporte({
        required this.descripcion,
        required this.fecha,
        required this.ubicacion,
        required this.estado,
        required this.categoria,
        required this.imagen,
        required this.nombreCompleto,
    });

    factory Reporte.fromJson(Map<String, dynamic> json) => Reporte(
        descripcion: json["descripcion"],
        fecha: (json["fecha"] as Timestamp).toDate(),
        ubicacion: json["ubicacion"],
        estado: json["estado"],
        categoria: json["categoria"],
        imagen: json["imagen"],
        nombreCompleto: json["nombreCompleto"],
    );

    Map<String, dynamic> toJson() => {
        "descripcion": descripcion,
        "fecha": fecha.toIso8601String(),
        "ubicacion": ubicacion,
        "estado": estado,
        "categoria": categoria,
        "imagen": imagen,
        "nombreCompleto": nombreCompleto,
    };
}
