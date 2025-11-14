import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/social_provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _textController = TextEditingController();
  XFile? _mediaFile;
  bool _isUploading = false;

  Future<void> _pickMedia(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _mediaFile = pickedFile;
      });
    }
  }

  void _submitPost() async {
    if (_textController.text.isEmpty && _mediaFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text or select a media file.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final socialProvider = Provider.of<SocialProvider>(context, listen: false);
    final type = _mediaFile != null ? 'media' : 'text';

    final success = await socialProvider.createPost(type, _textController.text, _mediaFile);

    if (mounted) {
      setState(() {
        _isUploading = false;
      });
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create post.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'What\'s on your mind? Share your career insights, questions, or achievements...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Media Preview
            if (_mediaFile != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_mediaFile!.path),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => setState(() => _mediaFile = null),
                  ),
                ],
              ),

            const SizedBox(height: 15),

            // Media Picker Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () => _pickMedia(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                TextButton.icon(
                  onPressed: () => _pickMedia(ImageSource.gallery),
                  icon: const Icon(Icons.image),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 25),

            _isUploading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _submitPost,
              child: const Text('Post to Feed'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}