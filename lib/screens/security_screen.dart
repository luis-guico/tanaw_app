import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tanaw_app/screens/change_password_screen.dart';
import 'package:tanaw_app/screens/manage_sessions_screen.dart';
import 'package:tanaw_app/screens/two_factor_auth_screen.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Security'),
        backgroundColor: const Color(0xFF153B6A),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSecurityOption(
            context: context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password periodically to stay secure.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          const Divider(height: 24),
          _buildSecurityOption(
            context: context,
            icon: Icons.phonelink_lock_outlined,
            title: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of security to your account.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TwoFactorAuthScreen(),
                ),
              );
            },
          ),
          const Divider(height: 24),
          _buildSecurityOption(
            context: context,
            icon: Icons.devices_other_outlined,
            title: 'Manage Active Sessions',
            subtitle: 'Review and sign out from connected devices.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageSessionsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 32, color: const Color(0xFF153B6A)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF153B6A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    );
  }
} 