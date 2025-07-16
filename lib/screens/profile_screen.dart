import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/screens/guardian_home_screen.dart';
import 'package:tanaw_app/screens/home_screen.dart';
import 'package:tanaw_app/screens/security_screen.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'package:tanaw_app/widgets/animated_bottom_nav_bar.dart';
import 'login_screen.dart';
import 'change_password_screen.dart';
import 'notification_settings_screen.dart';
import 'language_settings_screen.dart';
import 'guardian_guide_screen.dart';
import 'terms_privacy_screen.dart';
import 'package:tanaw_app/widgets/fade_page_route.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    final isGuardianMode =
        Provider.of<GuardianModeState>(context, listen: false)
            .isGuardianModeEnabled;

    Widget destination;
    if (index == 1) {
      destination =
          isGuardianMode ? const GuardianHomeScreen() : const HomeScreen();
    } else if (index == 2) {
      destination = const ProfileScreen();
    } else {
      // Placeholder for 'Status' screen if it exists
      return;
    }

    Navigator.pushReplacement(
      context,
      FadePageRoute(page: destination),
    );
  }

  void _showConfirmationDialog(bool isEnabling, bool isCurrentlyDark) {
    final dialogBackgroundColor =
        isCurrentlyDark ? const Color(0xFF163C63) : Colors.white;
    final titleTextColor = isCurrentlyDark ? Colors.white : Colors.black87;
    final contentTextColor = isCurrentlyDark ? Colors.white70 : Colors.black54;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: dialogBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 24.0,
          icon: Icon(
            isEnabling ? Icons.shield_outlined : Icons.warning_amber_rounded,
            color: isEnabling ? Colors.blueAccent : Colors.orangeAccent,
            size: 48,
          ),
          title: Text(
            isEnabling ? 'Activate Guardian Mode' : 'Deactivate Guardian Mode',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: titleTextColor,
            ),
          ),
          content: Text(
            isEnabling
                ? 'Are you sure you want to activate Guardian Mode?'
                : 'Are you sure you want to turn off Guardian Mode?',
            textAlign: TextAlign.center,
            style: TextStyle(color: contentTextColor, fontSize: 14),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding:
              const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          actions: <Widget>[
            OutlinedButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: contentTextColor,
                side: BorderSide(color: contentTextColor.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              icon: Icon(
                  isEnabling
                      ? Icons.check_circle
                      : Icons.power_settings_new_rounded,
                  size: 18),
              label: const Text('Confirm'),
              onPressed: () {
                final guardianModeState =
                    Provider.of<GuardianModeState>(context, listen: false);
                guardianModeState.setGuardianMode(isEnabling);

                Navigator.of(context).pop(); // Close the dialog

                Fluttertoast.showToast(
                  msg: isEnabling
                      ? "Guardian Mode Activated"
                      : "Guardian Mode Deactivated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                );

                if (isEnabling) {
                  Navigator.pushReplacement(
                    context,
                    FadePageRoute(page: const GuardianHomeScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabling ? Colors.green : Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final guardianModeState = Provider.of<GuardianModeState>(context);
    final isGuardianMode = guardianModeState.isGuardianModeEnabled;

    return Scaffold(
      backgroundColor: isGuardianMode ? const Color(0xFF163C63) : Colors.grey[100],
      appBar: _buildAppBar(context, isGuardianMode),
      body: isGuardianMode ? _buildGuardianProfile(context) : _buildUserProfile(context),
      bottomNavigationBar: AnimatedBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isGuardianMode) {
    final Color appBarColor = isGuardianMode ? const Color(0xFF163C63) : Colors.white;
    final Color titleColor = isGuardianMode ? Colors.white : const Color(0xFF163C63);

    return AppBar(
      elevation: 0,
      backgroundColor: appBarColor,
      automaticallyImplyLeading: false,
      title: Text(
        'Profile',
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      actions: [],
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    final guardianModeState = Provider.of<GuardianModeState>(context);
    final isGuardianMode = guardianModeState.isGuardianModeEnabled;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader("Blind Dela Cruz", "Visually Impaired User", 'assets/logo.png', isGuardianMode),
          const SizedBox(height: 24),
          _buildInfoCard(
            context,
            'Device & Status',
            [
              _buildInfoRow(Icons.email, 'Email', 'blind.dc@tanaw.com'),
              _buildInfoRow(Icons.phone_android, 'Device Connected', 'Yes'),
              _buildInfoRow(Icons.toggle_on, 'Current Mode', 'User'),
            ],
            isGuardianMode,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            'Preferences',
            [
              _buildInfoRow(Icons.language, 'Language', 'English'),
              _buildInfoRow(Icons.record_voice_over, 'Voice Feedback', 'Enabled'),
            ],
            isGuardianMode,
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(context, isGuardianMode, guardianModeState),
        ],
      ),
    );
  }

  Widget _buildGuardianProfile(BuildContext context) {
    final guardianModeState = Provider.of<GuardianModeState>(context);
    final isGuardianMode = guardianModeState.isGuardianModeEnabled;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader("John Doe", "Guardian", 'assets/logo.png', isGuardianMode),
          const SizedBox(height: 24),
          _buildInfoCard(
            context,
            'Monitoring Status',
            [
              _buildInfoRow(Icons.person, 'Monitoring', "Blind Dela Cruz", isGuardianMode: isGuardianMode),
              _buildInfoRow(Icons.sensors, 'Device Status', 'Connected', isGuardianMode: isGuardianMode),
              _buildInfoRow(Icons.update, 'Last Update', '2 mins ago', isGuardianMode: isGuardianMode),
              _buildInfoRow(Icons.location_on, 'Location Access', 'Enabled', isGuardianMode: isGuardianMode),
            ],
            isGuardianMode,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            'Settings & More',
            [
              ListTile(
                leading: const Icon(Icons.shield_outlined, color: Colors.white),
                title: const Text('Guardian Mode', style: TextStyle(color: Colors.white)),
                trailing: Switch(
                  value: isGuardianMode,
                  onChanged: (value) => _showConfirmationDialog(value, isGuardianMode),
                  activeColor: Colors.white,
                  activeTrackColor: Colors.lightBlueAccent,
                ),
              ),
              _buildSettingsTile(Icons.notifications_outlined, 'Notification Settings', () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const NotificationSettingsScreen()),
                );
              }, isGuardianMode: true),
              _buildSettingsTile(Icons.language, 'Language', () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const LanguageSettingsScreen()),
                );
              }, isGuardianMode: true),
              _buildSettingsTile(Icons.lock_outline, 'Change Password', () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const ChangePasswordScreen()),
                );
              }, isGuardianMode: true),
              _buildSettingsTile(Icons.help_outline, 'Guardian Guide / Help', () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const GuardianGuideScreen()),
                );
              }, isGuardianMode: true),
              _buildSettingsTile(Icons.privacy_tip_outlined, 'Terms & Privacy', () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const TermsPrivacyScreen()),
                );
              }, isGuardianMode: true),
              _buildSettingsTile(Icons.logout, 'Logout', () {
                Navigator.pushAndRemoveUntil(
                  context,
                  FadePageRoute(page: const LoginScreen()),
                  (route) => false,
                );
              }, isGuardianMode: true),
            ],
            isGuardianMode,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String name, String role, String imagePath, bool isGuardianMode) {
    final textColor = isGuardianMode ? Colors.white : Colors.black87;
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : const AssetImage('assets/logo.png') as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, size: 15, color: Colors.black87),
                  onPressed: _pickImage,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              role,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, List<Widget> children, bool isGuardianMode) {
    final cardColor = isGuardianMode ? const Color(0xFF1E4872) : Colors.white;
    final titleColor = isGuardianMode ? Colors.white : Colors.black;

    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor),
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isGuardianMode = false}) {
    final textColor = isGuardianMode ? Colors.white : Colors.black87;
    final valueColor = isGuardianMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[isGuardianMode ? 400 : 600]),
          const SizedBox(width: 16),
          Text(label, style: TextStyle(fontSize: 16, color: textColor)),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, bool isGuardianMode, GuardianModeState guardianModeState) {
    return _buildInfoCard(
      context,
      'Settings & More',
      [
        ListTile(
          leading: const Icon(Icons.shield_outlined),
          title: const Text('Guardian Mode'),
          trailing: Switch(
            value: isGuardianMode,
            onChanged: (value) => _showConfirmationDialog(value, isGuardianMode),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        _buildSettingsTile(Icons.notifications_outlined, 'Notification Settings', () {
          Navigator.push(
            context,
            FadePageRoute(page: const NotificationSettingsScreen()),
          );
        }),
        _buildSettingsTile(Icons.lock_outline, 'Change Password', () {
          Navigator.push(
            context,
            FadePageRoute(page: const ChangePasswordScreen()),
          );
        }),
        _buildSettingsTile(Icons.language, 'Language', () {
          Navigator.push(
            context,
            FadePageRoute(page: const LanguageSettingsScreen()),
          );
        }),
        _buildSettingsTile(Icons.help_outline, 'Guardian Guide / Help', () {
          Navigator.push(
            context,
            FadePageRoute(page: const GuardianGuideScreen()),
          );
        }),
        _buildSettingsTile(Icons.privacy_tip_outlined, 'Terms & Privacy', () {
          Navigator.push(
            context,
            FadePageRoute(page: const TermsPrivacyScreen()),
          );
        }),
        _buildSettingsTile(Icons.logout, 'Logout', () {
          Navigator.pushAndRemoveUntil(
            context,
            FadePageRoute(page: const LoginScreen()),
            (route) => false,
          );
        }),
      ],
      isGuardianMode,
    );
  }
  
  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap, {bool isGuardianMode = false}) {
    final tileColor = isGuardianMode ? Colors.white : Colors.black87;
    return ListTile(
      leading: Icon(icon, color: tileColor),
      title: Text(title, style: TextStyle(color: tileColor)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: tileColor),
      onTap: onTap,
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final guardianModeState = Provider.of<GuardianModeState>(context);
    final isGuardianMode = guardianModeState.isGuardianModeEnabled;
    final textColor = isGuardianMode ? Colors.white : const Color(0xFF163C63);

    return ListTile(
      leading: Icon(icon, color: textColor, size: 28),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }
}