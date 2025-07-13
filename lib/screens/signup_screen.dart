import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Soft blue background
      body: Stack(
        children: [
          // Top illustration part
          Container(
            height: screenHeight * 0.45,
            width: double.infinity,
            color: const Color(0xFF153A5B), // Tanaw blue
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/sign-up-page-animated.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Bottom card form
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.68,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Create an Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF153A5B),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      label: 'Email Address',
                      controller: emailController,
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'Password',
                      controller: passwordController,
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'Confirm Password',
                      controller: confirmPasswordController,
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF153A5B),
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('or connect with',
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14)),
                        ),
                        const Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                            icon: FontAwesomeIcons.google,
                            color: const Color(0xFFDB4437),
                            onPressed: () {}),
                        const SizedBox(width: 20),
                        _buildSocialButton(
                            icon: FontAwesomeIcons.apple,
                            color: Colors.black,
                            onPressed: () {}),
                        const SizedBox(width: 20),
                        _buildSocialButton(
                            icon: FontAwesomeIcons.facebook,
                            color: const Color(0xFF4267B2),
                            onPressed: () {}),
                      ],
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 15),
                          children: const [
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: Color(0xFF153A5B),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF153A5B),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF153A5B)),
            filled: true,
            fillColor: const Color(0xFFF3F6F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]),
        child: FaIcon(icon, color: color, size: 24),
      ),
    );
  }
}