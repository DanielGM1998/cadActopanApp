import 'dart:convert';
import 'dart:ui';
import 'dart:async';

import 'package:animated_snack_bar/animated_snack_bar.dart';
// import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:recuperacion/models/empleado_model.dart';
import 'package:recuperacion/pages/add_empleado_page.dart';
import 'package:recuperacion/pages/asistencia_page.dart';
import 'package:recuperacion/pages/falta_page.dart';
import 'package:recuperacion/presentation/screens/home/home_screen.dart';
import 'package:recuperacion/pages/retardo_page.dart';
import 'package:recuperacion/pages/usuario_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EmpleadoPage extends StatefulWidget {
  static const String routeName = 'empleado';

  const EmpleadoPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EmpleadoPage> createState() => _EmpleadoPageState();
}

class _EmpleadoPageState extends State<EmpleadoPage> {
  String? _tipoapp;
  List<Empleado> results = [], originals = [];
  TextEditingController editingController = TextEditingController();

  Future<bool?> getVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tipoapp = prefs.getString("tipo_app") ?? "1";
    return true;
  }

  Future<AppData> loadEmpleados() async {
    final response = await http.get(
        Uri(
          scheme: 'https',
          host: 'dds.tecnoregistro.pro',
          path: '/registroAsistencia/public/usuario/getAll/',

          // scheme: 'http',
          // host: '192.168.1.77',
          // path: '/registroAsistencia/public/usuario/getAll/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*'
        });
    if (response.statusCode == 200) {
      final AppData empleadosFirstLoad =
          empleadosFirstLoadFromJson(response.body);
      return empleadosFirstLoad;
    } else {
      throw Exception('Failed to load Data');
    }
  }

  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void filterSearchResults(String query) {
    setState(() {
      results = originals
          .where((item) => (item.no_empleado +
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
                      title: const Text('Empleados',
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
                      future: loadEmpleados(),
                      builder: (BuildContext context,
                          AsyncSnapshot<AppData> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (results.isEmpty) {
                            results = snapshot.data!.empleado;
                            originals = snapshot.data!.empleado;
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
                              pageBuilder: (_, __, ___) => const EmpleadoPage(),
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
                                          final Empleado emplead =
                                              results[index];
                                          final colors =
                                              Theme.of(context).colorScheme;
                                          return Dismissible(
                                            key: Key(emplead.id),
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
                                                    emplead.id,
                                                    emplead.nombre,
                                                    emplead.paterno);
                                              });
                                            },
                                            child: ListTile(
                                              // leading: Icon(Icons.account_box_outlined,
                                              // color: colors.primary),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // IconButton(
                                                  //   onPressed: () {
                                                  //     _getGafete(emplead.id);
                                                  //   },
                                                  //   icon: const Icon(Icons
                                                  //       .account_box_sharp),
                                                  // ),

                                                  // IconButton(
                                                  //   onPressed: () {
                                                  //     _onWillPop4(
                                                  //         emplead.id,
                                                  //         emplead.nombre +
                                                  //             " " +
                                                  //             emplead.paterno +
                                                  //             " " +
                                                  //             emplead.materno);
                                                  //   },
                                                  //   icon: const Icon(Icons
                                                  //       .fact_check_outlined),
                                                  // ),
                                                  // IconButton(
                                                  //   onPressed: () {
                                                  //     _onWillPop3(
                                                  //         emplead.id,
                                                  //         emplead.nombre +
                                                  //             " " +
                                                  //             emplead.paterno +
                                                  //             " " +
                                                  //             emplead.materno);
                                                  //   },
                                                  //   icon: const Icon(Icons
                                                  //       .bookmark_added_outlined),
                                                  // ),
                                                  IconButton(
                                                    onPressed: () {
                                                      _onWillPop5(
                                                          emplead.id,
                                                          emplead.no_empleado,
                                                          emplead.nombre,
                                                          emplead.paterno +
                                                              " " +
                                                              emplead.materno);
                                                    },
                                                    icon: Icon(
                                                        Icons
                                                            .fact_check_rounded,
                                                        color: colors.primary),
                                                  ),
                                                  Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: colors.primary),
                                                ],
                                              ),
                                              title: Text(emplead.no_empleado
                                                      .toString() +
                                                  " | " +
                                                  emplead.nombre +
                                                  " " +
                                                  emplead.paterno +
                                                  " " +
                                                  emplead.materno),
                                              subtitle: Text(
                                                  "Días laborados: " +
                                                      emplead.dias_laborados +
                                                      "\nFaltas: " +
                                                      emplead.faltas +
                                                      "\nRetardos: " +
                                                      emplead.retardos),
                                              onTap: () {
                                                editingController.clear();
                                                results = [];
                                                // print(emplead.no_empleado);
                                                Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.6),
                                                    opaque: false,
                                                    pageBuilder: (_, __, ___) =>
                                                        AddEmpleadoPage(
                                                            tipoScreen: "1",
                                                            id: emplead
                                                                .no_empleado,
                                                            name:
                                                                emplead.nombre,
                                                            matern:
                                                                emplead.materno,
                                                            patern:
                                                                emplead.paterno,
                                                            numEmp: emplead
                                                                .no_empleado,
                                                            mail: emplead.email,
                                                            type: emplead
                                                                .tipo_empleado
                                                                .toString(),
                                                            institucion: emplead
                                                                .institucion,
                                                            telefono: emplead
                                                                .telefono,
                                                            celular:
                                                                emplead.celular,
                                                            area: emplead.area,
                                                            clave_foto: emplead
                                                                .clave_foto,
                                                            comment: emplead
                                                                .comentarios),
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
                                                    emplead.id,
                                                    emplead.nombre,
                                                    emplead.paterno);
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
                                    'No hay empleados',
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
                                          const AddEmpleadoPage(
                                              tipoScreen: "2",
                                              id: "",
                                              name: "",
                                              matern: "",
                                              patern: "",
                                              numEmp: "",
                                              mail: "",
                                              type: "1",
                                              institucion: "0",
                                              telefono: "",
                                              celular: "",
                                              area: "0",
                                              clave_foto: "",
                                              comment: ""),
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
    HapticFeedback.heavyImpact();
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Baja Empleado'),
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

  // Future<bool> _onWillPop3(id, nombre) async {
  //   String pat = '';
  //   pat = '/registroAsistencia/public/asistencia/getUltimaFalta/' + id;
  //   final response = await http.get(
  //     Uri(
  //       scheme: 'https',
  //       host: 'dds.tecnoregistro.pro',
  //       path: pat,
  //     ),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Access-Control-Allow-Origin': '*'
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     String body3 = utf8.decode(response.bodyBytes);
  //     var jsonData = jsonDecode(body3);
  //     if (jsonData['response'] == true) {
  //       HapticFeedback.heavyImpact();
  //       return (await showDialog(
  //             barrierDismissible: false,
  //             context: context,
  //             builder: (context) => AlertDialog(
  //               title: const Text('Justificar Falta'),
  //               content: Text('¿Deseas justificar falta de\n' +
  //                   nombre +
  //                   '\n' +
  //                   jsonData['result']['fecha'] +
  //                   '?'),
  //               shape: const RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(32.0))),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () => Navigator.of(context).pop(false),
  //                   child: const Text('No'),
  //                 ),
  //                 TextButton(
  //                   onPressed: () async {
  //                     showProgress2(context, id);
  //                   },
  //                   child: const Text('Si'),
  //                 ),
  //               ],
  //             ),
  //           )) ??
  //           false;
  //     } else {
  //       HapticFeedback.heavyImpact();
  //       awesomeTopSnackbar(
  //         context,
  //         "No hay faltas por justificar",
  //         textStyle: const TextStyle(
  //             color: Colors.white,
  //             fontStyle: FontStyle.normal,
  //             fontWeight: FontWeight.w400,
  //             fontSize: 20),
  //         backgroundColor: Colors.green,
  //         icon: const Icon(Icons.check, color: Colors.black),
  //         iconWithDecoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20),
  //           border: Border.all(color: Colors.black),
  //         ),
  //       );
  //     }
  //   }
  //   return false;
  // }

  // Future<bool> _onWillPop4(id, nombre) async {
  //   String pat = '';
  //   pat = '/registroAsistencia/public/asistencia/getRetardo/' + id;
  //   final response = await http.get(
  //     Uri(
  //       scheme: 'https',
  //       host: 'dds.tecnoregistro.pro',
  //       path: pat,
  //     ),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Access-Control-Allow-Origin': '*'
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     String body3 = utf8.decode(response.bodyBytes);
  //     var jsonData = jsonDecode(body3);
  //     if (jsonData['message'] > 0) {
  //       HapticFeedback.heavyImpact();
  //       return (await showDialog(
  //             barrierDismissible: false,
  //             context: context,
  //             builder: (context) => AlertDialog(
  //               title: const Text('Justificar Retardo'),
  //               content: Text('¿Deseas justificar retardo de\n' + nombre + '?'),
  //               shape: const RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(32.0))),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () => Navigator.of(context).pop(false),
  //                   child: const Text('No'),
  //                 ),
  //                 TextButton(
  //                   onPressed: () async {
  //                     showProgress3(context, id);
  //                   },
  //                   child: const Text('Si'),
  //                 ),
  //               ],
  //             ),
  //           )) ??
  //           false;
  //     } else {
  //       HapticFeedback.heavyImpact();
  //       awesomeTopSnackbar(
  //         context,
  //         "No hay retardos por justificar",
  //         textStyle: const TextStyle(
  //             color: Colors.white,
  //             fontStyle: FontStyle.normal,
  //             fontWeight: FontWeight.w400,
  //             fontSize: 20),
  //         backgroundColor: Colors.green,
  //         icon: const Icon(Icons.check, color: Colors.black),
  //         iconWithDecoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20),
  //           border: Border.all(color: Colors.black),
  //         ),
  //       );
  //     }
  //   }
  //   return false;
  // }

  Future<bool> _onWillPop5(id, noEmpleado, nombre, paterno) async {
    HapticFeedback.heavyImpact();
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Justificar faltas'),
            content: Text(
                '¿Deseas justificar faltas de ' + nombre + ' ' + paterno + '?'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(false);
                  _datePicker(id, noEmpleado);
                },
                child: const Text('Seleccionar'),
              ),
            ],
          ),
        )) ??
        false;
  }

  // Future<String> _getGafete(id) async {
  //   var url =
  //       'https://dds.tecnoregistro.pro/registroAsistencia/public/usuario/gafete/' +
  //           id;
  //   // ignore: deprecated_member_use
  //   if (await canLaunch(url)) {
  //     // ignore: deprecated_member_use
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  //   return '';
  // }

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
      pat = '/registroAsistencia/public/usuario/del/' + id;
      final response = await http.post(
        Uri(
          scheme: 'https',
          host: 'dds.tecnoregistro.pro',
          path: pat,

          // scheme: 'http',
          // host: '192.168.1.77',
          // path: '/registroAsistencia/public/usuario/del/' + id,
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
          AnimatedSnackBar.material('Empleado fue dado de baja correctamente',
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition.top,
                  duration: const Duration(milliseconds: 400))
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
          AnimatedSnackBar.material('Ocurrio algo extraño, Vuelve a intentar',
                  type: AnimatedSnackBarType.warning,
                  mobileSnackBarPosition: MobileSnackBarPosition.top,
                  duration: const Duration(milliseconds: 400))
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
        }
      } else {
        HapticFeedback.heavyImpact();
        AnimatedSnackBar.material('Error, verificar conexión a Internet',
                type: AnimatedSnackBarType.warning,
                mobileSnackBarPosition: MobileSnackBarPosition.top,
                duration: const Duration(milliseconds: 400))
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
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      AnimatedSnackBar.material('' + e.toString(),
              type: AnimatedSnackBarType.warning,
              mobileSnackBarPosition: MobileSnackBarPosition.top,
              duration: const Duration(milliseconds: 400))
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
    }
  }

  // showProgress2(BuildContext context, String id) async {
  //   var result = await showDialog(
  //     context: context,
  //     builder: (context) => FutureProgressDialog(_justificar(id)),
  //   );
  //   return result;
  // }

  // Future<void> _justificar(id) async {
  //   try {
  //     // String pat = '';
  //     // pat = '/registroAsistencia/public/asistencia/justificarFalta/' + id;
  //     final response = await http.post(
  //       Uri(
  //         // scheme: 'https',
  //         // host: 'dds.tecnoregistro.pro',
  //         // path: pat,

  //         scheme: 'http',
  //         host: '192.168.1.77',
  //         path: '/registroAsistencia/public/asistencia/justificarFalta/' + id,
  //       ),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Access-Control-Allow-Origin': '*'
  //       },
  //       body: jsonEncode(<String, String>{}),
  //     );

  //     if (response.statusCode == 200) {
  //       String body3 = utf8.decode(response.bodyBytes);
  //       var jsonData = jsonDecode(body3);
  //       if (jsonData['response'] == false) {
  //         if (jsonData['message'] == "No hay faltas por justificar") {
  //           HapticFeedback.heavyImpact();
  //           awesomeTopSnackbar(
  //             context,
  //             "No hay faltas por justificar",
  //             textStyle: const TextStyle(
  //                 color: Colors.white,
  //                 fontStyle: FontStyle.normal,
  //                 fontWeight: FontWeight.w400,
  //                 fontSize: 20),
  //             backgroundColor: Colors.green,
  //             icon: const Icon(Icons.check, color: Colors.black),
  //             iconWithDecoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(20),
  //               border: Border.all(color: Colors.black),
  //             ),
  //           );
  //         } else {
  //           HapticFeedback.heavyImpact();
  //           awesomeTopSnackbar(
  //             context,
  //             "Ocurrio algo extraño, Vuelve a intentarlo",
  //             textStyle: const TextStyle(
  //                 color: Colors.white,
  //                 fontStyle: FontStyle.normal,
  //                 fontWeight: FontWeight.w400,
  //                 fontSize: 20),
  //             backgroundColor: Colors.redAccent,
  //             icon: const Icon(Icons.error, color: Colors.black),
  //             iconWithDecoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(20),
  //               border: Border.all(color: Colors.black),
  //             ),
  //           );
  //         }
  //       } else {
  //         HapticFeedback.heavyImpact();
  //         awesomeTopSnackbar(
  //           context,
  //           "Se ha justificado la falta",
  //           textStyle: const TextStyle(
  //               color: Colors.white,
  //               fontStyle: FontStyle.normal,
  //               fontWeight: FontWeight.w400,
  //               fontSize: 20),
  //           backgroundColor: Colors.green,
  //           icon: const Icon(Icons.check, color: Colors.black),
  //           iconWithDecoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             border: Border.all(color: Colors.black),
  //           ),
  //         );
  //       }
  //     } else {
  //       HapticFeedback.heavyImpact();
  //       awesomeTopSnackbar(
  //         context,
  //         "No hay faltas por justificar",
  //         textStyle: const TextStyle(
  //             color: Colors.white,
  //             fontStyle: FontStyle.normal,
  //             fontWeight: FontWeight.w400,
  //             fontSize: 20),
  //         backgroundColor: Colors.green,
  //         icon: const Icon(Icons.check, color: Colors.black),
  //         iconWithDecoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20),
  //           border: Border.all(color: Colors.black),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     HapticFeedback.heavyImpact();
  //     AnimatedSnackBar.material('' + e.toString(),
  //             type: AnimatedSnackBarType.warning,
  //             mobileSnackBarPosition: MobileSnackBarPosition.top,
  //             duration: const Duration(milliseconds: 400))
  //         .show(context)
  //         .then((_) => setState(() {
  //               Navigator.of(context).push(
  //                 PageRouteBuilder(
  //                   barrierColor: Colors.black.withOpacity(0.6),
  //                   opaque: false,
  //                   pageBuilder: (_, __, ___) => const EmpleadoPage(),
  //                   transitionDuration: const Duration(milliseconds: 400),
  //                   transitionsBuilder: (_, animation, __, child) {
  //                     return BackdropFilter(
  //                       filter: ImageFilter.blur(
  //                         sigmaX: 10 * animation.value,
  //                         sigmaY: 10 * animation.value,
  //                       ),
  //                       child: FadeTransition(
  //                         opacity: animation,
  //                         child: child,
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               );
  //             }));
  //   }
  // }

  // showProgress3(BuildContext context, String id) async {
  //   var result = await showDialog(
  //     context: context,
  //     builder: (context) => FutureProgressDialog(_retardo(id)),
  //   );
  //   return result;
  // }

  // Future<void> _retardo(id) async {
  //   try {
  //     // String pat = '';
  //     // pat = '/registroAsistencia/public/asistencia/justificarRetardo/' + id;
  //     final response = await http.post(
  //       Uri(
  //         // scheme: 'https',
  //         // host: 'dds.tecnoregistro.pro',
  //         // path: pat,

  //         scheme: 'http',
  //         host: '192.168.1.77',
  //         path: '/registroAsistencia/public/asistencia/justificarRetardo/' + id,
  //       ),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Access-Control-Allow-Origin': '*'
  //       },
  //       body: jsonEncode(<String, String>{}),
  //     );

  //     if (response.statusCode == 200) {
  //       String body3 = utf8.decode(response.bodyBytes);
  //       var jsonData = jsonDecode(body3);
  //       if (jsonData['response'] == false) {
  //         if (jsonData['message'] ==
  //             "Ocurrio algo extraño, vuelve a intentarlo") {
  //           HapticFeedback.heavyImpact();
  //           AnimatedSnackBar.material(
  //                   'Ocurrio algo extraño, vuelve a intentarlo',
  //                   type: AnimatedSnackBarType.warning,
  //                   mobileSnackBarPosition: MobileSnackBarPosition.top,
  //                   duration: const Duration(milliseconds: 400))
  //               .show(context)
  //               .then((_) => setState(() {
  //                     Navigator.of(context).push(
  //                       PageRouteBuilder(
  //                         barrierColor: Colors.black.withOpacity(0.6),
  //                         opaque: false,
  //                         pageBuilder: (_, __, ___) => const EmpleadoPage(),
  //                         transitionDuration: const Duration(milliseconds: 400),
  //                         transitionsBuilder: (_, animation, __, child) {
  //                           return BackdropFilter(
  //                             filter: ImageFilter.blur(
  //                               sigmaX: 10 * animation.value,
  //                               sigmaY: 10 * animation.value,
  //                             ),
  //                             child: FadeTransition(
  //                               opacity: animation,
  //                               child: child,
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     );
  //                   }));
  //         }
  //       } else {
  //         HapticFeedback.heavyImpact();
  //         AnimatedSnackBar.material('Se ha justificado el retardo',
  //                 type: AnimatedSnackBarType.success,
  //                 mobileSnackBarPosition: MobileSnackBarPosition.top,
  //                 duration: const Duration(milliseconds: 400))
  //             .show(context)
  //             .then((_) => setState(() {
  //                   Navigator.of(context).push(
  //                     PageRouteBuilder(
  //                       barrierColor: Colors.black.withOpacity(0.6),
  //                       opaque: false,
  //                       pageBuilder: (_, __, ___) => const EmpleadoPage(),
  //                       transitionDuration: const Duration(milliseconds: 400),
  //                       transitionsBuilder: (_, animation, __, child) {
  //                         return BackdropFilter(
  //                           filter: ImageFilter.blur(
  //                             sigmaX: 10 * animation.value,
  //                             sigmaY: 10 * animation.value,
  //                           ),
  //                           child: FadeTransition(
  //                             opacity: animation,
  //                             child: child,
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   );
  //                 }));
  //       }
  //     } else {
  //       HapticFeedback.heavyImpact();
  //       AnimatedSnackBar.material('Error, verificar conexión a Internet',
  //               type: AnimatedSnackBarType.warning,
  //               mobileSnackBarPosition: MobileSnackBarPosition.top,
  //               duration: const Duration(milliseconds: 400))
  //           .show(context)
  //           .then((_) => setState(() {
  //                 Navigator.of(context).push(
  //                   PageRouteBuilder(
  //                     barrierColor: Colors.black.withOpacity(0.6),
  //                     opaque: false,
  //                     pageBuilder: (_, __, ___) => const EmpleadoPage(),
  //                     transitionDuration: const Duration(milliseconds: 400),
  //                     transitionsBuilder: (_, animation, __, child) {
  //                       return BackdropFilter(
  //                         filter: ImageFilter.blur(
  //                           sigmaX: 10 * animation.value,
  //                           sigmaY: 10 * animation.value,
  //                         ),
  //                         child: FadeTransition(
  //                           opacity: animation,
  //                           child: child,
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 );
  //               }));
  //     }
  //   } catch (e) {
  //     HapticFeedback.heavyImpact();
  //     AnimatedSnackBar.material('' + e.toString(),
  //             type: AnimatedSnackBarType.warning,
  //             mobileSnackBarPosition: MobileSnackBarPosition.top,
  //             duration: const Duration(milliseconds: 400))
  //         .show(context)
  //         .then((_) => setState(() {
  //               Navigator.of(context).push(
  //                 PageRouteBuilder(
  //                   barrierColor: Colors.black.withOpacity(0.6),
  //                   opaque: false,
  //                   pageBuilder: (_, __, ___) => const EmpleadoPage(),
  //                   transitionDuration: const Duration(milliseconds: 400),
  //                   transitionsBuilder: (_, animation, __, child) {
  //                     return BackdropFilter(
  //                       filter: ImageFilter.blur(
  //                         sigmaX: 10 * animation.value,
  //                         sigmaY: 10 * animation.value,
  //                       ),
  //                       child: FadeTransition(
  //                         opacity: animation,
  //                         child: child,
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               );
  //             }));
  //   }
  // }

  _datePicker(id, noEmpleado) async {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    const weekendTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    const anniversaryTextStyle = TextStyle(
      color: Color.fromRGBO(55, 171, 204, 1),
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: const Color.fromRGBO(55, 171, 204, 1),
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Color.fromRGBO(55, 171, 204, 1),
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // color: isSelected == true
                        //     ? Colors.white
                        //     : Colors.grey[500],
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    final values = await showCalendarDatePicker2Dialog(
      context: context,
      config: config,
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
      value: _dialogCalendarPickerValue,
      dialogBackgroundColor: Colors.white,
    );
    String inicio = '', fin = '';
    if (values != null) {
      // print(_getValueText(config.calendarType, values));
      // print(_getValueText2(config.calendarType, values));
      inicio = _getValueText(config.calendarType, values);
      fin = _getValueText2(config.calendarType, values);
      setState(() {
        _dialogCalendarPickerValue = values;
        showProgress4(context, id, noEmpleado, inicio, fin);
        // print(inicio);
        // print(fin);
      });
    }
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        // final endDate = values.length > 1
        //     ? values[1].toString().replaceAll('00:00:00.000', '')
        //     : 'null';
        // valueText = '$startDate to $endDate';
        valueText = startDate;
      } else {
        return 'null';
      }
    }
    return valueText;
  }

  String _getValueText2(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        // final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = endDate;
      } else {
        return 'null';
      }
    }
    return valueText;
  }

  showProgress4(BuildContext context, String id, String noEmpleado,
      String inicio, String fin) async {
    var result = await showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(justificar(id, noEmpleado, inicio, fin)),
    );
    return result;
  }

  Future<void> justificar(id, noEmpleado, inicio, fin) async {
    try {
      String pat = '';
      pat = '/registroAsistencia/public/asistencia/justificarFaltasByDate/' +
          id +
          '/' +
          noEmpleado +
          '/' +
          inicio +
          '/' +
          fin;
      final response = await http.post(
        Uri(
          scheme: 'https',
          host: 'dds.tecnoregistro.pro',
          path: pat,

          // scheme: 'http',
          // host: '192.168.1.77',
          // path:
          //     '/registroAsistencia/public/asistencia/justificarFaltasByDate/' +
          //         id +
          //         '/' +
          //         noEmpleado +
          //         '/' +
          //         inicio +
          //         '/' +
          //         fin,
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
        if (jsonData['response'] == false) {
          if (jsonData['message'] ==
              "Ocurrio algo extraño, vuelve a intentarlo") {
            HapticFeedback.heavyImpact();
            AnimatedSnackBar.material(
                    'Ocurrio algo extraño, vuelve a intentarlo',
                    type: AnimatedSnackBarType.warning,
                    mobileSnackBarPosition: MobileSnackBarPosition.top,
                    duration: const Duration(milliseconds: 400))
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
          } else if (jsonData['message'] == "No hay faltas por justificar") {
            HapticFeedback.heavyImpact();
            AnimatedSnackBar.material('No hay faltas por justificar',
                    type: AnimatedSnackBarType.warning,
                    mobileSnackBarPosition: MobileSnackBarPosition.top,
                    duration: const Duration(milliseconds: 400))
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
          }
        } else {
          HapticFeedback.heavyImpact();
          AnimatedSnackBar.material('Se han justificado las faltas',
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition.top,
                  duration: const Duration(milliseconds: 400))
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
        }
      } else {
        HapticFeedback.heavyImpact();
        AnimatedSnackBar.material('Error, verificar conexión a Internet',
                type: AnimatedSnackBarType.warning,
                mobileSnackBarPosition: MobileSnackBarPosition.top,
                duration: const Duration(milliseconds: 400))
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
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      AnimatedSnackBar.material('' + e.toString(),
              type: AnimatedSnackBarType.warning,
              mobileSnackBarPosition: MobileSnackBarPosition.top,
              duration: const Duration(milliseconds: 400))
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
    }
  }
}
