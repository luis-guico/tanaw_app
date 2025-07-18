import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'password_changed_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<GuardianModeState>(
      builder: (context, guardianState, child) {
        final bool isGuardianMode = guardianState.isGuardianModeEnabled;
        final Color backgroundColor =
            isGuardianMode ? const Color(0xFF102A43) : Colors.grey.shade100;
        final Color textColor =
            isGuardianMode ? Colors.white : const Color(0xFF153A5B);
        final Color cardColor =
            isGuardianMode ? const Color(0xFF153A5B) : Colors.white;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Change Password',
              style: TextStyle(color: textColor),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPasswordField(
                    label: 'Current Password',
                    obscureText: _obscureCurrentPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                    isGuardianMode: isGuardianMode,
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    label: 'Create New Password',
                    obscureText: _obscureNewPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                    isGuardianMode: isGuardianMode,
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    label: 'Confirm New Password',
                    obscureText: _obscureConfirmPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    isGuardianMode: isGuardianMode,
                  ),
                  const SizedBox(height: 20),
                  _buildRequirementText(isGuardianMode),
                  const SizedBox(height: 30),
                  _buildReminderCard(cardColor, textColor),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Add logic to verify the current password before proceeding.
                      HapticFeedback.lightImpact();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PasswordChangedScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF153A5B),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required bool isGuardianMode,
  }) {
    final Color fieldColor =
        isGuardianMode ? const Color(0xFF153A5B) : Colors.white;
    final Color textColor = isGuardianMode ? Colors.white : Colors.black;

    return TextFormField(
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withAlpha(178)),
        filled: true,
        fillColor: fieldColor,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: textColor.withAlpha(178),
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRequirementText(bool isGuardianMode) {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          color: isGuardianMode ? Colors.white54 : Colors.grey.shade600,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          'Must be 8 characters long.',
          style: TextStyle(
            color: isGuardianMode ? Colors.white54 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildReminderCard(Color cardColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (cardColor == Colors.white)
            BoxShadow(
              color: Colors.grey.withAlpha(51),
              spreadRadius: 2,
              blurRadius: 5,
            ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: textColor.withAlpha(204),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Please make sure you remember and login with your new password you just created. Changes are reflected real-time after you changed your password.',
              style: TextStyle(
                color: textColor.withAlpha(204),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}