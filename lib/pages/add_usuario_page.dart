import 'dart:convert';
import 'dart:ui';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:recuperacion/pages/asistencia_page.dart';
import 'package:recuperacion/pages/empleado_page.dart';
import 'package:recuperacion/pages/falta_page.dart';
import 'package:recuperacion/presentation/screens/home/home_screen.dart';
import 'package:recuperacion/pages/retardo_page.dart';
import 'package:recuperacion/pages/usuario_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddUsuarioPage extends StatefulWidget {
  static const String routeName = 'add_usuario';

  final String tipoScreen;
  final String id;
  final String name;
  final String patern;
  final String matern;
  final String mail;
  final String cellphone;
  final String type;

  const AddUsuarioPage({
    Key? key,
    required this.tipoScreen,
    required this.id,
    required this.name,
    required this.patern,
    required this.matern,
    required this.mail,
    required this.cellphone,
    required this.type,
  }) : super(key: key);

  @override
  State<AddUsuarioPage> createState() => _AddUsuarioPageState();
}

class _AddUsuarioPageState extends State<AddUsuarioPage> {
  String _nombre = "";
  String _paterno = "";
  String _materno = "";
  String _email = "";
  String _telefono = "";
  String _password = "";
  // ignore: non_constant_identifier_names
  String _tipo_app = "";

  var textController1 = TextEditingController();
  var textController2 = TextEditingController();
  var textController3 = TextEditingController();
  var textController4 = TextEditingController();
  var textController5 = TextEditingController();
  var textController6 = TextEditingController();

  String? _tipoapp;
  bool _passwordVisible = true;

  Future<bool?> getVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tipoapp = prefs.getString("tipo_app") ?? "1";
    return true;
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async => getVariables());
    textController1.text = widget.name.toString();
    textController2.text = widget.patern.toString();
    textController3.text = widget.matern.toString();
    textController5.text = widget.mail.toString();
    textController4.text = widget.cellphone.toString();
    // textController6.text = widget.type.toString();

    _nombre = widget.name.toString();
    _paterno = widget.patern.toString();
    _materno = widget.matern.toString();
    _email = widget.mail.toString();
    _telefono = widget.cellphone.toString();
    _tipo_app = widget.type.toString();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    int tipoo = int.parse(widget.type);

    final List<String> list = ['Administrador', 'General'];

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
                    pageBuilder: (_, __, ___) => const UsuarioScreen(),
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
                              ? 'Editar Usuario'
                              : 'Agregar Usuario',
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
                                const Text("CAD Actopan v1.0.1",
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
                                              _telefono = valor;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              hintText: "Teléfono del usuario",
                                              labelText: "Teléfono",
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
                                          controller: textController6,
                                          obscureText: _passwordVisible,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          textCapitalization:
                                              TextCapitalization.none,
                                          cursorColor: const Color.fromRGBO(
                                              55, 171, 204, 1),
                                          onChanged: (valor) {
                                            setState(() {
                                              _password = valor;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              hintText:
                                                  "Contraseña del usuario",
                                              labelText: "Contraseña",
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _passwordVisible =
                                                          !_passwordVisible;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    _passwordVisible
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    size: 30,
                                                  )),
                                              icon: const Icon(
                                                Icons.password_outlined,
                                              )),
                                          textInputAction: TextInputAction.done,
                                          onSubmitted: (value) async {
                                            if (_nombre != "") {
                                              if (_password != "" &&
                                                  _password.length > 5) {
                                                if (_email != "") {
                                                  bool isValid =
                                                      EmailValidator.validate(
                                                          _email);
                                                  if (isValid) {
                                                    showProgress(context);
                                                    setState(() {
                                                      textController1.clear();
                                                      textController2.clear();
                                                      textController3.clear();
                                                      textController4.clear();
                                                      textController5.clear();
                                                      textController6.clear();
                                                    });
                                                  } else {
                                                    awesomeTopSnackbar(
                                                      context,
                                                      "Debe ingresar un Email valido",
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 20),
                                                      backgroundColor:
                                                          Colors.orangeAccent,
                                                      icon: const Icon(
                                                          Icons.error,
                                                          color: Colors.black),
                                                      iconWithDecoration:
                                                          BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  awesomeTopSnackbar(
                                                    context,
                                                    "Debe ingresar el Correo Electrónico",
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 20),
                                                    backgroundColor:
                                                        Colors.orangeAccent,
                                                    icon: const Icon(
                                                        Icons.error,
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
                                                  "La contraseña debe incluir al menos 6 caracteres",
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 20),
                                                  backgroundColor:
                                                      Colors.orangeAccent,
                                                  icon: const Icon(Icons.error,
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
                                                icon: const Icon(Icons.error,
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
                                      height: 20,
                                    ),
                                    ////tipo select
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
                                              value: list[tipoo],
                                              items: list.map((value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value,
                                                      style: const TextStyle(
                                                          fontSize: 20)),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _tipo_app = newValue!;
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
                            ? widget.tipoScreen == "1"
                                ? FloatingActionButton(
                                    heroTag: 'ok',
                                    onPressed: () async {
                                      if (_nombre != "") {
                                        if (_email != "") {
                                          bool isValid =
                                              EmailValidator.validate(_email);
                                          if (isValid) {
                                            showProgress(context);
                                            setState(() {
                                              textController1.clear();
                                              textController2.clear();
                                              textController3.clear();
                                              textController4.clear();
                                              textController5.clear();
                                              textController6.clear();
                                            });
                                          } else {
                                            awesomeTopSnackbar(
                                              context,
                                              "Debe ingresar un Email valido",
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 20),
                                              backgroundColor:
                                                  Colors.orangeAccent,
                                              icon: const Icon(Icons.error,
                                                  color: Colors.black),
                                              iconWithDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                            );
                                          }
                                        } else {
                                          awesomeTopSnackbar(
                                            context,
                                            "Debe ingresar el Correo Electrónico",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                            backgroundColor:
                                                Colors.orangeAccent,
                                            icon: const Icon(Icons.error,
                                                color: Colors.black),
                                            iconWithDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                          backgroundColor: Colors.orangeAccent,
                                          icon: const Icon(Icons.error,
                                              color: Colors.black),
                                          iconWithDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Icon(Icons.save_outlined,
                                        color: Colors.white),
                                    backgroundColor:
                                        const Color.fromRGBO(55, 171, 204, 1),
                                  )
                                : FloatingActionButton(
                                    heroTag: 'ok',
                                    onPressed: () async {
                                      if (_nombre != "") {
                                        if (_password != "" &&
                                            _password.length > 5) {
                                          if (_email != "") {
                                            bool isValid =
                                                EmailValidator.validate(_email);
                                            if (isValid) {
                                              showProgress(context);
                                              setState(() {
                                                textController1.clear();
                                                textController2.clear();
                                                textController3.clear();
                                                textController4.clear();
                                                textController5.clear();
                                                textController6.clear();
                                              });
                                            } else {
                                              awesomeTopSnackbar(
                                                context,
                                                "Debe ingresar un Email valido",
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20),
                                                backgroundColor:
                                                    Colors.orangeAccent,
                                                icon: const Icon(Icons.error,
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
                                          } else {
                                            awesomeTopSnackbar(
                                              context,
                                              "Debe ingresar el Correo Electrónico",
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 20),
                                              backgroundColor:
                                                  Colors.orangeAccent,
                                              icon: const Icon(Icons.error,
                                                  color: Colors.black),
                                              iconWithDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                            );
                                          }
                                        } else {
                                          awesomeTopSnackbar(
                                            context,
                                            "La contraseña debe incluir al menos 6 caracteres",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                            backgroundColor:
                                                Colors.orangeAccent,
                                            icon: const Icon(Icons.error,
                                                color: Colors.black),
                                            iconWithDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                          backgroundColor: Colors.orangeAccent,
                                          icon: const Icon(Icons.error,
                                              color: Colors.black),
                                          iconWithDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border:
                                                Border.all(color: Colors.black),
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

  showProgress(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(_user()),
    );
    return result;
  }

  Future<void> _user() async {
    try {
      String pat = '';
      pat = widget.tipoScreen == "1"
          ? '/registroAsistencia/public/seg_usuario/edit/' + widget.id
          : '/registroAsistencia/public/seg_usuario/add/';
      final response = await http.post(
        Uri(
          scheme: 'https',
          host: 'dds.tecnoregistro.pro',
          path: pat,
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*'
        },
        body: _password == ""
            ? jsonEncode(<String, String>{
                'nombre': _nombre,
                'paterno': _paterno,
                'materno': _materno,
                'email': _email,
                'telefono': _telefono,
                'tipo_app': _tipo_app == 'General' ? "1" : "0",
              })
            : jsonEncode(<String, String>{
                'nombre': _nombre,
                'paterno': _paterno,
                'materno': _materno,
                'email': _email,
                'telefono': _telefono,
                'password': _password,
                'tipo_app': _tipo_app == 'General' ? "1" : "0",
              }),
      );
      if (response.statusCode == 200) {
        String body3 = utf8.decode(response.bodyBytes);
        var jsonData = jsonDecode(body3);
        if (jsonData['response'] == true) {
          HapticFeedback.heavyImpact();
          AnimatedSnackBar.material(
                  widget.tipoScreen == "1"
                      ? 'Usuario editado correctamente'
                      : 'Usuario agregado correctamente',
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition.top,
                  duration: const Duration(milliseconds: 1000))
              .show(context)
              .then((_) => setState(() {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        barrierColor: Colors.black.withOpacity(0.6),
                        opaque: false,
                        pageBuilder: (_, __, ___) => const UsuarioScreen(),
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
        } else if (jsonData['message'] == "Error, Ya esta en uso ese Email") {
          HapticFeedback.heavyImpact();
          awesomeTopSnackbar(
            context,
            "El correo electrónico ya esta en uso",
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
        '' + e.toString(),
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
