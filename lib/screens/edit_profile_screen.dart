import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';
import 'package:tanaw_app/state/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _imageFile;

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
        _imageFile = File(pickedFile.path);
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
      if (_imageFile != null) {
        profileState.updateGuardianImage(_imageFile!);
      }
    } else {
      profileState.updateUserName(_nameController.text);
      profileState.updateUserEmail(_emailController.text);
      profileState.updateUserPhone(_phoneController.text);
      if (_imageFile != null) {
        profileState.updateUserImage(_imageFile!);
      }
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isGuardianMode =
        Provider.of<GuardianModeState>(context).isGuardianModeEnabled;
    final profileState = Provider.of<ProfileState>(context);
    final theme = isGuardianMode
        ? ThemeData.dark().copyWith(
            primaryColor: const Color(0xFF14375F),
            scaffoldBackgroundColor: const Color(0xFF102A43),
            colorScheme:
                const ColorScheme.dark().copyWith(secondary: Colors.cyanAccent),
          )
        : ThemeData.light();
    final dividerColor =
        isGuardianMode ? Colors.white24 : Colors.grey.shade300;

    final currentImage =
        isGuardianMode ? profileState.guardianImage : profileState.userImage;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            TextButton(
              onPressed: _saveProfile,
              child: Text(
                'Done',
                style: TextStyle(
                    color: isGuardianMode ? Colors.white : Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (currentImage != null
                                ? FileImage(currentImage)
                                : const AssetImage('assets/logo.png'))
                                as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              isGuardianMode ? Colors.grey[800] : Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            color: isGuardianMode ? Colors.white70 : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                  _nameController, 'Name', isGuardianMode),
              const SizedBox(height: 20),
              _buildTextField(
                  _emailController, 'Mail Address', isGuardianMode),
              const SizedBox(height: 20),
              _buildTextField(
                  _phoneController, 'Phone Number', isGuardianMode),
              const SizedBox(height: 40),
              Divider(color: dividerColor),
              ListTile(
                title: const Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  // TODO: Implement delete account functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isGuardianMode) {
    return TextField(
      controller: controller,
      style: TextStyle(color: isGuardianMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isGuardianMode ? Colors.white70 : Colors.grey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: isGuardianMode ? Colors.white24 : Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: isGuardianMode ? Colors.cyanAccent : const Color(0xFF153A5B)),
        ),
      ),
    );
  }
} 