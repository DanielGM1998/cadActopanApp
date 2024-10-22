import 'dart:convert';
import 'dart:ui';
import 'dart:async';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:recuperacion/constants/constants.dart';
import 'package:recuperacion/models/usuario_model.dart';
import 'package:recuperacion/pages/add_usuario_page.dart';
import 'package:recuperacion/pages/asistencia_page.dart';
import 'package:recuperacion/pages/empleado_page.dart';
import 'package:recuperacion/pages/falta_page.dart';
import 'package:recuperacion/presentation/screens/home/home_screen.dart';
import 'package:recuperacion/pages/retardo_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UsuarioScreen extends StatefulWidget {
  static const String routeName = 'usuario';

  const UsuarioScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  String? _tipoapp;
  List<Usuario> results = [], originals = [];
  TextEditingController editingController = TextEditingController();

  Future<bool?> getVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tipoapp = prefs.getString("tipo_app") ?? "1";
    return true;
  }

  Future<AppDataUsuario> loadUsuarios() async {
    final response = await http.get(
        Uri(
          scheme: 'https',
          host: 'dds.tecnoregistro.pro',
          path: '/registroAsistencia/public/seg_usuario/getAll/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*'
        });
    if (response.statusCode == 200) {
      final AppDataUsuario usuariosFirstLoad =
          usuariosFirstLoadFromJson(response.body);
      return usuariosFirstLoad;
    } else {
      throw Exception('Failed to load Data');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void filterSearchResults(String query) {
    setState(() {
      results = originals
          .where((item) => (item.id +
                  " " +
                  item.nombre +
                  " " +
                  item.paterno +
                  " " +
                  item.materno +
                  " ")
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Size _size = MediaQuery.of(context).size;
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return FutureBuilder(
        future: getVariables(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                  backgroundColor: Colors.white.withOpacity(1),
                  appBar: AppBar(
                      // automaticallyImplyLeading: false,
                      title: const Text('Usuarios',
                          style: TextStyle(fontSize: 20)),
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
                  body: FutureBuilder(
                      future: loadUsuarios(),
                      builder: (BuildContext context,
                          AsyncSnapshot<AppDataUsuario> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(color: myColor,),
                          );
                        } else {
                          if (results.isEmpty) {
                            results = snapshot.data!.usuario;
                            originals = snapshot.data!.usuario;
                          }
                        }
                        return CustomRefreshIndicator(
                          builder: MaterialIndicatorDelegate(
                            builder: (context, controller) {
                              return const Icon(
                                Icons.refresh_outlined,
                                color: Colors.blue,
                                size: 30,
                              );
                            },
                          ),
                          onRefresh: () => Navigator.of(context).push(
                            PageRouteBuilder(
                              barrierColor: Colors.black.withOpacity(0.6),
                              opaque: false,
                              pageBuilder: (_, __, ___) => const UsuarioScreen(),
                              transitionDuration:
                                  const Duration(milliseconds: 800),
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
                          ),
                          child: results.isNotEmpty
                              ? Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        // inputFormatters: <TextInputFormatter>[
                                        //   FilteringTextInputFormatter.allow(
                                        //       RegExp("[0-9a-zA-Z]")),
                                        // ],
                                        onChanged: (value) => {
                                          filterSearchResults(value),
                                        },
                                        controller: editingController,
                                        decoration: const InputDecoration(
                                            labelText: 'Buscar',
                                            suffixIcon: Icon(Icons.search)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: results.length,
                                        itemBuilder: (context, index) {
                                          final Usuario usuari = results[index];
                                          final colors =
                                              Theme.of(context).colorScheme;
                                          return Dismissible(
                                            key: Key(usuari.id),
                                            background: Container(
                                                color: Colors.red,
                                                child: const Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Eliminar",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25),
                                                    ),
                                                  ],
                                                )),
                                            onDismissed: (direction) {
                                              setState(() {
                                                results.removeAt(index);

                                                _onWillPop2(
                                                    usuari.id,
                                                    usuari.nombre,
                                                    usuari.paterno);
                                              });
                                            },
                                            child: ListTile(
                                              leading: Icon(
                                                  Icons.account_box_outlined,
                                                  color: colors.primary),
                                              trailing: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: colors.primary,
                                              ),
                                              title: Text(usuari.id.toString() +
                                                  " | " +
                                                  usuari.nombre +
                                                  " " +
                                                  usuari.paterno +
                                                  " " +
                                                  usuari.materno),
                                              subtitle: Text("Email: " +
                                                  usuari.email +
                                                  "\nTelefono: " +
                                                  usuari.telefono +
                                                  "\nTipo: " +
                                                  (usuari.tipo_app == "0"
                                                      ? "Administrador"
                                                      : "General")),
                                              onTap: () {
                                                editingController.clear();
                                                results = [];
                                                // print(usuari.id);
                                                Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.6),
                                                    opaque: false,
                                                    pageBuilder: (_, __, ___) =>
                                                        AddUsuarioPage(
                                                      tipoScreen: "1",
                                                      id: usuari.id,
                                                      name: usuari.nombre,
                                                      patern: usuari.paterno,
                                                      matern: usuari.materno,
                                                      mail: usuari.email,
                                                      cellphone:
                                                          usuari.telefono,
                                                      type: usuari.tipo_app,
                                                    ),
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 800),
                                                    transitionsBuilder: (_,
                                                        animation, __, child) {
                                                      return BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                          sigmaX: 10 *
                                                              animation.value,
                                                          sigmaY: 10 *
                                                              animation.value,
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
                                              onLongPress: () {
                                                _onWillPop2(
                                                    usuari.id,
                                                    usuari.nombre,
                                                    usuari.paterno);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    showFab
                                        ? const SizedBox(
                                            height: 70,
                                          )
                                        : const SizedBox(
                                            height: 20,
                                          ),
                                  ],
                                )
                              : const Center(
                                  child: Text(
                                    'No hay usuarios',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                        );
                      }

                      // child: Container(
                      //   decoration: const BoxDecoration(
                      //     gradient: LinearGradient(
                      //       begin: Alignment.topCenter,
                      //       end: Alignment(0.0, 1.3),
                      //       colors: <Color>[
                      //         Color.fromRGBO(55, 171, 204, 0.3),
                      //         Color.fromRGBO(255, 255, 255, 1.1),
                      //       ],
                      //       tileMode: TileMode.repeated,
                      //     ),
                      //   ),
                      //   child: CustomScrollView(
                      //     physics: const BouncingScrollPhysics(),
                      //     slivers: [
                      //       SliverFillRemaining(
                      //         hasScrollBody: false,
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(left: 16, right: 16),
                      //           child: Column(children: [
                      //             Container(
                      //               height: 20,
                      //               color: Colors.transparent,
                      //             ),
                      //           ]),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                                  editingController.clear();
                                  results = [];
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      barrierColor:
                                          Colors.black.withOpacity(0.6),
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                          const AddUsuarioPage(
                                        tipoScreen: "2",
                                        id: "",
                                        name: "",
                                        patern: "",
                                        matern: "",
                                        mail: "",
                                        cellphone: "",
                                        type: "1",
                                      ),
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
                                child: const Icon(Icons.person_add_alt,
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cerrar aplicación'),
            content: const Text('¿Deseas salir de la aplicación?'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Si'),
              ),
            ],
          ),
        )) ??
        false;
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

  Future<bool> _onWillPop2(id, nombre, paterno) async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Baja Usuario'),
            content:
                Text('¿Deseas dar de baja a ' + nombre + ' ' + paterno + '?'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  showProgress(context, id);
                },
                child: const Text('Si'),
              ),
            ],
          ),
        )) ??
        false;
  }

  showProgress(BuildContext context, String id) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(_delUser(id)),
    );
    return result;
  }

  Future<void> _delUser(id) async {
    try {
      String pat = '';
      pat = '/registroAsistencia/public/seg_usuario/del/' + id;
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
        body: jsonEncode(<String, String>{}),
      );

      if (response.statusCode == 200) {
        String body3 = utf8.decode(response.bodyBytes);
        var jsonData = jsonDecode(body3);
        if (jsonData['response'] == true) {
          HapticFeedback.heavyImpact();
          AnimatedSnackBar.material('Usuario fue dado de baja correctamente',
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
        } else {
          HapticFeedback.heavyImpact();
          AnimatedSnackBar.material('Ocurrio algo extraño, Vuelve a intentar',
                  type: AnimatedSnackBarType.warning,
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
        }
      } else {
        HapticFeedback.heavyImpact();
        AnimatedSnackBar.material('Error, verificar conexión a Internet',
                type: AnimatedSnackBarType.warning,
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
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      AnimatedSnackBar.material('' + e.toString(),
              type: AnimatedSnackBarType.warning,
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
    }
  }
}
