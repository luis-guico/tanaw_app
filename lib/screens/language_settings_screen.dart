import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  LanguageSettingsScreenState createState() => LanguageSettingsScreenState();
}

class LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguage = 'English (US)';
  final List<String> _languages = ['English (US)', 'Filipino'];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage =
          prefs.getString('language') ?? 'English (US)';
    });
  }

  Future<void> _updateLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GuardianModeState>(
      builder: (context, guardianState, child) {
        final bool isGuardianMode = guardianState.isGuardianModeEnabled;
        final Color backgroundColor =
            isGuardianMode ? const Color(0xFF153A5B) : Colors.white;
        final Color textColor =
            isGuardianMode ? Colors.white : const Color(0xFF153A5B);
        final Color subtitleColor =
            isGuardianMode ? Colors.white70 : Colors.grey.shade600;
        final Color buttonColor = const Color(0xFF153A5B);

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Icon(
                    Icons.language,
                    size: 80,
                    color: textColor,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Language',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select your voice prompt preference.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildLanguageSelector(
                      isGuardianMode, textColor, subtitleColor),
                  const Spacer(flex: 3),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isGuardianMode ? Colors.white : buttonColor,
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isGuardianMode ? buttonColor : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSelector(
      bool isGuardianMode, Color textColor, Color subtitleColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: isGuardianMode
            ? Colors.white.withOpacity(0.1)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isGuardianMode ? Colors.white.withOpacity(0.2) : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          isExpanded: true,
          dropdownColor:
              isGuardianMode ? const Color(0xFF1E4872) : Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: textColor),
          onChanged: (String? newValue) {
            if (newValue != null) {
              _updateLanguage(newValue);
            }
          },
          items: _languages.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  value,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
} 