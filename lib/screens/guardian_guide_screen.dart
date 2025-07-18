import 'package:flutter/material.dart';

class GuardianGuideScreen extends StatelessWidget {
  const GuardianGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardian Guide'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to Use Guardian Mode',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "TANAW's Guardian Mode allows you to monitor the visually impaired user in real time.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'You will receive updates when obstacles are detected (e.g., stairs, people, trash bins).',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'Make sure Guardian Mode is enabled to start monitoring.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'You can also view recent records, status, and battery level from your Guardian Home screen.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 