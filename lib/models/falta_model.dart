import 'dart:convert';

AppDataFalta faltasFirstLoadFromJson(String str) {
  final jsonData = json.decode(str);
  return AppDataFalta.fromJson(jsonData);
}

String faltasFirstToJson(AppDataFalta data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AppDataFalta {
  List<Falta> falta;

  AppDataFalta({
    required this.falta,
  });

  factory AppDataFalta.fromJson(Map<String, dynamic> json) => AppDataFalta(
        falta: List<Falta>.from(json["result"].map((x) => Falta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "falta": List<dynamic>.from(falta.map((x) => x.toJson())),
      };
}

class Falta {
  String id;
  String nombre;
  String paterno;
  String materno;
  // ignore: non_constant_identifier_names
  String no_empleado;
  // ignore: non_constant_identifier_names
  String fk_usuario;
  String fecha;

  Falta({
    required this.id,
    required this.nombre,
    required this.paterno,
    required this.materno,
    // ignore: non_constant_identifier_names
    required this.no_empleado,
    // ignore: non_constant_identifier_names
    required this.fk_usuario,
    required this.fecha,
  });

  factory Falta.fromJson(Map<String, dynamic> json) => Falta(
        id: json["id"],
        nombre: json["nombre"],
        paterno: json["paterno"] ?? "",
        materno: json["materno"] ?? "",
        no_empleado: json["no_empleado"] ?? "",
        fk_usuario: json["fk_usuario"] ?? "",
        fecha: json["fecha"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "paterno": paterno,
        "materno": materno,
        "no_empleado": no_empleado,
        "fk_usuario": fk_usuario,
        "fecha": fecha,
      };
}
