class FaqItem {
  final String question;
  final String answer;
  final String category;

  FaqItem({required this.question, required this.answer, required this.category});
}

final List<FaqItem> faqItems = [
  // Getting Started
  FaqItem(
    question: 'How do I enable Guardian Mode?',
    answer: 'Go to your Profile page and switch the Guardian Mode toggle. You’ll instantly begin monitoring the paired user device.',
    category: 'Getting Started',
  ),
  FaqItem(
    question: 'How do I connect to the IoT glasses?',
    answer: 'Make sure Bluetooth is on and the glasses are nearby. Tap “Connect Device” on the home screen.',
    category: 'Getting Started',
  ),
  // Monitoring
  FaqItem(
    question: 'What do the detected objects mean?',
    answer: 'Reports like “STAIRS,” “GARBAGE BIN,” or “MOVEMENT: HUMAN” are real-time detections from the user’s environment.',
    category: 'Monitoring',
  ),
  FaqItem(
    question: 'How accurate is the data?',
    answer: 'The glasses use object detection. If something is misidentified, please report it via the Feedback section (coming soon).',
    category: 'Monitoring',
  ),
  // Notifications
  FaqItem(
    question: 'What alerts will I receive?',
    answer: 'You’ll be notified if the glasses detect movement, obstacles, or if the battery is low or disconnected.',
    category: 'Notifications',
  ),
  FaqItem(
    question: 'Can I customize which alerts I get?',
    answer: 'Yes. Go to Notification Settings and toggle alerts such as Voice, Vibration, Battery, and Mode changes.',
    category: 'Notifications',
  ),
  // Modes
  FaqItem(
    question: 'What happens when Guardian Mode is on?',
    answer: 'You’ll monitor the user in real-time. Your Status page will show obstacle detections and last known location.',
    category: 'Modes',
  ),
  FaqItem(
    question: 'Can I switch modes anytime?',
    answer: 'Yes, via the Profile page. Switching modes does not affect the app\'s existing functionality.',
    category: 'Modes',
  ),
  // Account & Settings
  FaqItem(
    question: 'How do I update my profile picture?',
    answer: 'Tap your profile image to upload a new one from your device.',
    category: 'Account & Settings',
  ),
  FaqItem(
    question: 'Can I turn off Text-to-Speech (TTS)?',
    answer: 'Only users (not guardians) have TTS. In the user profile, toggle the Voice Feedback setting.',
    category: 'Account & Settings',
  ),
  // Troubleshooting
  FaqItem(
    question: 'The device won’t connect. What should I do?',
    answer: 'Check Bluetooth, ensure the glasses are powered, and retry connection.',
    category: 'Troubleshooting',
  ),
  FaqItem(
    question: 'Why am I not receiving alerts?',
    answer: 'Confirm that notifications are enabled in both your app settings and system settings.',
    category: 'Troubleshooting',
  ),
]; 