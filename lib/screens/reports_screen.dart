import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> records = [
      {'title': 'Encountered: STAIRS', 'desc': 'Mabini St., Batangas City'},
      {'title': 'Movement: HUMAN', 'desc': 'San Jose St., Batangas City'},
      {'title': 'Encountered: GATE', 'desc': 'P. Burgos St., Batangas City'},
      {'title': 'Blockage: DOOR', 'desc': 'Rizal Ave., Batangas City'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardian Records'),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF0D47A1)),
            ),
            child: ListTile(
              title: Text(records[index]['title']!,
                  style: const TextStyle(
                      color: Color(0xFF0D47A1),
                      fontWeight: FontWeight.bold)),
              subtitle: Text(records[index]['desc']!),
            ),
          );
        },
      ),
    );
  }
}