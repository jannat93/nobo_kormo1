import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import '../config/api_config.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class ProfileUpdateSheet extends StatefulWidget {
  final User user;
  const ProfileUpdateSheet({super.key, required this.user});

  @override
  State<ProfileUpdateSheet> createState() => _ProfileUpdateSheetState();
}

class _ProfileUpdateSheetState extends State<ProfileUpdateSheet> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;
  XFile? _newProfilePicture;
  String? _selectedExperienceLevel;

  final List<String> _experienceLevels = ['Fresher', 'Entry Level', 'Mid Level', 'Senior'];
  final List<String> _careerTracks = ['Software Development', 'Data Science', 'Marketing', 'Finance', 'HR'];
  final List<String> _educationLevels = ['High School', 'Diploma', 'Bachelor\'s', 'Master\'s', 'PhD'];


  @override
  void initState() {
    super.initState();
    _formData = {
      'education_level': widget.user.educationLevel,
      'preferred_career_track': widget.user.preferredCareerTrack,
      'experience_description': widget.user.experienceDescription,
      'career_interests': widget.user.careerInterests,
      'skills': widget.user.skills.join(','),
      'experience_level': widget.user.experienceLevel,
    };
    _selectedExperienceLevel = widget.user.experienceLevel;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _newProfilePicture = pickedFile;
    });
  }

  void _submitUpdate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Clean up data for API
      final Map<String, String> dataToSend = {};
      _formData.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          dataToSend[key] = value.toString();
        }
      });

      final success = await authProvider.updateProfile(
        dataToSend,
        filePath: _newProfilePicture?.path,
      );

      if (mounted) {
        if (success) {
          // Profile is successfully updated, close the sheet.
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProvider.error ?? 'Profile update failed.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Edit Profile Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
              const Divider(),

              // Profile Picture Uploader
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _newProfilePicture != null
                          ? FileImage(File(_newProfilePicture!.path)) as ImageProvider
                          : (widget.user.profilePictureUrl != null && widget.user.profilePictureUrl!.startsWith('http') ? NetworkImage(widget.user.profilePictureUrl!) : null),
                      child: (widget.user.profilePictureUrl == null || !widget.user.profilePictureUrl!.startsWith('http')) && _newProfilePicture == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: accentColor,
                          child: const Icon(Icons.camera_alt, size: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Experience Level Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Experience Level'),
                value: _selectedExperienceLevel,
                items: _experienceLevels.map((level) {
                  return DropdownMenuItem(value: level, child: Text(level));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExperienceLevel = value;
                    _formData['experience_level'] = value;
                  });
                },
                onSaved: (value) => _formData['experience_level'] = value,
              ),
              const SizedBox(height: 15),

              // Education Level Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Highest Education Level'),
                value: _formData['education_level'] as String?,
                items: _educationLevels.map((level) {
                  return DropdownMenuItem(value: level, child: Text(level));
                }).toList(),
                onChanged: (value) => setState(() => _formData['education_level'] = value),
                onSaved: (value) => _formData['education_level'] = value,
              ),
              const SizedBox(height: 15),

              // Career Track Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Preferred Career Track'),
                value: _formData['preferred_career_track'] as String?,
                items: _careerTracks.map((track) {
                  return DropdownMenuItem(value: track, child: Text(track));
                }).toList(),
                onChanged: (value) => setState(() => _formData['preferred_career_track'] = value),
                onSaved: (value) => _formData['preferred_career_track'] = value,
              ),
              const SizedBox(height: 15),

              // Skills Input
              TextFormField(
                initialValue: _formData['skills'] as String?,
                decoration: const InputDecoration(labelText: 'Skills (comma-separated: e.g., Dart, Flutter, API)'),
                onSaved: (value) => _formData['skills'] = value,
              ),
              const SizedBox(height: 15),

              // Career Interests
              TextFormField(
                initialValue: _formData['career_interests'] as String?,
                decoration: const InputDecoration(labelText: 'Career Interests/Goals'),
                onSaved: (value) => _formData['career_interests'] = value,
                maxLines: 2,
              ),
              const SizedBox(height: 25),

              // Submit Button
              auth.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _submitUpdate,
                child: const Text('Save Profile'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}