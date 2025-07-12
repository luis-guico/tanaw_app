import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/screens/guardian_home_screen.dart';
import 'package:tanaw_app/screens/home_screen.dart';
import 'package:tanaw_app/screens/security_screen.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'package:tanaw_app/widgets/custom_bottom_nav_bar.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;

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
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  void _showConfirmationDialog(bool isEnabling, bool isCurrentlyDark) {
    final dialogBackgroundColor =
        isCurrentlyDark ? const Color(0xFF1A4A8A) : Colors.white;
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
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const GuardianHomeScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
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

    // Define colors based on the mode
    final backgroundColor =
        isGuardianMode ? const Color(0xFF0D47A1) : Colors.white;
    final textColor = isGuardianMode ? Colors.white : const Color(0xFF0D47A1);
    final buttonBackgroundColor =
        isGuardianMode ? Colors.white : const Color(0xFF153B6A);
    final buttonTextColor =
        isGuardianMode ? const Color(0xFF153B6A) : Colors.white;
    final switchActiveColor =
        isGuardianMode ? const Color(0xFF0D47A1) : Colors.white;
    final switchActiveTrackColor =
        isGuardianMode ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logo.png', width: 30),
            const SizedBox(width: 8),
            Text(
              'TANAW',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Icon(
                      Icons.person,
                      size: 40,
                      color: textColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'PROFILE',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/logo.png'),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Blind Dela Cruz',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    Text(
                      'GUARDIAN MODE',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Switch(
                      value: isGuardianMode,
                      onChanged: (value) {
                        _showConfirmationDialog(value, isGuardianMode);
                      },
                      activeColor: switchActiveColor,
                      activeTrackColor: switchActiveTrackColor,
                      inactiveThumbColor: const Color(0xFF0D47A1),
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                    const Divider(height: 60),
                    _buildProfileOption(
                      context: context,
                      icon: Icons.security_outlined,
                      title: 'Account Security',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SecurityScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            child: ElevatedButton(
              onPressed: isGuardianMode
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBackgroundColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: buttonBackgroundColor.withOpacity(0.5),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  color: buttonTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
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
    final textColor = isGuardianMode ? Colors.white : const Color(0xFF0D47A1);

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