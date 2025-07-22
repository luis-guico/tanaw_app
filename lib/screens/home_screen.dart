import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/screens/profile_screen.dart';
import 'package:tanaw_app/screens/status_screen.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'package:tanaw_app/state/tts_state.dart';
import 'package:tanaw_app/widgets/animated_bottom_nav_bar.dart';
import 'package:tanaw_app/widgets/app_logo.dart';
import 'package:tanaw_app/widgets/fade_page_route.dart';
import 'package:tanaw_app/state/connection_state.dart' as app_connection;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final String _lastDetectedObject = "Garbage Bin";
  final String _batteryLevel = "80%";
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          FadePageRoute(page: const StatusScreen()),
        );
        break;
      case 1:
        // Already on Home Screen
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          FadePageRoute(page: const ProfileScreen()),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _setupTts();
  }

  Future<void> _setupTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    HapticFeedback.lightImpact();
    await _flutterTts.speak(text);
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dy < -10) {
      _speak("Last detected object was $_lastDetectedObject");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ttsState = Provider.of<TtsState>(context);
    final connectionState = Provider.of<app_connection.ConnectionState>(context);

    Widget screenContent = Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: AppLogo(
            isGuardianMode:
                Provider.of<GuardianModeState>(context).isGuardianModeEnabled,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildDeviceStatus(connectionState.isConnected),
              const SizedBox(height: 24),
              _buildDetectedObjectCard(),
              const SizedBox(height: 32),
              _buildActionButton(
                icon: Icons.battery_charging_full,
                text: 'Check Device\nBattery',
                onPressed: () => _speak("Battery is at $_batteryLevel"),
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: connectionState.isConnected ? Icons.bluetooth : Icons.bluetooth_disabled,
                text: connectionState.isConnected ? 'Disconnect\nGlasses' : 'Connect\nGlasses',
                onPressed: () {
                  _speak(connectionState.isConnected ? "Disconnecting glasses" : "Connecting glasses");
                  connectionState.toggleConnection();
                },
              ),

            ],
          ),
        ),
        bottomNavigationBar: AnimatedBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
    );

    if (ttsState.isTtsEnabled) {
      return GestureDetector(
        onVerticalDragUpdate: _handleVerticalDragUpdate,
        child: screenContent,
      );
    } else {
      return screenContent;
    }
  }

  Widget _buildDeviceStatus(bool isConnected) {
    final statusText = isConnected ? 'Connected' : 'Disconnected';
    final statusColor = isConnected ? Colors.green.shade700 : Colors.red.shade700;
    final statusIcon = isConnected ? Icons.check_circle : Icons.cancel;

    return Row(
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
          statusText,
          style: TextStyle(
            color: statusColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Icon(statusIcon, color: statusColor, size: 24),
      ],
    );
  }

  Widget _buildDetectedObjectCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF163C63), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Detected:',
            style: TextStyle(fontSize: 20, color: Color(0xFF163C63)),
          ),
          const SizedBox(height: 8),
          Text(
            _lastDetectedObject,
            style: const TextStyle(
              fontSize: 36,
              color: Color(0xFF163C63),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => _speak("Last detected object was $_lastDetectedObject"),
            child: Semantics(
              label: 'Speak Last Detection',
              child: Icon(
                Icons.volume_up,
                size: 50,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required IconData icon,
      required String text,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF163C63),
        minimumSize: const Size(double.infinity, 96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 48),
          const SizedBox(width: 20),
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}