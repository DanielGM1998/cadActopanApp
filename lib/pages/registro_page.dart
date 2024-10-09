import 'package:flutter/material.dart';
import 'package:recuperacion/presentation/widgets/background.dart';

class RegistroPage extends StatefulWidget {
  static const String routeName = 'registro';
  const RegistroPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: const Text(
                      "Registro",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
                          fontSize: 36),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  //////
                  Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          onChanged: (valor) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: "Nombre del usuario",
                              labelText: "Nombre",
                              suffixIcon: Icon(
                                Icons.person,
                                size: 40,
                              ),
                              icon: Icon(
                                Icons.account_circle,
                              )),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          onChanged: (valor) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: "Teléfono del usuario",
                              labelText: "Teléfono",
                              suffixIcon: Icon(
                                Icons.numbers,
                                size: 40,
                              ),
                              icon: Icon(
                                Icons.phone,
                              )),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          onChanged: (valor) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: "Usuario",
                              labelText: "Usuario",
                              suffixIcon: Icon(
                                Icons.person_outline,
                                size: 40,
                              ),
                              icon: Icon(
                                Icons.verified_user_rounded,
                              )),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          onChanged: (valor) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: "Contraseña del usuario",
                              labelText: "Contraseña",
                              suffixIcon: Icon(
                                Icons.password,
                                size: 40,
                              ),
                              icon: Icon(
                                Icons.security,
                              )),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  //////
                  /* Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
                    ),
                  ), */
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 10, right: 40, left: 40),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'inicio');
                      },
                      child: const Text(
                        "Registrar",
                        style: TextStyle(color: Color(0xFF2661FA)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'login');
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.indigo.withOpacity(0.1)),
                            /* shape: MaterialStateProperty.all(
                                  const StadiumBorder()) */
                          ),
                          child: const Text(
                            "¿Tienes una cuenta? Inicia sesión",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2661FA)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
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
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Si'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
