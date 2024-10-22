import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants/constants.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/side_menu.dart';

class RecetaScreen extends StatefulWidget {
  static const String routeName = 'receta';

  final String idPaciente;
  final String idReceta;

  const RecetaScreen({
    Key? key, required this.idPaciente, required this.idReceta,
  }) : super(key: key);

  @override
  State<RecetaScreen> createState() => _RecetaScreenState();
}

class _RecetaScreenState extends State<RecetaScreen> with SingleTickerProviderStateMixin {
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

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  // Función para verificar si el PDF ya ha sido descargado
  Future<bool> checkAndDownloadPDF() async {
    //Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory? appDocDir;
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) {
        appDocDir = Directory('/storage/emulated/0/Download');
      } else {
        // Permiso denegado
        print("Permiso denegado");
        return false;
      }
    } else if (Platform.isIOS) {
      appDocDir = await getApplicationDocumentsDirectory();
    } else {
      appDocDir = await getApplicationDocumentsDirectory();
    }

    String filePath = '${appDocDir.path}/receta_'+widget.idPaciente+'_'+widget.idReceta+'.pdf';
    print(filePath);
    File file = File(filePath);
    print(await file.exists());
    if (await file.exists()) {
      // El archivo ya existe localmente
      setState(() {
        localFilePath = filePath;
        isDownloaded = true;
      });
      return true;
    } else {
      await downloadPDF(filePath);
      return true;
    }
  }

  Future<void> downloadPDF(String path) async {
    pdfUrl = "https://v8.cadactopan.com.mx/data/recetas/receta_"+widget.idPaciente+"_"+widget.idReceta+".pdf";
    print(pdfUrl);
    try {
      final response = await http.get(Uri.parse(pdfUrl!));
      if (response.statusCode == 200) {
        print('Tamaño del archivo: ${response.bodyBytes.length} bytes');
        File file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        print('Archivo guardado en: $path');
      } else {
        print('Error: código de estado ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar datos');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    requestStoragePermission().then((_) {
      checkAndDownloadPDF();
    });
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
                appBar: myAppBar(context, nameReceta),
                drawer: SideMenu(user: _userapp, tipoapp: _tipoapp, idPaciente: widget.idPaciente, idReceta: widget.idReceta),
                resizeToAvoidBottomInset: false,
                body: isDownloaded && localFilePath != null
                  ? Builder(
                      builder: (context) {
                        try {
                          return PDFView(
                            filePath: localFilePath!,
                            enableSwipe: true,
                            swipeHorizontal: true,
                            autoSpacing: false,
                            pageFling: true,
                            onRender: (pages) {
                              setState(() {});
                            },
                            onError: (error) {
                              print('Error al abrir el PDF: $error');
                            },
                            onPageError: (page, error) {
                              print('Error en la página $page: $error');
                            },
                          );
                        } catch (e) {
                          print('Error al intentar mostrar el PDF: $e');
                          return const Center(child: Text('Error al mostrar el PDF'));
                        }
                      },
                    )
                  : const Center(child: CircularProgressIndicator(color: myColor)),
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