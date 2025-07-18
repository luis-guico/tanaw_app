import 'package:flutter/material.dart';

class TanawLogo extends StatelessWidget {
  final bool isGuardianMode;
  const TanawLogo({super.key, required this.isGuardianMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/TANAW-LOGO2.0.png', width: 35),
          const SizedBox(height: 4),
          Text(
            'TANAW',
            style: TextStyle(
              color: isGuardianMode ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
} 