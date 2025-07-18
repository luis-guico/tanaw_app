import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ManageSessionsScreen extends StatefulWidget {
  const ManageSessionsScreen({super.key});

  @override
  ManageSessionsScreenState createState() => ManageSessionsScreenState();
}

class ManageSessionsScreenState extends State<ManageSessionsScreen> {
  final List<Map<String, String>> _sessions = [
    {
      'device': 'Pixel 6 Pro',
      'location': 'Manila, PH',
      'status': 'This device',
    },
    {
      'device': 'Chrome on Windows',
      'location': 'Quezon City, PH',
      'status': 'Active',
    },
    {
      'device': 'iPhone 14',
      'location': 'Cebu City, PH',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Active Sessions'),
        backgroundColor: const Color(0xFF153B6A),
      ),
      body: ListView.separated(
        itemCount: _sessions.length,
        padding: const EdgeInsets.all(16.0),
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final session = _sessions[index];
          final isCurrentDevice = session['status'] == 'This device';

          return ListTile(
            leading: Icon(
              isCurrentDevice
                  ? Icons.phone_android_outlined
                  : Icons.desktop_windows_outlined,
              color: const Color(0xFF153B6A),
              size: 32,
            ),
            title: Text(
              session['device']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(session['location']!),
            trailing: isCurrentDevice
                ? Text(
                    'Current',
                    style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold),
                  )
                : TextButton(
                    child: const Text('Sign Out'),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _sessions.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Session signed out.')),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
} 