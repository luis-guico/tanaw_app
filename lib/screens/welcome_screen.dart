import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFBBDEFB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset('assets/logo.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              'TANAW',
              style: TextStyle(
                color: Color(0xFF0D47A1),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF0D47A1), width: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Log In',
                style: TextStyle(
                  color: Color(0xFF0D47A1),
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {}, // Placeholder for Sign Up
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF0D47A1), width: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Color(0xFF0D47A1),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}