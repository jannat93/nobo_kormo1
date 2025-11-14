import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/post_model.dart';
import '../services/api_service.dart';


class SocialProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _api.get('/posts');
      if (response.statusCode == 200) {
        final List<dynamic> postList = json.decode(response.body)['data'];
        // Sort posts by creation date (newest first)
        _posts = postList.map((p) => Post.fromJson(p)).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createPost(String type, String? text, XFile? mediaFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final bodyFields = {
        'content_type': type,
        'content_text': text ?? '',
      };

      String? filePath = mediaFile?.path;
      String fieldName = 'media';

      final response = await _api.multipartPost('/posts', fieldName, filePath, bodyFields);
      await response.stream.last; // Wait for the stream to complete

      if (response.statusCode == 201) {
        await fetchPosts(); // Refresh feed
        return true;
      }
    } catch (e) {
      print('Error creating post: $e');
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> toggleLike(int postId) async {
    try {
      final response = await _api.post('/posts/$postId/like', {});
      if (response.statusCode == 200) {
        await fetchPosts(); // Simple refresh for state update
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<void> addComment(int postId, String content) async {
    try {
      final response = await _api.post('/posts/$postId/comment', {'content': content});
      if (response.statusCode == 201) {
        await fetchPosts(); // Simple refresh for state update
      }
    } catch (e) {
      print('Error adding comment: $e');
    }
  }
}