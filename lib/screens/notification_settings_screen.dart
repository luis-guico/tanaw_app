import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _activityAlerts = true;
  bool _guardianModeAlerts = true;
  bool _soundAndVibration = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _activityAlerts = prefs.getBool('activityAlerts') ?? true;
      _guardianModeAlerts = prefs.getBool('guardianModeAlerts') ?? true;
      _soundAndVibration = prefs.getBool('soundAndVibration') ?? true;
    });
  }

  Future<void> _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Activity Alerts'),
            subtitle: const Text('Receive alerts when something is detected'),
            value: _activityAlerts,
            onChanged: (bool value) {
              setState(() {
                _activityAlerts = value;
              });
              _updateSetting('activityAlerts', value);
            },
          ),
          SwitchListTile(
            title: const Text('Enable Guardian Mode Alerts'),
            subtitle: const Text('Receive alerts related to Guardian Mode'),
            value: _guardianModeAlerts,
            onChanged: (bool value) {
              setState(() {
                _guardianModeAlerts = value;
              });
              _updateSetting('guardianModeAlerts', value);
            },
          ),
          SwitchListTile(
            title: const Text('Enable Sound or Vibration'),
            subtitle: const Text('Get audio or haptic feedback for alerts'),
            value: _soundAndVibration,
            onChanged: (bool value) {
              setState(() {
                _soundAndVibration = value;
              });
              _updateSetting('soundAndVibration', value);
            },
          ),
        ],
      ),
    );
  }
} 