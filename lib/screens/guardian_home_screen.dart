import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tanaw_app/screens/profile_screen.dart';
import 'package:tanaw_app/screens/status_screen.dart';
import 'package:tanaw_app/widgets/animated_bottom_nav_bar.dart';
import 'package:tanaw_app/widgets/fade_page_route.dart';
import 'package:tanaw_app/widgets/tanaw_logo.dart';

class GuardianHomeScreen extends StatefulWidget {
  const GuardianHomeScreen({super.key});

  @override
  GuardianHomeScreenState createState() => GuardianHomeScreenState();
}

class GuardianHomeScreenState extends State<GuardianHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final FlutterTts _flutterTts = FlutterTts();
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
        // Already on Guardian Home Screen
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          FadePageRoute(page: const ProfileScreen()),
        );
        break;
    }
  }

  final List<Map<String, dynamic>> _records = [
    {
      'type': 'STAIRS',
      'message': 'The designated team based on your report will be there soon.',
      'location': '- Maharlika Highway, Sto. Tomas City, Batangas 4234',
      'time': '10:42 AM',
      'icon': Icons.stairs_outlined,
    },
    {
      'type': 'HUMAN',
      'message': 'A person was detected nearby.',
      'location': '- General Malvar Street, Poblacion 2, Sto. Tomas City',
      'time': '10:41 AM',
      'icon': Icons.person_search_sharp,
    },
    {
      'type': 'GATE',
      'message': 'Approaching a gate. Proceed with caution.',
      'location': '- TANAW Office, Sto. Tomas City, Batangas',
      'time': '10:38 AM',
      'icon': Icons.fence,
    },
    {
      'type': 'DOOR',
      'message': 'A door was identified in the path.',
      'location': '- TANAW Office, Sto. Tomas City, Batangas',
      'time': '10:37 AM',
      'icon': Icons.meeting_room_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF102A43),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const TanawLogo(isGuardianMode: true),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_outlined, color: Colors.white),
            onPressed: () {
              final latestRecord = _records.first;
              _speak(
                  'Latest detection: ${latestRecord['type']}. ${latestRecord['message']}');
            },
            tooltip: 'Read Latest Record',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildDashboardSummary(),
            const SizedBox(height: 20),
            const Text(
              'GUARDIAN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Latest Records',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildTimeline()),
            _buildDeviceStatus(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildDashboardSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3356),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _DashboardItem(
            icon: Icons.location_on,
            title: 'Location',
            value: 'Active',
            tooltip: 'Location tracking is active and sharing.',
          ),
          _DashboardItem(
            icon: Icons.watch_later,
            title: 'Last Detected',
            value: '2 mins ago',
            tooltip: 'Time since the last object was detected.',
          ),
          _DashboardItem(
            icon: Icons.receipt_long,
            title: 'Total Records',
            value: '8',
            tooltip: 'Total objects detected in this session.',
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceStatus() {
    return Center(
      child: Column(
        children: [
          const Text("User's Device Status:",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          Chip(
            avatar: const Icon(Icons.check_circle, color: Colors.white, size: 20),
            label: const Text('Connected'),
            backgroundColor: const Color(0xFF0F3356),
            labelStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return ListView.builder(
      itemCount: _records.length,
      itemBuilder: (context, index) {
        final record = _records[index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          color: const Color(0xFF0F3356),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            leading: Icon(record['icon'], color: Colors.white, size: 32),
            title: Text(
              'Encountered: ${record['type']}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              record['message'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record['message'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            record['location'],
                            style: const TextStyle(
                                color: Colors.white70,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled_outlined,
                            size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          record['time'],
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String tooltip;

  const _DashboardItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 