

import 'dart:convert';

GetDataModelReporte getDataModelReporteFromJson(String str) => GetDataModelReporte.fromJson(json.decode(str));

String getDataModelReporteToJson(GetDataModelReporte data) => json.encode(data.toJson());

class GetDataModelReporte {
    List<ReporteCant> reportes;
    List<CantidadTotal> cantidadTotal;

    GetDataModelReporte({
        required this.reportes,
        required this.cantidadTotal,
    });

    factory GetDataModelReporte.fromJson(Map<String, dynamic> json) => GetDataModelReporte(
        reportes: List<ReporteCant>.from(json["Reportes"].map((x) => ReporteCant.fromJson(x))),
        cantidadTotal: List<CantidadTotal>.from(json["CantidadTotal"].map((x) => CantidadTotal.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Reportes": List<dynamic>.from(reportes.map((x) => x.toJson())),
        "CantidadTotal": List<dynamic>.from(cantidadTotal.map((x) => x.toJson())),
    };
}

class CantidadTotal {
    int count;

    CantidadTotal({
        required this.count,
    });

    factory CantidadTotal.fromJson(Map<String, dynamic> json) => CantidadTotal(
        count: json["count(*)"],
    );

    Map<String, dynamic> toJson() => {
        "count(*)": count,
    };
}

class ReporteCant {
    int idEd;
    int idCat;
    int countIdCat;

    ReporteCant({
        required this.idEd,
        required this.idCat,
        required this.countIdCat,
    });

    factory ReporteCant.fromJson(Map<String, dynamic> json) => ReporteCant(
        idEd: json["idEd"],
        idCat: json["idCat"],
        countIdCat: json["count(idCat)"],
    );

    Map<String, dynamic> toJson() => {
        "idEd": idEd,
        "idCat": idCat,
        "count(idCat)": countIdCat,
    };
}
