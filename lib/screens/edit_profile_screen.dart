import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'package:tanaw_app/state/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _userImagePath;
  String? _guardianImagePath;

  @override
  void initState() {
    super.initState();
    final profileState = Provider.of<ProfileState>(context, listen: false);
    final isGuardianMode =
        Provider.of<GuardianModeState>(context, listen: false)
            .isGuardianModeEnabled;
    _nameController = TextEditingController(
      text: isGuardianMode ? profileState.guardianName : profileState.userName,
    );
    _emailController = TextEditingController(
      text:
          isGuardianMode ? profileState.guardianEmail : profileState.userEmail,
    );
    _phoneController = TextEditingController(
      text:
          isGuardianMode ? profileState.guardianPhone : profileState.userPhone,
    );
    if (isGuardianMode) {
      _guardianImagePath = profileState.guardianImagePath;
    } else {
      _userImagePath = profileState.userImagePath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (Provider.of<GuardianModeState>(context, listen: false)
            .isGuardianModeEnabled) {
          _guardianImagePath = pickedFile.path;
        } else {
          _userImagePath = pickedFile.path;
        }
      });
    }
  }

  void _saveProfile() {
    final profileState = Provider.of<ProfileState>(context, listen: false);
    final isGuardianMode =
        Provider.of<GuardianModeState>(context, listen: false)
            .isGuardianModeEnabled;

    if (isGuardianMode) {
      profileState.updateGuardianName(_nameController.text);
      profileState.updateGuardianEmail(_emailController.text);
      profileState.updateGuardianPhone(_phoneController.text);
      if (_guardianImagePath != null) {
        profileState.updateGuardianImage(_guardianImagePath!);
      }
    } else {
      profileState.updateUserName(_nameController.text);
      profileState.updateUserEmail(_emailController.text);
      profileState.updateUserPhone(_phoneController.text);
      if (_userImagePath != null) {
        profileState.updateUserImage(_userImagePath!);
      }
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isGuardianMode =
        Provider.of<GuardianModeState>(context).isGuardianModeEnabled;
    final profileState = Provider.of<ProfileState>(context);

    // Define Theme Colors
    final Color backgroundColor =
        isGuardianMode ? const Color(0xFF0F243D) : Colors.white;
    final Color textColor = isGuardianMode ? Colors.white : Colors.black;
    final Color fieldBackgroundColor =
        isGuardianMode ? const Color(0xFF1C3B5A) : const Color(0xFFF5F5F5);
    final Color dividerColor =
        isGuardianMode ? const Color(0xFF345B78) : const Color(0xFFDDDDDD);
    final Color accentColor =
        isGuardianMode ? Colors.greenAccent : Colors.green;

    

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: accentColor),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: isGuardianMode
                          ? (_guardianImagePath != null
                              ? FileImage(File(_guardianImagePath!))
                              : (profileState.guardianImagePath != null
                                  ? FileImage(File(profileState.guardianImagePath!))
                                  : const AssetImage('assets/TANAW-LOGO2.0.png'))
                                  as ImageProvider)
                          : (_userImagePath != null
                              ? FileImage(File(_userImagePath!))
                              : (profileState.userImagePath != null
                                  ? FileImage(File(profileState.userImagePath!))
                                  : const AssetImage('assets/TANAW-LOGO2.0.png'))
                                  as ImageProvider),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: fieldBackgroundColor,
                        child: Icon(
                          Icons.camera_alt,
                          color: textColor.withAlpha(179),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField(
                _nameController, 'Name', textColor, fieldBackgroundColor),
            const SizedBox(height: 20),
            _buildTextField(_emailController, 'E-mail address', textColor,
                fieldBackgroundColor),
            const SizedBox(height: 20),
            _buildTextField(_phoneController, 'Phone number', textColor,
                fieldBackgroundColor),
            const SizedBox(height: 40),
            Divider(color: dividerColor),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                // TODO: Implement delete account functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      Color textColor, Color fieldBackgroundColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor.withAlpha(204),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
} 