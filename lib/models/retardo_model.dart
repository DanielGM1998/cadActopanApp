import 'dart:convert';

AppDataRetardo retardosFirstLoadFromJson(String str) {
  final jsonData = json.decode(str);
  return AppDataRetardo.fromJson(jsonData);
}

String retardosFirstToJson(AppDataRetardo data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AppDataRetardo {
  List<Retardo> retardo;

  AppDataRetardo({
    required this.retardo,
  });

  factory AppDataRetardo.fromJson(Map<String, dynamic> json) => AppDataRetardo(
        retardo:
            List<Retardo>.from(json["result"].map((x) => Retardo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "retardo": List<dynamic>.from(retardo.map((x) => x.toJson())),
      };
}

class Retardo {
  String id;
  String nombre;
  String paterno;
  String materno;
  // ignore: non_constant_identifier_names
  String no_empleado;
  // ignore: non_constant_identifier_names
  String fk_usuario;
  String fecha;

  Retardo({
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

  factory Retardo.fromJson(Map<String, dynamic> json) => Retardo(
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
