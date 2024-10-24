import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:recuperacion/constants/constants.dart';
import 'package:recuperacion/presentation/screens/home/home_screen.dart';
import 'package:recuperacion/presentation/screens/login/login_screen.dart';
import 'package:recuperacion/presentation/screens/splash/splash_screen.dart';
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
      title: nameApp,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).getTheme(),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (BuildContext context) => const SplashScreen(),
        LoginScreen.routeName: (BuildContext context) => const LoginScreen(),
        HomeScreen.routeName: (BuildContext context) => const HomeScreen(),
      },
    );
  }
}
