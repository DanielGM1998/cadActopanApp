import 'dart:convert';

AppDataAsistencia asistenciasFirstLoadFromJson(String str) {
  final jsonData = json.decode(str);
  return AppDataAsistencia.fromJson(jsonData);
}

String asistenciasFirstToJson(AppDataAsistencia data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AppDataAsistencia {
  List<Asistencia> asistencia;

  AppDataAsistencia({
    required this.asistencia,
  });

  factory AppDataAsistencia.fromJson(Map<String, dynamic> json) =>
      AppDataAsistencia(
        asistencia: List<Asistencia>.from(
            json["result"].map((x) => Asistencia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "asistencia": List<dynamic>.from(asistencia.map((x) => x.toJson())),
      };
}

class Asistencia {
  String id;
  String nombre;
  String paterno;
  String materno;
  // ignore: non_constant_identifier_names
  String no_empleado;
  // ignore: non_constant_identifier_names
  String fk_usuario;
  // ignore: non_constant_identifier_names
  String fecha_entrada;
  // ignore: non_constant_identifier_names
  String fecha_salida;

  Asistencia({
    required this.id,
    required this.nombre,
    required this.paterno,
    required this.materno,
    // ignore: non_constant_identifier_names
    required this.no_empleado,
    // ignore: non_constant_identifier_names
    required this.fk_usuario,
    // ignore: non_constant_identifier_names
    required this.fecha_entrada,
    // ignore: non_constant_identifier_names
    required this.fecha_salida,
  });

  factory Asistencia.fromJson(Map<String, dynamic> json) => Asistencia(
        id: json["id"],
        nombre: json["nombre"],
        paterno: json["paterno"] ?? "",
        materno: json["materno"] ?? "",
        no_empleado: json["no_empleado"] ?? "",
        fk_usuario: json["fk_usuario"] ?? "",
        fecha_entrada: json["fecha_entrada"] ?? "",
        fecha_salida: json["fecha_salida"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "paterno": paterno,
        "materno": materno,
        "no_empleado": no_empleado,
        "fk_usuario": fk_usuario,
        "fecha_entrada": fecha_entrada,
        "fecha_salida": fecha_salida,
      };
}
