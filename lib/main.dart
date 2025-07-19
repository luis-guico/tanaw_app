import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/screens/splash_screen.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'package:tanaw_app/state/tts_state.dart';
import 'package:tanaw_app/state/profile_state.dart';
import 'package:tanaw_app/widgets/fade_page_transitions_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GuardianModeState()),
        ChangeNotifierProvider(create: (_) => TtsState()),
        ChangeNotifierProvider(create: (_) => ProfileState()),
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
      debugShowCheckedModeBanner: false,
      title: 'TANAW App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadePageTransitionsBuilder(),
            TargetPlatform.iOS: FadePageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}