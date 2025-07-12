import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'package:tanaw_app/widgets/custom_bottom_nav_bar.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isGuardianMode =
        Provider.of<GuardianModeState>(context).isGuardianModeEnabled;

    final backgroundColor =
        isGuardianMode ? const Color(0xFF1A3D7A) : Colors.grey.shade100;
    final appBarColor =
        isGuardianMode ? const Color(0xFF153B6A) : Colors.white;
    final appBarTextColor = isGuardianMode ? Colors.white : Colors.black87;
    final cardColor =
        isGuardianMode ? Colors.white.withAlpha(242) : Colors.white;
    final cardTitleColor =
        isGuardianMode ? const Color(0xFF153B6A) : Colors.black87;
    final cardContentColor =
        isGuardianMode ? Colors.grey.shade800 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appBarColor,
        elevation: 2,
        title: Row(
          children: [
            Image.asset('assets/logo.png', width: 30),
            const SizedBox(width: 8),
            Text(
              'DEVICE STATUS',
              style: TextStyle(
                color: appBarTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: isGuardianMode
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2C5DA7).withAlpha(204),
                    const Color(0xFF1A3D7A).withAlpha(230),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              )
            : null,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            _buildInfoCard(
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
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildInfoCard({
    required Color cardColor,
    required Color titleColor,
    required Color contentColor,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      color: cardColor,
      elevation: 4,
      shadowColor: Colors.black.withAlpha(51),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            style:
                TextStyle(fontSize: 15, color: contentColor.withAlpha(230)),
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