

import 'package:nobo_kormo/models/user_model.dart';

class Post {
  final int id;
  final String contentType;
  final String? contentText;
  final String? mediaUrl;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final DateTime createdAt;
  final User? author;

  Post({
    required this.id,
    required this.contentType,
    this.contentText,
    this.mediaUrl,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.createdAt,
    this.author,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      contentType: json['content_type'],
      contentText: json['content_text'],
      mediaUrl: json['media_url'],
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      shareCount: json['share_count'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      author: json['User'] != null ? User.fromJson(json['User']) : null,
    );
  }
}