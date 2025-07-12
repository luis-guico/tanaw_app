import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  bool _is2faEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication'),
        backgroundColor: const Color(0xFF153B6A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enhance your account security by enabling Two-Factor Authentication (2FA).',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            SwitchListTile(
              title: const Text(
                'Enable Email 2FA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF153B6A),
                ),
              ),
              subtitle: Text(
                _is2faEnabled
                    ? 'A code will be sent to your email upon login.'
                    : 'Receive a security code via email to verify your identity.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              value: _is2faEnabled,
              onChanged: (bool value) {
                HapticFeedback.lightImpact();
                setState(() {
                  _is2faEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Two-Factor Authentication has been ${_is2faEnabled ? "enabled" : "disabled"}.'),
                  ),
                );
              },
              secondary: Icon(
                Icons.email_outlined,
                color: _is2faEnabled
                    ? const Color(0xFF153B6A)
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 