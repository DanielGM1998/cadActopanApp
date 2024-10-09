import 'dart:convert';

AppData empleadosFirstLoadFromJson(String str) {
  final jsonData = json.decode(str);
  return AppData.fromJson(jsonData);
}

String empleadosFirstToJson(AppData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AppData {
  List<Empleado> empleado;

  AppData({
    required this.empleado,
  });

  factory AppData.fromJson(Map<String, dynamic> json) => AppData(
        empleado: List<Empleado>.from(
            json["result"].map((x) => Empleado.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "empleado": List<dynamic>.from(empleado.map((x) => x.toJson())),
      };
}

class Empleado {
  String id;
  String nombre;
  String paterno;
  String materno;
  // ignore: non_constant_identifier_names
  String no_empleado;
  String email;
  // ignore: non_constant_identifier_names
  String tipo_empleado;
  String institucion;
  String telefono;
  String celular;
  String area;
  // ignore: non_constant_identifier_names
  String clave_foto;
  String comentarios;
  // ignore: non_constant_identifier_names
  String dias_laborados;
  String faltas;
  String retardos;

  Empleado({
    required this.id,
    required this.nombre,
    required this.paterno,
    required this.materno,
    // ignore: non_constant_identifier_names
    required this.no_empleado,
    required this.email,
    // ignore: non_constant_identifier_names
    required this.tipo_empleado,
    required this.comentarios,
    required this.institucion,
    required this.telefono,
    required this.celular,
    required this.area,
    // ignore: non_constant_identifier_names
    required this.clave_foto,
    // ignore: non_constant_identifier_names
    required this.dias_laborados,
    required this.faltas,
    required this.retardos,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) => Empleado(
        id: json["id"],
        nombre: json["nombre"],
        paterno: json["paterno"] ?? "",
        materno: json["materno"] ?? "",
        no_empleado: json["no_empleado"] ?? "",
        email: json["email"] ?? "",
        tipo_empleado: json["tipo_empleado"] ?? "",
        institucion: json["institucion"] ?? "",
        telefono: json["telefono"] ?? "",
        celular: json["celular"] ?? "",
        area: json["area"] ?? "",
        clave_foto: json["clave_foto"] ?? "",
        comentarios: json["comentarios"] ?? "",
        dias_laborados: json["dias_laborados"],
        faltas: json["faltas"],
        retardos: json["retardos"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "paterno": paterno,
        "materno": materno,
        "no_empleado": no_empleado,
        "email": email,
        "tipo_empleado": tipo_empleado,
        "institucion": institucion,
        "telefono": telefono,
        "celular": celular,
        "area": area,
        "clave_foto": clave_foto,
        "comentarios": comentarios,
        "dias_laborados": dias_laborados,
        "faltas": faltas,
        "retardos": retardos,
      };
}
