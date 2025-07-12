import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tanaw_app/screens/login_screen.dart';
import 'package:tanaw_app/screens/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  int _autoPlayPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'icon': Icons.people_alt_outlined,
      'title': 'Welcome to Tanaw',
      'description':
          'Tanaw is a mobile app designed for the visually impaired and their guardians. Empowering independence through smart glasses and real-time support.',
    },
    {
      'icon': Icons.volume_up_outlined,
      'title': 'Object Detection Made Easy',
      'description':
          'The glasses detect obstacles like stairs or bins, and read them aloud instantly — helping the user move confidently.',
    },
    {
      'icon': Icons.mobile_screen_share_outlined,
      'title': 'Stay Connected with Guardian Mode',
      'description':
          "Guardians can view the user's device status, location, and detection history in real time.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      _autoPlayPage++;
      if (_autoPlayPage > 2) {
        timer.cancel();
        return;
      }
      if (_autoPlayPage > _currentPage) {
        _pageController.animateToPage(
          _autoPlayPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _onboardingData[index];
                  return _OnboardingPage(
                    icon: item['icon'],
                    title: item['title'],
                    description: item['description'],
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _onboardingData.length,
                      effect: const WormEffect(
                        activeDotColor: Color(0xFF153A5B),
                        dotColor: Colors.black26,
                        dotHeight: 10,
                        dotWidth: 10,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildAuthButton(
                      context: context,
                      label: 'Login',
                      isPrimary: true,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildAuthButton(
                      context: context,
                      label: 'Sign Up',
                      isPrimary: false,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButton({
    required BuildContext context,
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF153A5B),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF153A5B),
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: Color(0xFF153A5B), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF153A5B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 140, color: const Color(0xFF3E88BF)),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF153A5B),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
} 