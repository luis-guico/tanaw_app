import 'dart:async';
import 'package:flutter/material.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isConnected = false;
  String detectedObject = "None";

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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ReportsScreen()),
      );
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
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', width: 40, height: 40),
            const SizedBox(width: 8),
            const Text('TANAW'),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D47A1),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Device Status: ${isConnected ? "Connected ✅" : "Disconnected ❌"}',
              style: TextStyle(
                color: isConnected ? Colors.green : Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF0D47A1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Detected:',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      detectedObject,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xFF0D47A1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Icon(
                      Icons.volume_up,
                      size: 40,
                      color: isConnected ? const Color(0xFF0D47A1) : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnected ? null : connectDevice,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Connect Glasses',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isConnected ? disconnectDevice : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Disconnect Glasses',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isConnected
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Battery Level: 85%'),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Check Device Battery',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF0D47A1),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}