import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/screens/home_screen.dart';
import 'package:tanaw_app/screens/profile_screen.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'package:tanaw_app/widgets/animated_bottom_nav_bar.dart';
import 'package:tanaw_app/widgets/app_logo.dart';
import 'package:tanaw_app/widgets/fade_page_route.dart';
import 'package:tanaw_app/screens/guardian_home_screen.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  StatusScreenState createState() => StatusScreenState();
}

class StatusScreenState extends State<StatusScreen> {
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final isGuardianMode =
        Provider.of<GuardianModeState>(context).isGuardianModeEnabled;

    final cardColor =
        isGuardianMode ? const Color(0xFF163C63) : Colors.white;
    final cardTitleColor = isGuardianMode ? Colors.white : Colors.black87;
    final cardContentColor =
        isGuardianMode ? Colors.white : Colors.black54;

    return Scaffold(
      backgroundColor:
          isGuardianMode ? const Color(0xFF102A43) : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            isGuardianMode ? Colors.transparent : Colors.white,
        elevation: 0,
        title: AppLogo(isGuardianMode: isGuardianMode),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildInfoCard(
            isGuardianMode: isGuardianMode,
            cardColor: cardColor,
            titleColor: cardTitleColor,
            contentColor: cardContentColor,
            title: 'Device Connection',
            icon: Icons.wifi_tethering_rounded,
            children: [
              _buildInfoRow('Status', 'Connected', cardContentColor,
                  Icons.check_circle, Colors.green),
              _buildInfoRow('Last Synced', '1 min ago', cardContentColor,
                  Icons.sync_rounded),
              _buildInfoRow('Signal Strength', 'Excellent', cardContentColor,
                  Icons.signal_cellular_alt_rounded),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoCard(
            isGuardianMode: isGuardianMode,
            cardColor: cardColor,
            titleColor: cardTitleColor,
            contentColor: cardContentColor,
            title: 'TANAW Glass Battery',
            icon: Icons.battery_charging_full_rounded,
            children: [
              _buildInfoRow('Level', '92%', cardContentColor,
                  Icons.battery_6_bar_rounded, Colors.teal),
              _buildInfoRow(
                  'Status', 'Charging', cardContentColor, Icons.power_rounded),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoCard(
            isGuardianMode: isGuardianMode,
            cardColor: cardColor,
            titleColor: cardTitleColor,
            contentColor: cardContentColor,
            title: 'User Information',
            icon: Icons.person_pin_circle_rounded,
            children: [
              _buildInfoRow(
                  'Current Mode',
                  isGuardianMode ? 'Guardian' : 'Normal',
                  cardContentColor,
                  isGuardianMode
                      ? Icons.security_rounded
                      : Icons.person_outline_rounded,
                  isGuardianMode ? Colors.blueAccent : Colors.grey),
              _buildInfoRow('Last Known Location', 'Sto. Tomas, Batangas',
                  cardContentColor, Icons.location_on_outlined),
            ],
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildInfoCard({
    required bool isGuardianMode,
    required Color cardColor,
    required Color titleColor,
    required Color contentColor,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      color: cardColor,
      elevation: isGuardianMode ? 4 : 2,
      shadowColor: isGuardianMode ? Colors.black.withAlpha(51) : Colors.grey.withAlpha(100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isGuardianMode ? BorderSide.none : BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: titleColor, size: 28),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: titleColor),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 0.5),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, Color contentColor,
      [IconData? icon, Color? iconColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15, color: contentColor.withAlpha(230)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Icon(icon,
                        size: 20, color: iconColor ?? contentColor),
                  ),
                if (icon != null) const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: contentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 