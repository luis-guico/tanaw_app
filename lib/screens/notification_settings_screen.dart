import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  NotificationSettingsScreenState createState() =>
      NotificationSettingsScreenState();
}

class NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  // VI User Settings
  bool _voiceAlerts = true;
  bool _vibrationAlerts = true;
  bool _batteryAlerts = true;
  bool _connectionStatus = true;
  bool _modeActivated = true;

  // Guardian Settings
  bool _obstacleDetected = true;
  bool _movementDetected = true;
  bool _lowBatteryWarning = true;
  bool _deviceDisconnected = true;
  bool _locationUpdates = true;
  bool _guardianModeActivated = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // VI User Settings
      _voiceAlerts = prefs.getBool('voiceAlerts') ?? true;
      _vibrationAlerts = prefs.getBool('vibrationAlerts') ?? true;
      _batteryAlerts = prefs.getBool('batteryAlerts') ?? true;
      _connectionStatus = prefs.getBool('connectionStatus') ?? true;
      _modeActivated = prefs.getBool('modeActivated') ?? true;

      // Guardian Settings
      _obstacleDetected = prefs.getBool('obstacleDetected') ?? true;
      _movementDetected = prefs.getBool('movementDetected') ?? true;
      _lowBatteryWarning = prefs.getBool('lowBatteryWarning') ?? true;
      _deviceDisconnected = prefs.getBool('deviceDisconnected') ?? true;
      _locationUpdates = prefs.getBool('locationUpdates') ?? true;
      _guardianModeActivated = prefs.getBool('guardianModeActivated') ?? true;
    });
  }

  Future<void> _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GuardianModeState>(
      builder: (context, guardianState, child) {
        final bool isGuardianMode = guardianState.isGuardianModeEnabled;
        final theme = isGuardianMode ? _darkTheme : _lightTheme;

        return Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            backgroundColor: theme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.textColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Notification Settings',
              style: TextStyle(color: theme.textColor),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isGuardianMode)
                  ..._buildGuardianSettings(theme)
                else
                  ..._buildViUserSettings(theme),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (!isGuardianMode) {
                      _speak('Settings updated');
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.buttonColor,
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Update Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.buttonTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildViUserSettings(_NotificationTheme theme) {
    return [
      _buildSwitchTile(
        'Voice Alerts',
        'Spoken obstacle alerts',
        _voiceAlerts,
        (value) {
          setState(() => _voiceAlerts = value);
          _updateSetting('voiceAlerts', value);
          _speak('Voice Alerts ${value ? 'enabled' : 'disabled'}');
        },
        theme,
      ),
      _buildSwitchTile(
        'Vibration Alerts',
        'Physical feedback',
        _vibrationAlerts,
        (value) {
          setState(() => _vibrationAlerts = value);
          _updateSetting('vibrationAlerts', value);
          _speak('Vibration Alerts ${value ? 'enabled' : 'disabled'}');
        },
        theme,
      ),
      _buildSwitchTile(
        'Battery Alerts',
        'Low battery notification',
        _batteryAlerts,
        (value) {
          setState(() => _batteryAlerts = value);
          _updateSetting('batteryAlerts', value);
          _speak('Battery Alerts ${value ? 'enabled' : 'disabled'}');
        },
        theme,
      ),
      _buildSwitchTile(
        'Connection Status',
        'Notify if glasses disconnect',
        _connectionStatus,
        (value) {
          setState(() => _connectionStatus = value);
          _updateSetting('connectionStatus', value);
          _speak('Connection Status alerts ${value ? 'enabled' : 'disabled'}');
        },
        theme,
      ),
      _buildSwitchTile(
        'Mode Activated',
        'Notify if Guardian Mode changes',
        _modeActivated,
        (value) {
          setState(() => _modeActivated = value);
          _updateSetting('modeActivated', value);
          _speak('Mode Activated alerts ${value ? 'enabled' : 'disabled'}');
        },
        theme,
      ),
    ];
  }

  List<Widget> _buildGuardianSettings(_NotificationTheme theme) {
    return [
      _buildSectionTitle('Monitoring Alerts', theme),
      _buildSwitchTile(
        'Obstacle Detected',
        'Alert when glasses detect stairs, objects, etc.',
        _obstacleDetected,
        (value) {
          setState(() => _obstacleDetected = value);
          _updateSetting('obstacleDetected', value);
        },
        theme,
      ),
      _buildSwitchTile(
        'Movement Detected',
        'Alert when the user starts moving.',
        _movementDetected,
        (value) {
          setState(() => _movementDetected = value);
          _updateSetting('movementDetected', value);
        },
        theme,
      ),
      _buildSwitchTile(
        'Low Battery Warning',
        'Notify guardian if device battery is low.',
        _lowBatteryWarning,
        (value) {
          setState(() => _lowBatteryWarning = value);
          _updateSetting('lowBatteryWarning', value);
        },
        theme,
      ),
      _buildSwitchTile(
        'Device Disconnected',
        'If IoT glasses disconnect from the app.',
        _deviceDisconnected,
        (value) {
          setState(() => _deviceDisconnected = value);
          _updateSetting('deviceDisconnected', value);
        },
        theme,
      ),
      _buildSwitchTile(
        'Location Updates',
        'Sends periodic or triggered location alerts.',
        _locationUpdates,
        (value) {
          setState(() => _locationUpdates = value);
          _updateSetting('locationUpdates', value);
        },
        theme,
      ),
    ];
  }

  Widget _buildSectionTitle(String title, _NotificationTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: theme.textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    _NotificationTheme theme,
  ) {
    return Semantics(
      label: '$title. $subtitle',
      child: SwitchListTile.adaptive(
        title: Text(title, style: TextStyle(color: theme.textColor)),
        subtitle: subtitle.isNotEmpty
            ? Text(subtitle, style: TextStyle(color: theme.subtitleColor))
            : null,
        value: value,
        onChanged: onChanged,
        activeColor: theme.toggleOnColor,
        inactiveTrackColor: theme.toggleOffColor,
      ),
    );
  }
}

class _NotificationTheme {
  final Color backgroundColor;
  final Color textColor;
  final Color subtitleColor;
  final Color toggleOnColor;
  final Color toggleOffColor;
  final Color buttonColor;
  final Color buttonTextColor;

  _NotificationTheme({
    required this.backgroundColor,
    required this.textColor,
    required this.subtitleColor,
    required this.toggleOnColor,
    required this.toggleOffColor,
    required this.buttonColor,
    required this.buttonTextColor,
  });
}

final _lightTheme = _NotificationTheme(
  backgroundColor: const Color(0xFFE3F2FD),
  textColor: Colors.black87,
  subtitleColor: Colors.grey.shade600,
  toggleOnColor: const Color(0xFF173C61),
  toggleOffColor: Colors.grey.shade300,
  buttonColor: const Color(0xFF173C61),
  buttonTextColor: Colors.white,
);

final _darkTheme = _NotificationTheme(
  backgroundColor: const Color(0xFF102A43),
  textColor: Colors.white,
  subtitleColor: Colors.white70,
  toggleOnColor: Colors.tealAccent,
  toggleOffColor: Colors.grey.shade700,
  buttonColor: Colors.white,
  buttonTextColor: const Color(0xFF102A43),
); 