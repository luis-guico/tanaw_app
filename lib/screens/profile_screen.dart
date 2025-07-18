import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/screens/guardian_home_screen.dart';
import 'package:tanaw_app/screens/home_screen.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'package:tanaw_app/state/tts_state.dart';
import 'package:tanaw_app/widgets/animated_bottom_nav_bar.dart';
import 'package:tanaw_app/widgets/tanaw_logo.dart';
import 'login_screen.dart';
import 'change_password_screen.dart';
import 'notification_settings_screen.dart';
import 'language_settings_screen.dart';
import 'guardian_guide_screen.dart';
import 'terms_privacy_screen.dart';
import 'package:tanaw_app/widgets/fade_page_route.dart';
import 'package:tanaw_app/screens/status_screen.dart';
import 'package:tanaw_app/services/tts_service.dart';
import 'package:tanaw_app/state/profile_state.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;
  late TtsService _ttsService;

  @override
  void initState() {
    super.initState();
    _ttsService = TtsService(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isGuardianMode =
          Provider.of<GuardianModeState>(context, listen: false)
              .isGuardianModeEnabled;
      _ttsService.speak(isGuardianMode ? 'Guardian Profile' : 'User Profile');
    });
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    final isGuardianMode =
        Provider.of<GuardianModeState>(context, listen: false)
            .isGuardianModeEnabled;

    setState(() {
      _selectedIndex = index;
    });

    Widget page;
    switch (index) {
      case 0:
        page = const StatusScreen();
        break;
      case 1:
        page = isGuardianMode ? const GuardianHomeScreen() : const HomeScreen();
        break;
      case 2:
        page = const ProfileScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, FadePageRoute(page: page));
  }

  void _showConfirmationDialog(bool isEnabling, bool isCurrentlyGuardian) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dialogBackgroundColor =
        isDarkMode ? const Color(0xFF163C63) : Colors.white;
    final titleTextColor = isDarkMode ? Colors.white : Colors.black87;
    final contentTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    _ttsService.speak(isEnabling
        ? 'Activate Guardian Mode Confirmation'
        : 'Deactivate Guardian Mode Confirmation');

    showDialog(
      context: context,
      barrierDismissible: false,
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
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: contentTextColor,
                side: BorderSide(color: contentTextColor.withAlpha(128)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Cancel'),
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

                Navigator.of(context).pop();

                _ttsService.speak(isEnabling
                    ? "Guardian Mode Activated"
                    : "Guardian Mode Deactivated");

                Fluttertoast.showToast(
                  msg: isEnabling
                      ? "Guardian Mode Activated"
                      : "Guardian Mode Deactivated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor:
                      isEnabling ? const Color(0xFF153A5B) : Colors.black87,
                  textColor: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isEnabling ? const Color(0xFF153A5B) : Colors.redAccent,
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
      backgroundColor:
          isGuardianMode ? const Color(0xFF102A43) : Colors.grey.shade100,
      appBar: _buildAppBar(context, isGuardianMode),
      body: isGuardianMode
          ? _buildGuardianProfile(context)
          : _buildUserProfile(context),
      bottomNavigationBar: AnimatedBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isGuardianMode) {
    if (isGuardianMode) {
      return AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF102A43),
        automaticallyImplyLeading: false,
        title: TanawLogo(isGuardianMode: isGuardianMode),
        actions: const [],
      );
    }
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: const Text(
        'Profile',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    final profileState = Provider.of<ProfileState>(context);
    final ttsState = Provider.of<TtsState>(context);
    final guardianModeState = Provider.of<GuardianModeState>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(
            profileState.userName,
            "Visually Impaired User",
            profileState.userImage != null
                ? FileImage(profileState.userImage!)
                : const AssetImage('assets/logo.png') as ImageProvider,
            false,
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            context,
            'Device & Status',
            [
              _buildInfoRow(Icons.email, 'Email', profileState.userEmail),
              _buildInfoRow(Icons.phone, 'Phone', profileState.userPhone),
              _buildInfoRow(Icons.phone_android, 'Device Connected', 'Yes'),
              _buildInfoRow(Icons.toggle_on, 'Current Mode', 'User'),
            ],
            false,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            'Preferences',
            [
              _buildSettingsActionRow(
                  context, Icons.language, 'Language', () {},
                  isGuardianMode: false)
            ],
            false,
          ),
          const SizedBox(height: 16),
          _buildTogglesCard(context, guardianModeState, ttsState),
        ],
      ),
    );
  }

  Widget _buildGuardianProfile(BuildContext context) {
    final guardianModeState = Provider.of<GuardianModeState>(context);
    final isGuardianMode = guardianModeState.isGuardianModeEnabled;
    final profileState = Provider.of<ProfileState>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(
            profileState.guardianName,
            "Guardian",
            profileState.guardianImage != null
                ? FileImage(profileState.guardianImage!)
                : const AssetImage('assets/logo.png') as ImageProvider,
            isGuardianMode,
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            context,
            'Device & Status',
            [
              _buildInfoRow(Icons.email, 'Email', profileState.guardianEmail,
                  isGuardianMode: isGuardianMode),
              _buildInfoRow(Icons.phone, 'Phone', profileState.guardianPhone,
                  isGuardianMode: isGuardianMode),
              _buildInfoRow(Icons.toggle_on, 'Current Mode', 'Guardian',
                  isGuardianMode: isGuardianMode),
            ],
            isGuardianMode,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            'Monitoring Status',
            [
              _buildInfoRow(Icons.person, 'Monitoring', "Blind Dela Cruz",
                  isGuardianMode: isGuardianMode),
              _buildInfoRow(Icons.sensors, 'Device Status', 'Connected',
                  isGuardianMode: isGuardianMode),
              _buildInfoRow(Icons.update, 'Last Update', '2 mins ago',
                  isGuardianMode: isGuardianMode),
              _buildInfoRow(Icons.location_on, 'Location Access', 'Enabled',
                  isGuardianMode: isGuardianMode),
            ],
            isGuardianMode,
          ),
          const SizedBox(height: 24),
          _buildGuardianSettings(context),
        ],
      ),
    );
  }

  Widget _buildTogglesCard(
      BuildContext context, GuardianModeState guardianModeState, TtsState ttsState) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withAlpha(51),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Column(
          children: [
            _buildSettingsRow(
              context,
              Icons.family_restroom,
              'Guardian Mode',
              Switch(
                value: guardianModeState.isGuardianModeEnabled,
                onChanged: (value) {
                  _showConfirmationDialog(
                      value, guardianModeState.isGuardianModeEnabled);
                },
              ),
              isGuardianMode: false,
            ),
            const Divider(),
            _buildSettingsRow(
              context,
              Icons.record_voice_over,
              'Voice Feedback (TTS)',
              Switch(
                value: ttsState.isTtsEnabled,
                onChanged: (value) {
                  ttsState.setTtsEnabled(value);
                },
              ),
              isGuardianMode: false,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGuardianSettings(BuildContext context) {
    return Card(
      color: const Color(0xFF0F3356),
      elevation: 4,
      shadowColor: Colors.black.withAlpha(51),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsActionRow(context, Icons.notifications_none,
                'Notification Settings', () {},
                isGuardianMode: true),
            const Divider(color: Colors.white24),
            _buildSettingsActionRow(
                context, Icons.help_outline, 'Guardian Guide / Help', () {
              Navigator.push(
                context,
                FadePageRoute(page: const GuardianGuideScreen()),
              );
            }, isGuardianMode: true),
            const Divider(color: Colors.white24),
            _buildSettingsActionRow(
                context, Icons.privacy_tip_outlined, 'Terms & Privacy', () {},
                isGuardianMode: true),
            const Divider(color: Colors.white24),
            _buildSettingsActionRow(
                context, Icons.lock_outline, 'Change Password', () {},
                isGuardianMode: true),
            const Divider(color: Colors.white24),
            _buildSettingsActionRow(context, Icons.logout, 'Logout', () {
              Navigator.pushAndRemoveUntil(
                context,
                FadePageRoute(page: const LoginScreen()),
                (route) => false,
              );
            }, isGuardianMode: true),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title,
      List<Widget> children, bool isGuardianMode) {
    final cardColor = isGuardianMode ? const Color(0xFF0F3356) : Colors.white;
    final titleColor = isGuardianMode ? Colors.white : Colors.black;

    return Card(
      elevation: isGuardianMode ? 4 : 2,
      shadowColor: Colors.black.withAlpha(51),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: titleColor),
            ),
            const Divider(height: 30, thickness: 0.5),
            ...children
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsRow(
      BuildContext context, IconData icon, String title, Widget trailing,
      {bool isGuardianMode = false}) {
    final tileColor = isGuardianMode ? Colors.white : Colors.black;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: tileColor),
      title: Text(
        title,
        style: TextStyle(color: tileColor, fontWeight: FontWeight.w500),
      ),
      trailing: trailing,
    );
  }

  Widget _buildSettingsActionRow(
      BuildContext context, IconData icon, String title, VoidCallback onTap,
      {bool isGuardianMode = false}) {
    final tileColor = isGuardianMode ? Colors.white : Colors.black;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: tileColor),
      title: Text(
        title,
        style: TextStyle(color: tileColor, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: tileColor, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {bool isGuardianMode = false}) {
    final labelColor = isGuardianMode ? Colors.white : Colors.black;
    final valueColor = isGuardianMode ? Colors.white : Colors.black;
    final iconColor = isGuardianMode ? Colors.white : Colors.grey[800];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 16),
          Text(label, style: TextStyle(fontSize: 16, color: labelColor)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String name, String role,
      ImageProvider<Object> imageProvider, bool isGuardianMode) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: imageProvider,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isGuardianMode ? Colors.white : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                role,
                style: TextStyle(
                  fontSize: 16,
                  color: isGuardianMode ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.edit_square,
            color: isGuardianMode ? Colors.white70 : Colors.black54,
          ),
          onPressed: () {
            Navigator.push(
              context,
              FadePageRoute(page: const EditProfileScreen()),
            );
          },
        ),
      ],
    );
  }
}