import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const TanawApp());
}

class TanawApp extends StatelessWidget {
  const TanawApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TANAW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}