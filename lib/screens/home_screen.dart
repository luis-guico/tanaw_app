import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tanaw_app/widgets/custom_bottom_nav_bar.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  String _lastDetectedObject = "Garbage Bin";
  String _deviceStatus = "Connected";
  String _batteryLevel = "80%";

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
    return GestureDetector(
      onVerticalDragUpdate: _handleVerticalDragUpdate,
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildDeviceStatus(),
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
                icon: Icons.bluetooth,
                text: 'Disconnect\nGlasses',
                onPressed: () => _speak("Disconnecting glasses"),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      ),
    );
  }

  Widget _buildDeviceStatus() {
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
          _deviceStatus,
          style: TextStyle(
            color: Colors.green.shade700,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.check_circle, color: Colors.green.shade700, size: 24),
      ],
    );
  }

  Widget _buildDetectedObjectCard() {
    return Container(
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
            _lastDetectedObject,
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
            color: Colors.grey.shade700,
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
        backgroundColor: const Color(0xFF153B6A),
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