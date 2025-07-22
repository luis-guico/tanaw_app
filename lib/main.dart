import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/screens/splash_screen.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'package:tanaw_app/state/tts_state.dart';
import 'package:tanaw_app/state/profile_state.dart';
import 'package:tanaw_app/state/connection_state.dart' as app_connection;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GuardianModeState()),
        ChangeNotifierProvider(create: (_) => TtsState()),
        ChangeNotifierProvider(create: (_) => ProfileState()),
        ChangeNotifierProvider(create: (_) => app_connection.ConnectionState()),
      ],
      child: const MyApp(), 
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TANAW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}