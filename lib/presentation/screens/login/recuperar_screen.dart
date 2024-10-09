import 'dart:convert';
import 'dart:ui';

import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recuperacion/presentation/screens/login/login_screen.dart';
import 'package:http/http.dart' as http;

class RecuperarScreen extends StatefulWidget {
  static const String routeName = 'recuperar';
  const RecuperarScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RecuperarScreen> createState() => _RecuperarScreenState();
}

class _RecuperarScreenState extends State<RecuperarScreen> {
  String _correo = "";
  bool _validateCorreo = false;
  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
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
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 120,
                      ),
                      Image.asset("assets/images/logo.png",
                          width: size.width * 0.70),
                      const SizedBox(
                        height: 130,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: const Text(
                              "Recuperar contraseña",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(0, 0, 102, 1),
                                  fontSize: 25),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          Padding(
                            padding: const EdgeInsets.only(right: 30, left: 30),
                            child: DefaultTextStyle(
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: GoogleFonts.roboto(
                                  fontSize: 18.5,
                                  color: const Color.fromRGBO(0, 0, 102, 1)),
                              child: const Text(
                                  "Ingresa tu Email y tu nueva contraseña será enviada"),
                            ),
                          ),
                          //////
                          Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ThemeData().colorScheme.copyWith(
                                        primary: const Color.fromRGBO(
                                            55, 171, 204, 1),
                                      ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor:
                                        const Color.fromRGBO(55, 171, 204, 1),
                                    onChanged: (valor) {
                                      setState(() {
                                        _correo = valor;
                                        _validateCorreo =
                                            EmailValidator.validate(_correo);
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        hintText: "Correo electrónico",
                                        labelText: "Correo",
                                        suffixIcon: Icon(
                                          Icons.person,
                                          size: 40,
                                        ),
                                        icon: Icon(
                                          Icons.account_circle,
                                        )),
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (value) async {
                                      if (_correo != "") {
                                        if (_validateCorreo) {
                                          showProgress(context, _correo);
                                        } else {
                                          awesomeTopSnackbar(
                                            context,
                                            "Correo electrónico invalido",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                            backgroundColor: Colors.redAccent,
                                            icon: const Icon(Icons.check,
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
                                          "Debe ingresar el Correo electrónico",
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20),
                                          backgroundColor: Colors.redAccent,
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
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(
                                top: 10, right: 40, left: 40),
                            child: OutlinedButton(
                              onPressed: () async {
                                if (_correo != "") {
                                  showProgress(context, _correo);
                                } else {
                                  awesomeTopSnackbar(
                                    context,
                                    "Debe ingresar el Correo electrónico",
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20),
                                    backgroundColor: Colors.redAccent,
                                    icon: const Icon(Icons.check,
                                        color: Colors.black),
                                    iconWithDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.black),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "Cambiar contraseña",
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 102, 1)),
                              ),
                            ),
                          ),
                          Container(
                              color: Colors.transparent,
                              height: size.height * 0.10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Recuperación de contraseña'),
            content:
                const Text('¿Deseas cancelar la recuperación de contraseña?'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      barrierColor: Colors.black.withOpacity(0.6),
                      opaque: false,
                      pageBuilder: (_, __, ___) => const LoginScreen(),
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
                  )
                },
                child: const Text('Si'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

Future<String> _check(correo) async {
  try {
    var data = {"email": correo};
    final response = await http.post(
        Uri(
          scheme: 'https',
          host: 'dds.tecnoregistro.pro',
          path: '/registroAsistencia/public/seg_usuario/recoveryPass',
        ),
        body: data);
    if (response.statusCode == 200) {
      String body3 = utf8.decode(response.bodyBytes);
      var jsonData = jsonDecode(body3);
      return jsonData['message'];
    } else {
      return 'Error, verificar conexión a Internet';
    }
  } catch (e) {
    return 'Error, verificar conexión a Internet';
  }
}

showProgress(BuildContext context, String correo) async {
  var result = await showDialog(
    context: context,
    builder: (context) => FutureProgressDialog(_check(correo)),
  );
  showResultDialog(context, result);
}

Future<void> showResultDialog(BuildContext context, String result) async {
  if (result == 'Error, verificar conexión a Internet') {
    awesomeTopSnackbar(
      context,
      "Error, verificar conexión a Internet",
      textStyle: const TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          fontSize: 20),
      backgroundColor: Colors.redAccent,
      icon: const Icon(Icons.check, color: Colors.black),
      iconWithDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
    );
  } else {
    awesomeTopSnackbar(
      context,
      "Se envió una nueva contraseña a tu correo",
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
    Navigator.of(context).push(
      PageRouteBuilder(
        barrierColor: Colors.black.withOpacity(0.6),
        opaque: false,
        pageBuilder: (_, __, ___) => const LoginScreen(),
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
  }
}
