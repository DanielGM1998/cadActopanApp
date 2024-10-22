import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:dio/dio.dart';
// import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recuperacion/pages/asistencia_page.dart';
import 'package:recuperacion/pages/empleado_page.dart';
import 'package:recuperacion/pages/falta_page.dart';
import 'package:recuperacion/presentation/screens/home/home_screen.dart';
import 'package:recuperacion/pages/retardo_page.dart';
import 'package:recuperacion/pages/usuario_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddEmpleadoPage extends StatefulWidget {
  static const String routeName = 'add_empleado';

  final String tipoScreen;
  final String id;
  final String name;
  final String patern;
  final String matern;
  final String numEmp;
  final String mail;
  final String type;

  final String institucion;
  final String telefono;
  final String celular;
  final String area;
  // ignore: non_constant_identifier_names
  final String clave_foto;

  final String comment;

  const AddEmpleadoPage({
    Key? key,
    required this.tipoScreen,
    required this.id,
    required this.name,
    required this.patern,
    required this.matern,
    required this.numEmp,
    required this.mail,
    required this.type,
    required this.institucion,
    required this.telefono,
    required this.celular,
    required this.area,
    // ignore: non_constant_identifier_names
    required this.clave_foto,
    required this.comment,
  }) : super(key: key);

  @override
  State<AddEmpleadoPage> createState() => _AddEmpleadoPageState();
}

class _AddEmpleadoPageState extends State<AddEmpleadoPage> {
  String _nombre = "";
  String _paterno = "";
  String _materno = "";
  // ignore: non_constant_identifier_names
  String _no_empleado = "";
  String _email = "";
  // ignore: non_constant_identifier_names
  String _tipo_empleado = "";

  String _institucion = "";
  String _telefono = "";
  String _celular = "";
  String _area = "";
  // ignore: non_constant_identifier_names
  String _clave_foto = "";

  String _comentarios = "";

  var textController1 = TextEditingController();
  var textController2 = TextEditingController();
  var textController3 = TextEditingController();
  var textController4 = TextEditingController();
  var textController5 = TextEditingController();
  var textController6 = TextEditingController();
  var textController7 = TextEditingController();
  var textController8 = TextEditingController();

  String? _tipoapp;

  Future<bool?> getVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tipoapp = prefs.getString("tipo_app") ?? "1";
    return true;
  }

  //carga de fotos
  File? imagen;
  final picker = ImagePicker();
  Dio dio = Dio();

  cargar() async {
    // var pickerFile = await picker.pickImage(
    //     source: ImageSource.gallery, maxHeight: 240, maxWidth: 300);
    var pickerFile = await picker.pickImage(source: ImageSource.gallery);
    File? compressedFile;
    if (pickerFile != null) {
      compressedFile = await FlutterNativeImage.compressImage(pickerFile.path,
          targetWidth: 240, targetHeight: 300);
    }
    setState(() {
      if (pickerFile != null) {
        imagen = compressedFile;
      }
    });
  }

  cargarCamara() async {
    // var pickerFile = await picker.pickImage(
    //     source: ImageSource.gallery, maxHeight: 240, maxWidth: 300);
    var pickerFile = await picker.pickImage(source: ImageSource.camera);
    File? compressedFile;
    if (pickerFile != null) {
      compressedFile = await FlutterNativeImage.compressImage(pickerFile.path,
          targetWidth: 240, targetHeight: 300);
    }
    setState(() {
      if (pickerFile != null) {
        imagen = compressedFile;
      }
    });
  }

  Future<void> subirImagen(name) async {
    try {
      String filename = imagen!.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imagen!.path, filename: filename),
        'name': name
      });

      await dio.post(
              'http://dds.tecnoregistro.pro/registroAsistencia/public/fotos.php',
              data: formData)
          // .then((value) => {
          //       if (value.toString() == '1')
          //         {print("Correcto")}
          //       else
          //         {print("Fail")}
          //     })
          ;
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async => getVariables());
    textController1.text = widget.name.toString();
    textController2.text = widget.patern.toString();
    textController3.text = widget.matern.toString();
    textController4.text = widget.numEmp.toString();
    textController5.text = widget.mail.toString();
    textController6.text = widget.telefono.toString();
    textController7.text = widget.celular.toString();
    textController8.text = widget.comment.toString();

    _nombre = widget.name.toString();
    _paterno = widget.patern.toString();
    _materno = widget.matern.toString();
    _no_empleado = widget.numEmp.toString();
    _email = widget.mail.toString();
    _tipo_empleado = widget.type.toString();
    _institucion = widget.institucion.toString();
    _telefono = widget.telefono.toString();
    _celular = widget.celular.toString();

    switch (widget.area.toString()) {
      case '0':
        _area = "Ninguna";
        break;
      case '1':
        _area = "Agencia de viajes";
        break;
      case '2':
        _area = "Auditoria";
        break;
      case '3':
        _area = "Becario(a)";
        break;
      case '4':
        _area = "Conceptos México";
        break;
      case '5':
        _area = "Dirección General";
        break;
      case '6':
        _area = "División Comercial";
        break;
      case '7':
        _area = "Finanzas";
        break;
      case '8':
        _area = "In Huse Nestle";
        break;
      case '9':
        _area = "In House Pharma";
        break;
      case '10':
        _area = "In House PNUD";
        break;
      case '11':
        _area = "Nuevas Tecnológias";
        break;
      case '12':
        _area = "Operaciones";
        break;
      case '13':
        _area = "Planeación Estrategica";
        break;
      case '14':
        _area = "Presidencia";
        break;
      case '15':
        _area = "PROYEX";
        break;
      case '16':
        _area = "Rec. Humanos y Mat.";
        break;
      case '17':
        _area = "Reservaciones";
        break;
      case '18':
        _area = "Tecnoregistro";
        break;
      case '19':
        _area = "TYC Exposiciones";
        break;
      case '20':
        _area = "Visitas TYC Group";
        break;
      default:
        _area = "TEMPORAL";
    }
    // _area = widget.area.toString();

    _clave_foto = widget.clave_foto.toString();
    _comentarios = widget.comment.toString();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    int tipooEmpleado = int.parse(widget.type);
    int tipooInstitucion = int.parse(widget.institucion);
    int tipooArea = int.parse(widget.area);

    final List<String> listTipoEmpleado = [
      'Gerencia',
      'General',
    ];

    final List<String> listInstitucion = [
      'Ninguna',
      'Conceptos México',
      'PROYEX',
      'Tecnoregistro',
      'Turismo y Conveciones',
      'TYC Exposiciones'
    ];

    final List<String> listArea = [
      'Ninguna',
      'Agencia de viajes',
      'Auditoria',
      'Becario(a)',
      'Conceptos México',
      'Dirección General',
      'División Comercial',
      'Finanzas',
      'In Huse Nestle',
      'In House Pharma',
      'In House PNUD',
      'Nuevas Tecnológias',
      'Operaciones',
      'Planeación Estrategica',
      'Presidencia',
      'PROYEX',
      'Rec. Humanos y Mat.',
      'Reservaciones',
      'Tecnoregistro',
      'TYC Exposiciones',
      'Visitas TYC Group',
    ];

    return FutureBuilder(
        future: getVariables(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return WillPopScope(
              onWillPop: () async {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    barrierColor: Colors.black.withOpacity(0.6),
                    opaque: false,
                    pageBuilder: (_, __, ___) => const EmpleadoPage(),
                    transitionDuration: const Duration(milliseconds: 400),
                    transitionsBuilder: (_, animation, __, child) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10 * animation.value,
                          sigmaY: 10 * animation.value,
                        ),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
                return false;
              },
              child: Scaffold(
                  backgroundColor: Colors.white.withOpacity(1),
                  appBar: AppBar(
                      // automaticallyImplyLeading: false,
                      title: Text(
                          widget.tipoScreen == "1"
                              ? 'Editar Empleado'
                              : 'Agregar Empleado',
                          style: const TextStyle(fontSize: 20)),
                      centerTitle: true,
                      backgroundColor: const Color.fromRGBO(55, 171, 204, 1),
                      actions: <Widget>[
                        PopupMenuButton(
                            //add icon, by default "3 dot" icon
                            // icon: const Icon(Icons.format_list_numbered_rtl_sharp),
                            itemBuilder: (context) {
                          return [
                            const PopupMenuItem<int>(
                              value: 1,
                              child: Text("Cerrar sesión"),
                            ),
                          ];
                        }, onSelected: (value) {
                          if (value == 1) {
                            _onWillPop1();
                          }
                        }),
                      ]),
                  drawer: Drawer(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment(0.0, 1.3),
                          colors: <Color>[
                            Color.fromRGBO(255, 255, 255, 1.1),
                            Color.fromRGBO(55, 171, 204, 0.8),
                          ],
                          tileMode: TileMode.repeated,
                        ),
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          DrawerHeader(
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(55, 171, 204, 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/logo_drawer.png",
                                  height: 65,
                                  width: 65,
                                ),
                                const SizedBox(height: 15),
                                const Text("CAD Actopan v.1.0.1",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.home_filled),
                            iconColor: const Color.fromRGBO(55, 171, 204, 1),
                            title: const Text("Inicio"),
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  barrierColor: Colors.black.withOpacity(0.6),
                                  opaque: false,
                                  pageBuilder: (_, __, ___) =>
                                      const HomeScreen(),
                                  transitionDuration:
                                      const Duration(milliseconds: 800),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10 * animation.value,
                                        sigmaY: 10 * animation.value,
                                      ),
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          _tipoapp == '0'
                              ? ListTile(
                                  leading: const Icon(Icons.person_pin_rounded),
                                  iconColor:
                                      const Color.fromRGBO(55, 171, 204, 1),
                                  title: const Text("Empleados"),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        barrierColor:
                                            Colors.black.withOpacity(0.6),
                                        opaque: false,
                                        pageBuilder: (_, __, ___) =>
                                            const EmpleadoPage(),
                                        transitionDuration:
                                            const Duration(milliseconds: 800),
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 10 * animation.value,
                                              sigmaY: 10 * animation.value,
                                            ),
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(height: 0),
                          _tipoapp == '0'
                              ? ListTile(
                                  leading: const Icon(Icons.check_circle_sharp),
                                  iconColor:
                                      const Color.fromRGBO(55, 171, 204, 1),
                                  title: const Text("Asistencias"),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        barrierColor:
                                            Colors.black.withOpacity(0.6),
                                        opaque: false,
                                        pageBuilder: (_, __, ___) =>
                                            const AsistenciaPage(),
                                        transitionDuration:
                                            const Duration(milliseconds: 800),
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 10 * animation.value,
                                              sigmaY: 10 * animation.value,
                                            ),
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(height: 0),
                          _tipoapp == '0'
                              ? ListTile(
                                  leading: const Icon(Icons.cancel),
                                  iconColor:
                                      const Color.fromRGBO(55, 171, 204, 1),
                                  title: const Text("Faltas"),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        barrierColor:
                                            Colors.black.withOpacity(0.6),
                                        opaque: false,
                                        pageBuilder: (_, __, ___) =>
                                            const FaltaPage(),
                                        transitionDuration:
                                            const Duration(milliseconds: 400),
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 10 * animation.value,
                                              sigmaY: 10 * animation.value,
                                            ),
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(height: 0),
                          _tipoapp == '0'
                              ? ListTile(
                                  leading: const Icon(Icons.av_timer),
                                  iconColor:
                                      const Color.fromRGBO(55, 171, 204, 1),
                                  title: const Text("Retardos"),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        barrierColor:
                                            Colors.black.withOpacity(0.6),
                                        opaque: false,
                                        pageBuilder: (_, __, ___) =>
                                            const RetardoPage(),
                                        transitionDuration:
                                            const Duration(milliseconds: 400),
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 10 * animation.value,
                                              sigmaY: 10 * animation.value,
                                            ),
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(height: 0),
                          _tipoapp == '0'
                              ? ListTile(
                                  leading: const Icon(Icons.person_sharp),
                                  iconColor:
                                      const Color.fromRGBO(55, 171, 204, 1),
                                  title: const Text("Usuarios App"),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        barrierColor:
                                            Colors.black.withOpacity(0.6),
                                        opaque: false,
                                        pageBuilder: (_, __, ___) =>
                                            const UsuarioScreen(),
                                        transitionDuration:
                                            const Duration(milliseconds: 800),
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 10 * animation.value,
                                              sigmaY: 10 * animation.value,
                                            ),
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(height: 0),
                        ],
                      ),
                    ),
                  ),
                  // resizeToAvoidBottomInset: false,
                  body: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment(0.0, 1.3),
                        colors: <Color>[
                          Color.fromRGBO(55, 171, 204, 0.3),
                          Color.fromRGBO(255, 255, 255, 1.1),
                        ],
                        tileMode: TileMode.repeated,
                      ),
                    ),
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Column(
                              children: [
                                Container(
                                  height: 20,
                                  color: Colors.transparent,
                                ),
                                imagen == null
                                    ? const Center()
                                    : Container(
                                        color: Colors.grey.shade300,
                                        child: Image.file(
                                          imagen!,
                                          height: 150.0,
                                          width: 100.0,
                                        ),
                                      ),
                                imagen == null
                                    ? widget.tipoScreen == "2"
                                        ? const SizedBox(height: 0)
                                        : _clave_foto != ""
                                            ? Image.network(
                                                "http://dds.tecnoregistro.pro/registroAsistencia/public/data/empleados/" +
                                                    _clave_foto +
                                                    ".jpg?${DateTime.now().millisecondsSinceEpoch.toString()}",
                                                scale: 2,
                                              )
                                            : const SizedBox(height: 0)
                                    : const SizedBox(height: 0),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Color.fromRGBO(
                                                        55, 171, 204, 1))),
                                        onPressed: () {
                                          cargar();
                                        },
                                        child: const Text("Cargar Foto")),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Color.fromRGBO(
                                                        55, 171, 204, 1))),
                                        onPressed: () {
                                          cargarCamara();
                                        },
                                        child: const Text("Tomar Foto")),
                                  ],
                                ),
                                //////
                                Column(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: const Color.fromRGBO(
                                                      55, 171, 204, 1),
                                                ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: TextField(
                                          controller: textController1,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          cursorColor: const Color.fromRGBO(
                                              55, 171, 204, 1),
                                          onChanged: (valor) {
                                            setState(() {
                                              _nombre = valor;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              hintText: "Nombre Usuario",
                                              labelText: "Nombre",
                                              suffixIcon: Icon(
                                                Icons.account_circle_outlined,
                                                size: 30,
                                              ),
                                              icon: Icon(
                                                Icons.person,
                                              )),
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: const Color.fromRGBO(
                                                      55, 171, 204, 1),
                                                ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: TextField(
                                          controller: textController2,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          cursorColor: const Color.fromRGBO(
                                              55, 171, 204, 1),
                                          onChanged: (valor) {
                                            setState(() {
                                              _paterno = valor;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              hintText: "Apellido Paterno",
                                              labelText: "Paterno",
                                              suffixIcon: Icon(
                                                Icons.account_circle_outlined,
                                                size: 30,
                                              ),
                                              icon: Icon(
                                                Icons.person,
                                              )),
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: const Color.fromRGBO(
                                                      55, 171, 204, 1),
                                                ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: TextField(
                                          controller: textController3,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          cursorColor: const Color.fromRGBO(
                                              55, 171, 204, 1),
                                          onChanged: (valor) {
                                            setState(() {
                                              _materno = valor;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              hintText: "Apellido Materno",
                                              labelText: "Materno",
                                              suffixIcon: Icon(
                                                Icons.account_circle_outlined,
                                                size: 30,
                                              ),
                                              icon: Icon(
                                                Icons.person,
                                              )),
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: const Color.fromRGBO(
                                                      55, 171, 204, 1),
                                                ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: TextField(
                                          controller: textController4,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                              decimal: false, signed: false),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          cursorColor: const Color.fromRGBO(
                                              55, 171, 204, 1),
                                          onChanged: (valor) {
                                            setState(() {
                                              _no_empleado = valor;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              hintText: "Número de empleado",
                                              labelText: "No. empleado",
                                              suffixIcon: Icon(
                                                Icons.numbers,
                                                size: 30,
                                              ),
                                              icon: Icon(
                                                Icons.numbers_outlined,
                                              )),
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: const Color.fromRGBO(
                                                      55, 171, 204, 1),
                                                ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: TextField(
                                          controller: textController5,
                                          cursorColor: const Color.fromRGBO(
                                              55, 171, 204, 1),
                                          onChanged: (valor) {
                                            setState(() {
                                              _email = valor;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              hintText: "Correo electrónico",
                                              labelText: "Correo",
                                              suffixIcon: Icon(
                                                Icons.alternate_email,
                                                size: 30,
                                              ),
                                              icon: Icon(
                                                Icons.alternate_email_outlined,
                                              )),
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: const Color.fromRGBO(
                                                      55, 171, 204, 1),
                                                ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: TextField(
                                          controller: textController6,
                                          cursorColor: const Color.fromRGBO(
                                              55, 171, 204, 1),
                                          onChanged: (valor) {
                                            setState(() {
                                              _telefono = valor;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              hintText: "Teléfono",
                                              labelText: "Teléfono",
                                              suffixIcon: Icon(
                                                Icons.numbers_outlined,
                                                size: 30,
                                              ),
                                              icon: Icon(
                                                Icons.numbers,
                                              )),
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: const Color.fromRGBO(
                                                      55, 171, 204, 1),
                                                ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: TextField(
                                          controller: textController7,
                                          cursorColor: const Color.fromRGBO(
                                              55, 171, 204, 1),
                                          onChanged: (valor) {
                                            setState(() {
                                              _celular = valor;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              hintText: "Celular",
                                              labelText: "Celular",
                                              suffixIcon: Icon(
                                                Icons.numbers_outlined,
                                                size: 30,
                                              ),
                                              icon: Icon(
                                                Icons.numbers,
                                              )),
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: const Color.fromRGBO(
                                                      55, 171, 204, 1),
                                                ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: TextField(
                                          controller: textController8,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          cursorColor: const Color.fromRGBO(
                                              55, 171, 204, 1),
                                          onChanged: (valor) {
                                            setState(() {
                                              _comentarios = valor;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              hintText:
                                                  "Comentarios del usuario",
                                              labelText: "Comentarios",
                                              suffixIcon: Icon(
                                                Icons.co_present_outlined,
                                                size: 30,
                                              ),
                                              icon: Icon(
                                                Icons.co_present_rounded,
                                              )),
                                          textInputAction: TextInputAction.done,
                                          onSubmitted: (value) async {
                                            if (_nombre != "") {
                                              if (_no_empleado != "") {
                                                // if (_email != "") {
                                                //   bool isValid =
                                                //       EmailValidator.validate(
                                                //           _email);
                                                //   if (isValid) {

                                                var name = " ";
                                                // final dt = DateTime.now();
                                                // var random =
                                                // Random().nextInt(100);
                                                // final now =
                                                // '${dt.year}_${dt.month}_${dt.day}_${dt.hour}_${dt.minute}_${random.toString()}';
                                                final now = _no_empleado;
                                                switch (_area) {
                                                  case 'Ninguna':
                                                    name = "TEMPORAL_" +
                                                        now.toString();
                                                    break;
                                                  case 'Agencia de viajes':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'Auditoria':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'Becario(a)':
                                                    name =
                                                        "BEC_" + now.toString();
                                                    break;
                                                  case 'Conceptos México':
                                                    name =
                                                        "COM_" + now.toString();
                                                    break;
                                                  case 'Dirección General':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'División Comercial':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'Finanzas':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'In Huse Nestle':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'In House Pharma':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'In House PNUD':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'Nuevas Tecnológias':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'Operaciones':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'Planeación Estrategica':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'Presidencia':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'PROYEX':
                                                    name =
                                                        "PRO_" + now.toString();
                                                    break;
                                                  case 'Rec. Humanos y Mat.':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'Reservaciones':
                                                    name =
                                                        "TYC_" + now.toString();
                                                    break;
                                                  case 'Tecnoregistro':
                                                    name =
                                                        "TEC_" + now.toString();
                                                    break;
                                                  case 'TYC Exposiciones':
                                                    name =
                                                        "TEX_" + now.toString();
                                                    break;
                                                  case 'Visitas TYC Group':
                                                    name = "VISITA_" +
                                                        now.toString();
                                                    break;
                                                  default:
                                                    name = "TEMPORAL_" +
                                                        now.toString();
                                                    break;
                                                }

                                                showProgress(context, name);
                                                subirImagen(name);
                                                setState(() {
                                                  textController1.clear();
                                                  textController2.clear();
                                                  textController3.clear();
                                                  textController4.clear();
                                                  textController5.clear();
                                                  textController6.clear();
                                                  textController7.clear();
                                                  textController8.clear();
                                                });

                                                // print(_area + " | " + name);

                                                //   } else {
                                                //     awesomeTopSnackbar(
                                                //       context,
                                                //       "Debe ingresar un Email valido",
                                                //       textStyle: const TextStyle(
                                                //           color: Colors.white,
                                                //           fontStyle:
                                                //               FontStyle.normal,
                                                //           fontWeight:
                                                //               FontWeight.w400,
                                                //           fontSize: 20),
                                                //       backgroundColor:
                                                //           Colors.orangeAccent,
                                                //       icon: const Icon(
                                                //           Icons.check,
                                                //           color: Colors.black),
                                                //       iconWithDecoration:
                                                //           BoxDecoration(
                                                //         borderRadius:
                                                //             BorderRadius.circular(
                                                //                 20),
                                                //         border: Border.all(
                                                //             color: Colors.black),
                                                //       ),
                                                //     );
                                                //   }
                                                // } else {
                                                //   awesomeTopSnackbar(
                                                //     context,
                                                //     "Debe ingresar el Correo Electrónico",
                                                //     textStyle: const TextStyle(
                                                //         color: Colors.white,
                                                //         fontStyle:
                                                //             FontStyle.normal,
                                                //         fontWeight:
                                                //             FontWeight.w400,
                                                //         fontSize: 20),
                                                //     backgroundColor:
                                                //         Colors.orangeAccent,
                                                //     icon: const Icon(Icons.check,
                                                //         color: Colors.black),
                                                //     iconWithDecoration:
                                                //         BoxDecoration(
                                                //       borderRadius:
                                                //           BorderRadius.circular(
                                                //               20),
                                                //       border: Border.all(
                                                //           color: Colors.black),
                                                //     ),
                                                //   );
                                                // }
                                              } else {
                                                awesomeTopSnackbar(
                                                  context,
                                                  "Debe ingresar el Num. de empleado",
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 20),
                                                  backgroundColor:
                                                      Colors.orangeAccent,
                                                  icon: const Icon(Icons.check,
                                                      color: Colors.black),
                                                  iconWithDecoration:
                                                      BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color: Colors.black),
                                                  ),
                                                );
                                              }
                                            } else {
                                              awesomeTopSnackbar(
                                                context,
                                                "Debe ingresar el Nombre",
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20),
                                                backgroundColor:
                                                    Colors.orangeAccent,
                                                icon: const Icon(Icons.check,
                                                    color: Colors.black),
                                                iconWithDecoration:
                                                    BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: Colors.black),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    const Text("Institución:",
                                        style: TextStyle(fontSize: 15)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ////tipo select institucion
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: const Color.fromRGBO(
                                                      55, 171, 204, 1),
                                                ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: _size.width * 0.85,
                                            child:
                                                DropdownButtonFormField<String>(
                                              decoration: const InputDecoration(
                                                icon: Icon(
                                                  Icons.account_circle,
                                                ),
                                                border: OutlineInputBorder(),
                                              ),

                                              value: listInstitucion[
                                                  tipooInstitucion],
                                              items:
                                                  listInstitucion.map((value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value,
                                                      style: const TextStyle(
                                                          fontSize: 20)),
                                                );
                                              }).toList(),

                                              // value: "",
                                              // items: <String>[
                                              //   'General',
                                              //   'Gerecia',
                                              // ].map<DropdownMenuItem<String>>(
                                              //     (String value) {
                                              //   return DropdownMenuItem<String>(
                                              //     value: value,
                                              //     child: Text(
                                              //       value,
                                              //       style: const TextStyle(
                                              //           fontSize: 20),
                                              //     ),
                                              //   );
                                              // }).toList(),

                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _institucion = newValue!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    const Text("Área:",
                                        style: TextStyle(fontSize: 15)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ////tipo select area
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: const Color.fromRGBO(
                                                      55, 171, 204, 1),
                                                ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: _size.width * 0.85,
                                            child:
                                                DropdownButtonFormField<String>(
                                              decoration: const InputDecoration(
                                                icon: Icon(
                                                  Icons.account_circle,
                                                ),
                                                border: OutlineInputBorder(),
                                              ),

                                              value: listArea[tipooArea],
                                              items: listArea.map((value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value,
                                                      style: const TextStyle(
                                                          fontSize: 20)),
                                                );
                                              }).toList(),

                                              // value: "",
                                              // items: <String>[
                                              //   'General',
                                              //   'Gerecia',
                                              // ].map<DropdownMenuItem<String>>(
                                              //     (String value) {
                                              //   return DropdownMenuItem<String>(
                                              //     value: value,
                                              //     child: Text(
                                              //       value,
                                              //       style: const TextStyle(
                                              //           fontSize: 20),
                                              //     ),
                                              //   );
                                              // }).toList(),

                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _area = newValue!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    const Text("Tipo:",
                                        style: TextStyle(fontSize: 15)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ////tipo select tipo empleado
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: const Color.fromRGBO(
                                                      55, 171, 204, 1),
                                                ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: _size.width * 0.85,
                                            child:
                                                DropdownButtonFormField<String>(
                                              decoration: const InputDecoration(
                                                icon: Icon(
                                                  Icons.account_circle,
                                                ),
                                                border: OutlineInputBorder(),
                                              ),

                                              value: listTipoEmpleado[
                                                  tipooEmpleado],
                                              items:
                                                  listTipoEmpleado.map((value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value,
                                                      style: const TextStyle(
                                                          fontSize: 20)),
                                                );
                                              }).toList(),

                                              // value: "",
                                              // items: <String>[
                                              //   'General',
                                              //   'Gerecia',
                                              // ].map<DropdownMenuItem<String>>(
                                              //     (String value) {
                                              //   return DropdownMenuItem<String>(
                                              //     value: value,
                                              //     child: Text(
                                              //       value,
                                              //       style: const TextStyle(
                                              //           fontSize: 20),
                                              //     ),
                                              //   );
                                              // }).toList(),

                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _tipo_empleado = newValue!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 80),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                  floatingActionButton: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        showFab
                            ? FloatingActionButton(
                                heroTag: 'ok',
                                onPressed: () async {
                                  if (_nombre != "") {
                                    if (_no_empleado != "") {
                                      // if (_email != "") {
                                      var name = " ";
                                      // final dt = DateTime.now();
                                      // var random =
                                      // Random().nextInt(100);
                                      // final now =
                                      // '${dt.year}_${dt.month}_${dt.day}_${dt.hour}_${dt.minute}_${random.toString()}';
                                      final now = _no_empleado;
                                      switch (_area) {
                                        case 'Ninguna':
                                          name = "TEMPORAL_" + now.toString();
                                          break;
                                        case 'Agencia de viajes':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'Auditoria':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'Becario(a)':
                                          name = "BEC_" + now.toString();
                                          break;
                                        case 'Conceptos México':
                                          name = "COM_" + now.toString();
                                          break;
                                        case 'Dirección General':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'División Comercial':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'Finanzas':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'In Huse Nestle':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'In House Pharma':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'In House PNUD':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'Nuevas Tecnológias':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'Operaciones':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'Planeación Estrategica':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'Presidencia':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'PROYEX':
                                          name = "PRO_" + now.toString();
                                          break;
                                        case 'Rec. Humanos y Mat.':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'Reservaciones':
                                          name = "TYC_" + now.toString();
                                          break;
                                        case 'Tecnoregistro':
                                          name = "TEC_" + now.toString();
                                          break;
                                        case 'TYC Exposiciones':
                                          name = "TEX_" + now.toString();
                                          break;
                                        case 'Visitas TYC Group':
                                          name = "VISITA_" + now.toString();
                                          break;
                                        default:
                                          name = "TEMPORAL_" + now.toString();
                                          break;
                                      }

                                      showProgress(context, name);
                                      subirImagen(name);
                                      setState(() {
                                        textController1.clear();
                                        textController2.clear();
                                        textController3.clear();
                                        textController4.clear();
                                        textController5.clear();
                                        textController6.clear();
                                        textController7.clear();
                                        textController8.clear();
                                      });

                                      // print(_area + " | " + name);

                                      // } else {
                                      //   awesomeTopSnackbar(
                                      //     context,
                                      //     "Debe ingresar el Correo Electrónico",
                                      //     textStyle: const TextStyle(
                                      //         color: Colors.white,
                                      //         fontStyle: FontStyle.normal,
                                      //         fontWeight: FontWeight.w400,
                                      //         fontSize: 20),
                                      //     backgroundColor: Colors.orangeAccent,
                                      //     icon: const Icon(Icons.check,
                                      //         color: Colors.black),
                                      //     iconWithDecoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.circular(20),
                                      //       border: Border.all(color: Colors.black),
                                      //     ),
                                      //   );
                                      // }
                                    } else {
                                      awesomeTopSnackbar(
                                        context,
                                        "Debe ingresar el Num. de empleado",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20),
                                        backgroundColor: Colors.orangeAccent,
                                        icon: const Icon(Icons.check,
                                            color: Colors.black),
                                        iconWithDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                      );
                                    }
                                  } else {
                                    awesomeTopSnackbar(
                                      context,
                                      "Debe ingresar el Nombre",
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20),
                                      backgroundColor: Colors.orangeAccent,
                                      icon: const Icon(Icons.check,
                                          color: Colors.black),
                                      iconWithDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.black),
                                      ),
                                    );
                                  }
                                },
                                child: const Icon(Icons.save_outlined,
                                    color: Colors.white),
                                backgroundColor:
                                    const Color.fromRGBO(55, 171, 204, 1),
                              )
                            : const SizedBox(height: 0),
                      ])),
            );
          }
        });
  }

  Future<bool> _onWillPop1() async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Deseas cerrar sesión?'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove("user");
                  Navigator.pushReplacementNamed(context, 'login');
                },
                child: const Text('Si'),
              ),
            ],
          ),
        )) ??
        false;
  }

  showProgress(BuildContext context, String name) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(_user(name)),
    );
    return result;
  }

  Future<void> _user(name) async {
    try {
      String pat = '';
      pat = widget.tipoScreen == "1"
          ? '/registroAsistencia/public/usuario/edit/' + widget.id
          : '/registroAsistencia/public/usuario/add/';

      String claveFoto = "";
      if (widget.tipoScreen == "1") {
        if (_clave_foto == "") {
          if (imagen == null) {
            claveFoto = "";
          } else {
            claveFoto = name;
          }
        } else {
          claveFoto = _clave_foto;
        }
      }

      final response = widget.tipoScreen == "1"
          ? await http.post(
              Uri(
                scheme: 'https',
                host: 'dds.tecnoregistro.pro',
                path: pat,
              ),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Access-Control-Allow-Origin': '*'
              },
              body: jsonEncode(<String, String>{
                'nombre': _nombre.toUpperCase(),
                'paterno': _paterno.toUpperCase(),
                'materno': _materno.toUpperCase(),
                'no_empleado': _no_empleado,
                'email': _email,
                'institucion': _institucion == 'Ninguna'
                    ? "0"
                    : _institucion == 'Conceptos México'
                        ? "1"
                        : _institucion == 'PROYEX'
                            ? "2"
                            : _institucion == 'Tecnoregistro'
                                ? "3"
                                : _institucion == 'Turismo y Conveciones'
                                    ? "4"
                                    : _institucion == 'TYC Exposiciones'
                                        ? "5"
                                        : _institucion,
                'telefono': _telefono,
                'celular': _celular,
                'area': _area == 'Ninguna'
                    ? "0"
                    : _area == 'Agencia de viajes'
                        ? "1"
                        : _area == 'Auditoria'
                            ? "2"
                            : _area == 'Becario(a)'
                                ? "3"
                                : _area == 'Conceptos México'
                                    ? "4"
                                    : _area == 'Dirección General'
                                        ? "5"
                                        : _area == 'División Comercial'
                                            ? "6"
                                            : _area == 'Finanzas'
                                                ? "7"
                                                : _area == 'In Huse Nestle'
                                                    ? "8"
                                                    : _area == 'In House Pharma'
                                                        ? "9"
                                                        : _area ==
                                                                'In House PNUD'
                                                            ? "10"
                                                            : _area ==
                                                                    'Nuevas Tecnológias'
                                                                ? "11"
                                                                : _area ==
                                                                        'Operaciones'
                                                                    ? "12"
                                                                    : _area ==
                                                                            'Planeación Estrategica'
                                                                        ? "13"
                                                                        : _area ==
                                                                                'Presidencia'
                                                                            ? "14"
                                                                            : _area == 'PROYEX'
                                                                                ? "15"
                                                                                : _area == 'Rec. Humanos y Mat.'
                                                                                    ? "16"
                                                                                    : _area == 'Reservaciones'
                                                                                        ? "17"
                                                                                        : _area == 'Tecnoregistro'
                                                                                            ? "18"
                                                                                            : _area == 'TYC Exposiciones'
                                                                                                ? "19"
                                                                                                : _area == 'Visitas TYC Group'
                                                                                                    ? "20"
                                                                                                    : _area,
                'clave_foto': claveFoto,
                'comentarios': _comentarios,
                'tipo_empleado': _tipo_empleado == 'Gerencia'
                    ? "0"
                    : _tipo_empleado == 'General'
                        ? "1"
                        : _tipo_empleado,
              }),
            )
          : await http.post(
              Uri(
                scheme: 'https',
                host: 'dds.tecnoregistro.pro',
                path: pat,
              ),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Access-Control-Allow-Origin': '*'
              },
              body: jsonEncode(<String, String>{
                'nombre': _nombre.toUpperCase(),
                'paterno': _paterno.toUpperCase(),
                'materno': _materno.toUpperCase(),
                'no_empleado': _no_empleado,
                'email': _email,
                'institucion': _institucion == 'Ninguna'
                    ? "0"
                    : _institucion == 'Conceptos México'
                        ? "1"
                        : _institucion == 'PROYEX'
                            ? "2"
                            : _institucion == 'Tecnoregistro'
                                ? "3"
                                : _institucion == 'Turismo y Conveciones'
                                    ? "4"
                                    : _institucion == 'TYC Exposiciones'
                                        ? "5"
                                        : _institucion,
                'telefono': _telefono,
                'celular': _celular,
                'area': _area == 'Ninguna'
                    ? "0"
                    : _area == 'Agencia de viajes'
                        ? "1"
                        : _area == 'Auditoria'
                            ? "2"
                            : _area == 'Becario(a)'
                                ? "3"
                                : _area == 'Conceptos México'
                                    ? "4"
                                    : _area == 'Dirección General'
                                        ? "5"
                                        : _area == 'División Comercial'
                                            ? "6"
                                            : _area == 'Finanzas'
                                                ? "7"
                                                : _area == 'In Huse Nestle'
                                                    ? "8"
                                                    : _area == 'In House Pharma'
                                                        ? "9"
                                                        : _area ==
                                                                'In House PNUD'
                                                            ? "10"
                                                            : _area ==
                                                                    'Nuevas Tecnológias'
                                                                ? "11"
                                                                : _area ==
                                                                        'Operaciones'
                                                                    ? "12"
                                                                    : _area ==
                                                                            'Planeación Estrategica'
                                                                        ? "13"
                                                                        : _area ==
                                                                                'Presidencia'
                                                                            ? "14"
                                                                            : _area == 'PROYEX'
                                                                                ? "15"
                                                                                : _area == 'Rec. Humanos y Mat.'
                                                                                    ? "16"
                                                                                    : _area == 'Reservaciones'
                                                                                        ? "17"
                                                                                        : _area == 'Tecnoregistro'
                                                                                            ? "18"
                                                                                            : _area == 'TYC Exposiciones'
                                                                                                ? "19"
                                                                                                : _area == 'Visitas TYC Group'
                                                                                                    ? "20"
                                                                                                    : _area,
                'clave_foto': imagen == null ? "" : name,
                'comentarios': _comentarios,
                'tipo_empleado': _tipo_empleado == 'Gerencia'
                    ? "0"
                    : _tipo_empleado == 'General'
                        ? "1"
                        : _tipo_empleado,
              }),
            );

      if (response.statusCode == 200) {
        String body3 = utf8.decode(response.bodyBytes);
        var jsonData = jsonDecode(body3);
        if (jsonData['response'] == true) {
          HapticFeedback.heavyImpact();
          AnimatedSnackBar.material(
                  widget.tipoScreen == "1"
                      ? 'Empleado editado correctamente'
                      : 'Empleado agregado correctamente',
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition.top,
                  duration: const Duration(milliseconds: 1000))
              .show(context)
              .then((_) => setState(() {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        barrierColor: Colors.black.withOpacity(0.6),
                        opaque: false,
                        pageBuilder: (_, __, ___) => const EmpleadoPage(),
                        transitionDuration: const Duration(milliseconds: 400),
                        transitionsBuilder: (_, animation, __, child) {
                          return BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10 * animation.value,
                              sigmaY: 10 * animation.value,
                            ),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  }));
        } else {
          HapticFeedback.heavyImpact();
          awesomeTopSnackbar(
            context,
            "Ocurrio algo extraño, Vuelve a intentar",
            textStyle: const TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 20),
            backgroundColor: Colors.orangeAccent,
            icon: const Icon(Icons.check, color: Colors.black),
            iconWithDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black),
            ),
          );
        }
      } else {
        HapticFeedback.heavyImpact();
        awesomeTopSnackbar(
          context,
          "Error, verificar conexión a Internet",
          textStyle: const TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontSize: 20),
          backgroundColor: Colors.orangeAccent,
          icon: const Icon(Icons.check, color: Colors.black),
          iconWithDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black),
          ),
        );
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      awesomeTopSnackbar(
        context,
        "" + e.toString(),
        textStyle: const TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            fontSize: 20),
        backgroundColor: Colors.orangeAccent,
        icon: const Icon(Icons.check, color: Colors.black),
        iconWithDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
      );
    }
  }
}
