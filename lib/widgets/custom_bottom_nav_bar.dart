import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/screens/guardian_home_screen.dart';
import 'package:tanaw_app/screens/home_screen.dart';
import 'package:tanaw_app/screens/profile_screen.dart';
import 'package:tanaw_app/screens/status_screen.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final guardianModeState = Provider.of<GuardianModeState>(context);
    final isGuardianMode = guardianModeState.isGuardianModeEnabled;

    void onItemTapped(int index) {
      if (index == currentIndex) return;

      Widget destination;
      switch (index) {
        case 0:
          destination = const StatusScreen();
          break;
        case 1:
          destination =
              isGuardianMode ? const GuardianHomeScreen() : const HomeScreen();
          break;
        case 2:
          destination = const ProfileScreen();
          break;
        default:
          return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemTapped,
      selectedItemColor: const Color(0xFF0D47A1),
      unselectedItemColor: Colors.grey.shade600,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Status',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.person),
              if (isGuardianMode)
                Positioned(
                  top: -2,
                  right: -4,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          label: 'Profile',
        ),
      ],
    );
  }
} 