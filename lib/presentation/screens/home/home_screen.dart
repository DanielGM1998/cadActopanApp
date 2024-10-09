import 'dart:async';
import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:recuperacion/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/side_menu.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'inicio';

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String? _tipoapp;
  String? _userapp;

  final _key = GlobalKey<ExpandableFabState>();

  Future<bool?> getVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tipoapp = prefs.getString("tipo_app");
    _userapp = prefs.getString("user");
    return false;
  }

  final colors = <Color>[
    const Color.fromRGBO(255, 255, 255, 1.1),
    const Color.fromRGBO(55, 171, 204, 0.8),
  ];

  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 15)),
  ];

  final List<Map<String, dynamic>> modulos = [
    {'nombre': 'Glucosa', 'icono': Icons.person, 'color': Colors.green},
    {'nombre': 'Presión Arterial', 'icono': Icons.settings, 'color': Colors.yellow},
    {'nombre': 'Receta', 'icono': Icons.bar_chart, 'color': Colors.red},
    {'nombre': 'Laboratorios', 'icono': Icons.message, 'color': Colors.deepPurple},
    {'nombre': 'Alimentación', 'icono': Icons.calendar_today, 'color': Colors.orange},
    {'nombre': 'Pendientes', 'icono': Icons.calendar_today, 'color': Colors.blue},
    {'nombre': 'Pendientes2', 'icono': Icons.calendar_today, 'color': Colors.blueGrey},
    {'nombre': 'Pendientes3', 'icono': Icons.calendar_today, 'color': Colors.lime},
  ];

  @override
  void initState() {
    super.initState();
    /* WidgetsBinding.instance
        .addPostFrameCallback((_) async => { // accesoController.text = _acceso!// }); */
  }

  @override
  Widget build(BuildContext context) {
    //final Size _size = MediaQuery.of(context).size;
    //final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return FutureBuilder(
      future: getVariables(),
      builder: (context, snapshot) {
        if (snapshot.data == false) {
          
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
                backgroundColor: Colors.white.withOpacity(1),
                appBar: AppBar(
                elevation: 1,
                shadowColor: myColor,
                // automaticallyImplyLeading: false,
                centerTitle: true,
                backgroundColor: Colors.white,
                title: const Text(nameVersion,
                    style: TextStyle(color: myColor)),
                actions: <Widget>[
                  PopupMenuButton(
                      color: Colors.white,
                      icon: const Icon(Icons.more_vert_outlined,
                          color: myColor),
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem<int>(
                            value: 1,
                            child: Text("Cerrar sesión",
                                style: TextStyle(
                                    color: myColor)),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        if (value == 1) {
                          _onWillPop1();
                        }
                        // else if (value == 2) {
                        //   _onWillPop2();
                        // }
                      }),
                  ],
                ),
                drawer: SideMenu(user: _userapp, tipoapp: _tipoapp),
                resizeToAvoidBottomInset: false,
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: const Alignment(0.0, 1.3),
                      colors: colors,
                      tileMode: TileMode.repeated,
                    ),
                  ),
                  child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: modulos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              print("Seleccionaste: ${modulos[index]['nombre']}");
                            },
                            child: Stack(
                              children: [
                                ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                    child: Container(
                                      height: 100.0,
                                      margin: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.white24.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(20),                                        
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      Container(
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: modulos[index]['color'],
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Icon(
                                          modulos[index]['icono'],
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        modulos[index]['nombre'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ); 
                    },
                  ),
                  )
                ),
                floatingActionButtonLocation: ExpandableFab.location,
                floatingActionButton: ExpandableFab(
                  key: _key,
                  type: ExpandableFabType.up,
                  childrenAnimation: ExpandableFabAnimation.none,
                  distance: 70,
                  overlayStyle: ExpandableFabOverlayStyle(
                    color: Colors.black.withOpacity(0.7),
                  ),
                  children: [
                    Row(
                      children: [
                        const Text('Cena', style: TextStyle(fontSize: 20, color: myColor)),
                        const SizedBox(width: 20),
                        FloatingActionButton.small(
                          heroTag: null,
                          backgroundColor: const Color.fromRGBO(55, 171, 204, 1), // Color de fondo del botón
                          onPressed: () {
                            print("cena");
                          },
                          child: const Icon(Icons.mode_night_outlined),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Comida', style: TextStyle(fontSize: 20, color: myColor)),
                        const SizedBox(width: 20),
                        FloatingActionButton.small(
                          heroTag: null,
                          backgroundColor: const Color.fromRGBO(55, 171, 204, 1), // Color de fondo del botón
                          onPressed: () {
                            print("comida");
                          },
                          child: const Icon(Icons.dinner_dining_outlined),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Desayuno', style: TextStyle(fontSize: 20, color: myColor)),
                        const SizedBox(width: 20),
                        FloatingActionButton.small(
                          heroTag: null,
                          backgroundColor: const Color.fromRGBO(55, 171, 204, 1), // Color de fondo del botón
                          onPressed: () {
                            print("desayuno");
                          },
                          child: const Icon(Icons.free_breakfast),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Ayuno', style: TextStyle(fontSize: 20, color: myColor)),
                        const SizedBox(width: 20),
                        FloatingActionButton.small(
                          heroTag: null,
                          backgroundColor: const Color.fromRGBO(55, 171, 204, 1), // Color de fondo del botón
                          onPressed: () {
                            print("ayuno");
                          },
                          child: const Icon(Icons.wb_sunny_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          );
        } else if (snapshot.data == true) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const SizedBox(height: 0, width: 0);
          }
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

  _datePicker() async {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    const weekendTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
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
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
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
      inicio = _getValueText(config.calendarType, values);
      fin = _getValueText2(config.calendarType, values);
      setState(() {
        _dialogCalendarPickerValue = values;
        _getExcel(inicio, fin);
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

  Future<String> _getExcel(inicio, fin) async {
    var url =
        'https://dds.tecnoregistro.pro/registroAsistencia/public/asistencia/getExcel/' +
            // 'https://192.168.1.77/registroAsistencia/public/asistencia/getExcel/' +
            inicio +
            "/" +
            fin;
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    return '';
  }
}