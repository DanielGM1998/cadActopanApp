import 'dart:convert';
import 'dart:ui';
import 'dart:async';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:recuperacion/pages/asistencia_page.dart';
import 'package:recuperacion/pages/empleado_page.dart';
import 'package:recuperacion/presentation/screens/home/home_screen.dart';
import 'package:recuperacion/pages/retardo_page.dart';
import 'package:recuperacion/presentation/screens/users/usuario_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FaltaPage extends StatefulWidget {
  static const String routeName = 'falta';

  const FaltaPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FaltaPage> createState() => _FaltaPageState();
}

class _FaltaPageState extends State<FaltaPage> {
  String? _tipoapp;

  Future<bool?> getVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tipoapp = prefs.getString("tipo_app") ?? "1";
    return true;
  }

  //http list
  int page = 0;
  final int limit = 1000;
  String? busqueda;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;
  bool isLoadMoreRunning = false;
  late ScrollController controller;
  List items = [];
  var controller2 = TextEditingController();

  void fistLoad() async {
    setState(() {
      isFirstLoadRunning = true;
    });

    try {
      var res = await http.post(
        Uri(
          // scheme: 'http',
          // host: '192.168.1.77',
          // path: '/registroAsistencia/public/asistencia/getAllFaltas2/',
          scheme: 'https',
          host: 'dds.tecnoregistro.pro',
          path: '/registroAsistencia/public/asistencia/getAllFaltas2/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*'
        },
        body: jsonEncode(<String, String>{
          "pagina": page.toString(),
          "limite": limit.toString(),
          "busqueda": busqueda ?? "",
        }),
      );
      setState(() {
        items = json.decode(res.body);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Something when wront');
      }
    }

    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false) {
      setState(() {
        isLoadMoreRunning = true;
      });

      page += 1;

      try {
        var res = await http.post(
          Uri(
            // scheme: 'http',
            // host: '192.168.1.77',
            // path: '/registroAsistencia/public/asistencia/getAllFaltas2/',
            scheme: 'https',
            host: 'dds.tecnoregistro.pro',
            path: '/registroAsistencia/public/asistencia/getAllFaltas2/',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Access-Control-Allow-Origin': '*'
          },
          body: jsonEncode(<String, String>{
            "pagina": page.toString(),
            "limite": limit.toString(),
            "busqueda": busqueda ?? "",
          }),
        );
        final List newItems = jsonDecode(res.body);

        if (newItems.isNotEmpty) {
          setState(() {
            items.addAll(newItems);
          });
        } else {
          setState(() {
            hasNextPage = false;
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Something when wront');
        }
      }

      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fistLoad();
    controller = ScrollController()..addListener(loadMore);
  }

  @override
  Widget build(BuildContext context) {
    // final Size _size = MediaQuery.of(context).size;
    // final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    final colors = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: getVariables(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  // automaticallyImplyLeading: false,
                  title: const Text('Faltas', style: TextStyle(fontSize: 20)),
                  centerTitle: true,
                  backgroundColor: const Color.fromRGBO(55, 171, 204, 1),
                  actions: <Widget>[
                    PopupMenuButton(
                        color: const Color.fromRGBO(55, 171, 204, 1),
                        //add icon, by default "3 dot" icon
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem<int>(
                              value: 1,
                              child: Text("Cerrar sesión"),
                            ),
                          ];
                        },
                        onSelected: (value) {
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
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(255, 255, 255, 0.5),
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
                              pageBuilder: (_, __, ___) => const HomeScreen(),
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
                          );
                        },
                      ),
                      _tipoapp == '0'
                          ? ListTile(
                              leading: const Icon(Icons.person_pin_rounded),
                              iconColor: const Color.fromRGBO(55, 171, 204, 1),
                              title: const Text("Empleados"),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    barrierColor: Colors.black.withOpacity(0.6),
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
                              iconColor: const Color.fromRGBO(55, 171, 204, 1),
                              title: const Text("Asistencias"),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    barrierColor: Colors.black.withOpacity(0.6),
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
                              iconColor: const Color.fromRGBO(55, 171, 204, 1),
                              title: const Text("Faltas"),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    barrierColor: Colors.black.withOpacity(0.6),
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
                              iconColor: const Color.fromRGBO(55, 171, 204, 1),
                              title: const Text("Retardos"),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    barrierColor: Colors.black.withOpacity(0.6),
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
                              iconColor: const Color.fromRGBO(55, 171, 204, 1),
                              title: const Text("Usuarios App"),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    barrierColor: Colors.black.withOpacity(0.6),
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
              body: CustomRefreshIndicator(
                builder: MaterialIndicatorDelegate(
                  builder: (context, controller) {
                    return const Icon(
                      Icons.refresh_outlined,
                      color: Color.fromRGBO(55, 171, 204, 1),
                      size: 30,
                    );
                  },
                ),
                onRefresh: () async {
                  controller2.clear();
                  busqueda = "";
                  items = [];
                  page = 0;
                  fistLoad();
                  controller = ScrollController()..addListener(loadMore);
                  final result = setState(() {});
                  return result;
                },
                child: isFirstLoadRunning
                    ? const Center(child: CircularProgressIndicator())
                    : Column(children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 20),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  // inputFormatters: <TextInputFormatter>[
                                  //   FilteringTextInputFormatter.allow(
                                  //       RegExp("[0-9a-zA-Z]")),
                                  // ],
                                  controller: controller2,
                                  onChanged: (value) => {
                                    busqueda = value,
                                    items = [],
                                  },
                                  onSubmitted: (value) {
                                    items = [];
                                    page = 0;
                                    fistLoad();
                                    controller = ScrollController()
                                      ..addListener(loadMore);
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Buscar',
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          if (busqueda != "") {
                                            controller2.clear();
                                            busqueda = "";
                                            items = [];
                                            page = 0;
                                            fistLoad();
                                            controller = ScrollController()
                                              ..addListener(loadMore);
                                            setState(() {});
                                          }
                                        },
                                        icon: const Icon(Icons.clear)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton.outlined(
                                  onPressed: () {
                                    items = [];
                                    page = 0;
                                    fistLoad();
                                    controller = ScrollController()
                                      ..addListener(loadMore);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.search))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: ListView.builder(
                          controller: controller,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.person_2_outlined,
                                        color: colors.primary),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _onWillPop2(
                                                items[index]['id'].toString(),
                                                items[index]['nombre'] +
                                                    " " +
                                                    items[index]['paterno'] +
                                                    " " +
                                                    items[index]['materno'],
                                                items[index]['no_empleado'],
                                                items[index]['fecha']
                                                    .substring(0, 10),
                                                items[index]['fk_usuario']);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: colors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      items[index]['no_empleado'].toString() +
                                          ' | ' +
                                          items[index]['nombre'] +
                                          ' ' +
                                          items[index]['paterno'] +
                                          ' ' +
                                          items[index]['materno'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.7),
                                    ),
                                    subtitle: Text(
                                        "Fecha: " +
                                            items[index]['fecha']
                                                .substring(0, 10),
                                        style: const TextStyle(fontSize: 14)),
                                    onTap: () {},
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 0.1,
                                    indent: 20,
                                    endIndent: 20,
                                    color: colors.onPrimaryContainer,
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
                        if (isLoadMoreRunning == true)
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Center(child: CircularProgressIndicator()),
                          )
                      ]),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const SizedBox(height: 0, width: 0);
      },
    );
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
                child: const Text('No',
                    style: TextStyle(color: Color.fromRGBO(55, 171, 204, 1))),
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
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No',
                    style: TextStyle(color: Color.fromRGBO(55, 171, 204, 1))),
              ),
              ElevatedButton(
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

  Future<bool> _onWillPop2(id, nombre, noEmpleado, fecha, fkUsuario) async {
    HapticFeedback.heavyImpact();
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Justificar Falta'),
            content: Text('¿Deseas justificar falta de\n' +
                nombre +
                // '\n' +
                // jsonData['result']['fecha'] +
                '?'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No',
                    style: TextStyle(color: Color.fromRGBO(55, 171, 204, 1))),
              ),
              ElevatedButton(
                onPressed: () async {
                  showProgress2(context, id, noEmpleado, fecha, fkUsuario);
                },
                child: const Text('Si'),
              ),
            ],
          ),
        )) ??
        false;
  }

  showProgress2(BuildContext context, String id, String noEmpleado,
      String fecha, String fkUsuario) async {
    var result = await showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(_justificar(id, noEmpleado, fecha, fkUsuario)),
    );
    return result;
  }

  Future<void> _justificar(id, noEmpleado, fecha, fkUsuario) async {
    try {
      String pat = '';
      pat = '/registroAsistencia/public/asistencia/justificarFalta/' +
          id +
          '/' +
          noEmpleado +
          '/' +
          fecha +
          '/' +
          fkUsuario;
      final response = await http.post(
        Uri(
          scheme: 'https',
          host: 'dds.tecnoregistro.pro',
          path: pat,
          // scheme: 'http',
          // host: '192.168.1.77',
          // path: pat,
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
          if (jsonData['message'] == "No hay faltas por justificar") {
            HapticFeedback.heavyImpact();
            awesomeTopSnackbar(
              context,
              "No hay faltas por justificar",
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontSize: 20),
              backgroundColor: Colors.green,
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
              "Ocurrio algo extraño, Vuelve a intentarlo",
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontSize: 20),
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.error, color: Colors.black),
              iconWithDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
              ),
            );
          }
        } else {
          HapticFeedback.heavyImpact();
          AnimatedSnackBar.material('Se ha justificado la falta',
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition.top,
                  duration: const Duration(milliseconds: 200))
              .show(context)
              .then((_) => setState(() {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        barrierColor: Colors.black.withOpacity(0.6),
                        opaque: false,
                        pageBuilder: (_, __, ___) => const FaltaPage(),
                        transitionDuration: const Duration(milliseconds: 200),
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
        awesomeTopSnackbar(
          context,
          "Ocurrio algo extraño, Vuelve a intentarlo",
          textStyle: const TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontSize: 20),
          backgroundColor: Colors.redAccent,
          icon: const Icon(Icons.error, color: Colors.black),
          iconWithDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black),
          ),
        );
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
                    pageBuilder: (_, __, ___) => const FaltaPage(),
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
