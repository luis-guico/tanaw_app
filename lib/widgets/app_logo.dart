import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final bool isGuardianMode;

  const AppLogo({super.key, required this.isGuardianMode});

  @override
  Widget build(BuildContext context) {
    final Color textColor = isGuardianMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/TANAW-LOGO2.0.png', width: 45),
          const SizedBox(height: 4),
          Text(
            'TANAW',
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.normal,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
} 