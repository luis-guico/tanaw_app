import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isGuardianMode =
        Provider.of<GuardianModeState>(context).isGuardianModeEnabled;

    final Color backgroundColor =
        isGuardianMode ? const Color(0xFF173B61) : Colors.white;
    final Color textColor =
        isGuardianMode ? Colors.white.withAlpha(230) : const Color(0xFF333333);
    final Color headerColor =
        isGuardianMode ? Colors.white : const Color(0xFF173B61);
    final Color dividerColor =
        isGuardianMode ? Colors.white24 : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Terms & Privacy',
          style: TextStyle(
              color: isGuardianMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isGuardianMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              headerColor,
              'Introduction',
              'Welcome to TANAW, a mobile application designed to assist visually impaired individuals through smart IoT glasses. It also includes features for guardians to monitor and ensure the safety of the user. To make the system function effectively, TANAW collects only essential data such as your email address, profile name and picture, device connection status, and your location — the last of which is only accessed when Guardian Mode is enabled.',
              textColor,
              dividerColor,
            ),
            _buildSection(
              headerColor,
              'Data Usage',
              'Your data is used solely to provide you with key functionalities: obstacle alerts (through voice or vibration), guardian notifications, and real-time connection updates. We do not sell, misuse, or share your personal data with third parties. Guardians, when Guardian Mode is turned on, are granted access to alerts about detected movements, the user’s last known location, and device status updates.',
              textColor,
              dividerColor,
            ),
            _buildSection(
              headerColor,
              'Accessibility (TTS)',
              'For the user side, TANAW supports Text-to-Speech (TTS) for accessibility. This feature can be turned on or off via a toggle in the profile. When enabled, all interface labels and buttons are spoken aloud. When disabled, the app still provides essential audio alerts for critical items like “Garbage bin ahead,” “Battery low,” or “Device disconnected.”',
              textColor,
              dividerColor,
            ),
            _buildSection(
              headerColor,
              'Third-Party Services & User Responsibilities',
              'TANAW also integrates with trusted third-party services such as Google Sign-In and cloud databases, which follow their own privacy standards. As a user or guardian, you are responsible for keeping your login credentials secure, enabling required permissions like Bluetooth and location access, and using the application responsibly and ethically.',
              textColor,
              dividerColor,
            ),
            _buildSection(
              headerColor,
              'Policy Updates & Contact',
              'This policy may be updated occasionally. Significant changes will be communicated via the app or email. For questions or concerns, you may reach us at tanawsupport@email.com.',
              textColor,
              dividerColor,
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Last updated: July 2025',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: textColor.withAlpha(178),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(Color headerColor, String title, String content,
      Color textColor, Color dividerColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: headerColor,
            ),
          ),
        ),
        Text(
          content,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: textColor,
          ),
        ),
        const SizedBox(height: 24),
        Divider(color: dividerColor, thickness: 1),
      ],
    );
  }
} 