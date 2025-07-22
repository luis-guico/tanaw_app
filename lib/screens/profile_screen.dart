import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';


import 'package:provider/provider.dart';
import 'package:tanaw_app/screens/guardian_home_screen.dart';
import 'package:tanaw_app/screens/home_screen.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'package:tanaw_app/state/tts_state.dart';
import 'package:tanaw_app/widgets/animated_bottom_nav_bar.dart';
import 'package:tanaw_app/widgets/app_logo.dart';
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
    // Announce the screen title when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ttsService.speak('Profile Screen');
    });
  }

  void _showLogoutConfirmationDialog(BuildContext context, bool isGuardianMode) {
    final dialogBackgroundColor = isGuardianMode ? const Color(0xFF1E4872) : Colors.white;
    final titleTextColor = isGuardianMode ? Colors.white : Colors.black87;
    final contentTextColor = isGuardianMode ? Colors.white70 : Colors.grey.shade600;
    final destructiveColor = Colors.redAccent;

    _ttsService.speak('Logout Confirmation');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                decoration: BoxDecoration(
                  color: dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Logout',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: titleTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Are you sure you want to logout?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: contentTextColor, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: contentTextColor, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            Provider.of<GuardianModeState>(context, listen: false).setGuardianMode(false);
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: destructiveColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dialogBackgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Icon(Icons.logout, color: destructiveColor, size: 40),
                ),
              ),
            ],
          ),
        );
      },
    );
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
        page = isGuardianMode
            ? const GuardianHomeScreen()
            : const HomeScreen();
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
    final bool isDarkMode = isCurrentlyGuardian;
    final dialogBackgroundColor =
        isDarkMode ? const Color(0xFF1E4872) : Colors.white;
    final titleTextColor = isDarkMode ? Colors.white : Colors.black87;
    final contentTextColor =
        isDarkMode ? Colors.white70 : Colors.grey.shade600;
    final accentColor =
        isDarkMode ? Colors.cyanAccent : const Color(0xFF153A5B);
    final destructiveColor = Colors.redAccent;

    _ttsService.speak(isEnabling
        ? 'Activate Guardian Mode Confirmation'
        : 'Deactivate Guardian Mode Confirmation');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                decoration: BoxDecoration(
                  color: dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEnabling
                          ? 'Activate Guardian Mode?'
                          : 'Deactivate Guardian Mode?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: titleTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isEnabling
                          ? 'This will enable real-time monitoring and alerts.'
                          : 'This will turn off real-time monitoring. Are you sure?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: contentTextColor, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style:
                                TextStyle(color: contentTextColor, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            final guardianModeState =
                                Provider.of<GuardianModeState>(context,
                                    listen: false);
                            guardianModeState.setGuardianMode(isEnabling);

                            Navigator.of(context).pop(); // Close the dialog

                            _ttsService.speak(isEnabling
                                ? "Guardian Mode Activated"
                                : "Guardian Mode Deactivated");

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Text(
                                  isEnabling
                                      ? "Guardian Mode Activated"
                                      : "Guardian Mode Deactivated",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isEnabling
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                  bottom: 85.0,
                                  left:
                                      MediaQuery.of(context).size.width * 0.25,
                                  right:
                                      MediaQuery.of(context).size.width * 0.25,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isEnabling ? accentColor : destructiveColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dialogBackgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Icon(
                    isEnabling
                        ? Icons.family_restroom
                        : Icons.power_settings_new_rounded,
                    color: isEnabling ? accentColor : destructiveColor,
                    size: 40,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.close, color: contentTextColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final guardianModeState = Provider.of<GuardianModeState>(context);
    final isGuardianMode = guardianModeState.isGuardianModeEnabled;

    return Scaffold(
      backgroundColor: isGuardianMode ? const Color(0xFF102A43) : Colors.white,
      appBar: _buildAppBar(context, isGuardianMode),
      body: isGuardianMode ? _buildGuardianProfile(context) : _buildUserProfile(context),
      bottomNavigationBar: AnimatedBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isGuardianMode) {
    return AppBar(
      elevation: 0,
      backgroundColor: isGuardianMode ? const Color(0xFF102A43) : Colors.white,
      automaticallyImplyLeading: false,
      title: AppLogo(isGuardianMode: isGuardianMode),
      actions: [],
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    final guardianModeState = Provider.of<GuardianModeState>(context);
    final isGuardianMode = guardianModeState.isGuardianModeEnabled;
    final profileState = Provider.of<ProfileState>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(
            profileState.userName,
            "Visually Impaired User",
            profileState.userImagePath != null && !kIsWeb
                ? FileImage(File(profileState.userImagePath!))
                : const AssetImage('assets/TANAW-LOGO2.0.png'),
            isGuardianMode,
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
            isGuardianMode,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            'Preferences',
            [
              _buildInfoRow(Icons.language, 'Language', 'English'),
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
    final profileState = Provider.of<ProfileState>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(
            profileState.guardianName,
            "Guardian",
            profileState.guardianImagePath != null && !kIsWeb
                ? FileImage(File(profileState.guardianImagePath!))
                : const AssetImage('assets/TANAW-LOGO2.0.png'),
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
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            'Settings & More',
            [
              ListTile(
                leading: const Icon(Icons.family_restroom, color: Colors.white),
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
                _showLogoutConfirmationDialog(context, true);
              }, isGuardianMode: true),
            ],
            isGuardianMode,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      String name, String role, ImageProvider imageProvider, bool isGuardianMode) {
    
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

  Widget _buildInfoCard(BuildContext context, String title, List<Widget> children, bool isGuardianMode) {
    final cardColor = isGuardianMode ? const Color(0xFF1E4872) : Colors.white;
    final titleColor = isGuardianMode ? Colors.white : Colors.black;

    return Card(
      color: cardColor,
      elevation: isGuardianMode ? 4 : 2,
      shadowColor: isGuardianMode ? Colors.black.withAlpha(51) : Colors.grey.withAlpha(100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isGuardianMode ? BorderSide.none : BorderSide(color: Colors.grey.shade200, width: 1),
      ),
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

  Widget _buildSettingsSection(BuildContext context, bool isGuardianMode,
      GuardianModeState guardianModeState) {
    final ttsState = Provider.of<TtsState>(context);

    return Card(
      color: isGuardianMode ? const Color(0xFF1E4872) : Colors.white,
      elevation: isGuardianMode ? 4 : 2,
      shadowColor: isGuardianMode
          ? Colors.black.withAlpha(51)
          : Colors.grey.withAlpha(100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isGuardianMode
            ? BorderSide.none
            : BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsRow(
              context,
              Icons.family_restroom,
              'Guardian Mode',
              Switch(
                value: isGuardianMode,
                onChanged: (value) {
                  _showConfirmationDialog(value, isGuardianMode);
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF81C784),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade400,
              ),
              isGuardianMode: isGuardianMode,
            ),
            const SizedBox(height: 12),
            _buildSettingsRow(
              context,
              Icons.record_voice_over,
              'Voice Feedback (TTS)',
              Switch(
                value: ttsState.isTtsEnabled,
                onChanged: (value) {
                  ttsState.setTtsEnabled(value);
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF81C784),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade400,
              ),
              isGuardianMode: isGuardianMode,
            ),
            const Divider(height: 40),
            _buildSettingsActionRow(
              context,
              Icons.notifications_none,
              'Notification Settings',
              () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const NotificationSettingsScreen()),
                );
              },
              isGuardianMode: isGuardianMode,
            ),
            _buildSettingsActionRow(
              context,
              Icons.language,
              'Language',
              () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const LanguageSettingsScreen()),
                );
              },
              isGuardianMode: isGuardianMode,
            ),
            _buildSettingsActionRow(
              context,
              Icons.lock_outline,
              'Change Password',
              () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const ChangePasswordScreen()),
                );
              },
              isGuardianMode: isGuardianMode,
            ),
            if (isGuardianMode)
              _buildSettingsActionRow(
                context,
                Icons.help_outline,
                'Guardian Guide / Help',
                () {
                  Navigator.push(
                    context,
                    FadePageRoute(page: const GuardianGuideScreen()),
                  );
                },
                isGuardianMode: isGuardianMode,
              ),
            _buildSettingsActionRow(
              context,
              Icons.privacy_tip_outlined,
              'Terms & Privacy',
              () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const TermsPrivacyScreen()),
                );
              },
              isGuardianMode: isGuardianMode,
            ),
            _buildSettingsActionRow(
              context,
              Icons.logout,
              'Logout',
              () {
                _showLogoutConfirmationDialog(context, isGuardianMode);
              },
              isGuardianMode: isGuardianMode,
            ),
          ],
        ),
      ),
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

  Widget _buildSettingsRow(
      BuildContext context, IconData icon, String title, Widget trailing,
      {bool isGuardianMode = false}) {
    final tileColor = isGuardianMode ? Colors.white : Colors.black;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: tileColor.withAlpha(230)),
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
    final arrowColor = isGuardianMode ? Colors.white : tileColor.withAlpha(178);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: tileColor.withAlpha(230)),
      title: Text(
        title,
        style: TextStyle(color: tileColor, fontWeight: FontWeight.w500),
      ),
      trailing:
          Icon(Icons.arrow_forward_ios, color: arrowColor, size: 16),
      onTap: onTap,
    );
  }
}