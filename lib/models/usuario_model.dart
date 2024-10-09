import 'dart:convert';

AppDataUsuario usuariosFirstLoadFromJson(String str) {
  final jsonData = json.decode(str);
  return AppDataUsuario.fromJson(jsonData);
}

String usuariosFirstToJson(AppDataUsuario data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AppDataUsuario {
  List<Usuario> usuario;

  AppDataUsuario({
    required this.usuario,
  });

  factory AppDataUsuario.fromJson(Map<String, dynamic> json) => AppDataUsuario(
        usuario:
            List<Usuario>.from(json["result"].map((x) => Usuario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "usuario": List<dynamic>.from(usuario.map((x) => x.toJson())),
      };
}

class Usuario {
  String id;
  String nombre;
  String paterno;
  String materno;
  String email;
  String telefono;
  // ignore: non_constant_identifier_names
  String tipo_app;
  // ignore: non_constant_identifier_names
  String ultimo_acceso;

  Usuario({
    required this.id,
    required this.nombre,
    required this.paterno,
    required this.materno,
    required this.email,
    required this.telefono,
    // ignore: non_constant_identifier_names
    required this.tipo_app,
    // ignore: non_constant_identifier_names
    required this.ultimo_acceso,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        nombre: json["nombre"],
        paterno: json["paterno"] ?? "",
        materno: json["materno"] ?? "",
        email: json["email"] ?? "",
        telefono: json["telefono"] ?? "",
        tipo_app: json["tipo_app"] ?? "",
        ultimo_acceso: json["ultimo_acceso"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "paterno": paterno,
        "materno": materno,
        "email": email,
        "telefono": telefono,
        "tipo_app": tipo_app,
        "ultimo_acceso": ultimo_acceso,
      };
}
