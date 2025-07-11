import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isConnected = true; 
  String detectedObject = "Garbage Bin";

  Timer? detectionTimer;

  void connectDevice() {
    setState(() {
      isConnected = true;
      detectedObject = "Initializing...";
    });
    startDetection();
  }

  void disconnectDevice() {
    setState(() {
      isConnected = false;
      detectedObject = "None";
    });
    detectionTimer?.cancel();
  }

  void startDetection() {
    detectionTimer?.cancel();
    detectionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!isConnected) {
        timer.cancel();
        return;
      }
      List<String> objects = [
        "Garbage Bin",
        "Stairs",
        "Door",
        "Human Movement",
        "Gate"
      ];
      setState(() {
        detectedObject = (objects..shuffle()).first;
      });
    });
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
    
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    detectionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logo.png', width: 30),
            const SizedBox(width: 8),
            const Text(
              'TANAW',
              style: TextStyle(
                color: Color(0xFF0D47A1),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Device Status: ',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Connected',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.check_circle, color: Colors.green.shade700, size: 24),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF0D47A1), width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Detected:',
                      style: TextStyle(fontSize: 20, color: Color(0xFF0D47A1)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      detectedObject,
                      style: const TextStyle(
                        fontSize: 36,
                        color: Color(0xFF0D47A1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Icon(
                      Icons.volume_up,
                      size: 50,
                      color: isConnected ? Colors.grey.shade700 : Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildActionButton(
                icon: FontAwesomeIcons.batteryFull,
                text: 'Check Device Battery',
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Battery Level: 85%'),
                        ),
                      );
                },
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: FontAwesomeIcons.bluetoothB,
                text: 'Disconnect Glasses',
                onPressed: disconnectDevice,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF0D47A1),
        unselectedItemColor: Colors.grey.shade600,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0D47A1),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
      icon: FaIcon(icon, color: Colors.white, size: 24),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}