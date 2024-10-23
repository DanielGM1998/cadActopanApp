import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/constants.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/side_menu.dart';

class ContactoScreen extends StatefulWidget {
  static const String routeName = 'contacto';

  final String idPaciente;

  const ContactoScreen({
    Key? key, required this.idPaciente,
  }) : super(key: key);

  @override
  State<ContactoScreen> createState() => _ContactoScreenState();
}

class _ContactoScreenState extends State<ContactoScreen> with SingleTickerProviderStateMixin {
  String? _tipoapp;
  String? _userapp;

  // Ruta local del archivo PDF
  String? localFilePath;
  bool isLoading = true;
  bool hasError = false;
  String? pdfUrl;
  bool isDownloaded = false;

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

  @override
  void initState() {
    super.initState();
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
                appBar: myAppBar(context, nameContacto),
                drawer: SideMenu(user: _userapp, tipoapp: _tipoapp, idPaciente: widget.idPaciente),
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
                    child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text("Contacto"),
                    )
                  ),
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
}