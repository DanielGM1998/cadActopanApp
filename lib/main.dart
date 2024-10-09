import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:recuperacion/pages/add_empleado_page.dart';
import 'package:recuperacion/pages/add_usuario_page.dart';
import 'package:recuperacion/pages/empleado_page.dart';
import 'package:recuperacion/presentation/screens/home/home_screen.dart';
import 'package:recuperacion/presentation/screens/login/login_screen.dart';
import 'package:recuperacion/presentation/screens/login/recuperar_screen.dart';
import 'package:recuperacion/presentation/screens/splash/splash_screen.dart';
import 'package:recuperacion/presentation/screens/users/usuario_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'CAD Actopan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).getTheme(),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
      initialRoute: SplashScreen.routeName,
      routes: {
        HomeScreen.routeName: (BuildContext context) => const HomeScreen(),
        SplashScreen.routeName: (BuildContext context) => const SplashScreen(),
        LoginScreen.routeName: (BuildContext context) => const LoginScreen(),
        RecuperarScreen.routeName: (BuildContext context) =>
            const RecuperarScreen(),
        EmpleadoPage.routeName: (BuildContext context) => const EmpleadoPage(),
        AddEmpleadoPage.routeName: (BuildContext context) =>
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
        UsuarioScreen.routeName: (BuildContext context) => const UsuarioScreen(),
        AddUsuarioPage.routeName: (BuildContext context) =>
            const AddUsuarioPage(
              tipoScreen: "2",
              id: "",
              name: "",
              patern: "",
              matern: "",
              mail: "",
              cellphone: "",
              type: "",
            ),
      },
    );
  }
}
