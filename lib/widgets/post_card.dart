import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../config/api_config.dart';
import '../models/post_model.dart';
import '../providers/social_provider.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  String _formatTimeAgo(DateTime date) {
    final duration = DateTime.now().difference(date);
    if (duration.inDays > 30) {
      return '${(duration.inDays / 30).floor()}mo ago';
    } else if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final socialProvider = Provider.of<SocialProvider>(context, listen: false);
    final user = post.author;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (User info)
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: user?.profilePictureUrl != null && user!.profilePictureUrl!.startsWith('http')
                      ? NetworkImage(user.profilePictureUrl!)
                      : null,
                  child: (user?.profilePictureUrl == null || !user!.profilePictureUrl!.startsWith('http'))
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.fullName ?? 'Unknown User', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(_formatTimeAgo(post.createdAt), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(post.contentType == 'text' ? Icons.chat : Icons.image, size: 18, color: primaryColor),
              ],
            ),
            const SizedBox(height: 10),

            // Content Text
            if (post.contentText != null && post.contentText!.isNotEmpty)
              Text(post.contentText!, style: const TextStyle(fontSize: 16)),

            // Media
            if (post.mediaUrl != null && post.mediaUrl!.startsWith('http'))
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.mediaUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Center(child: Text('Image failed to load')),
                    ),
                  ),
                ),
              ),

            const Divider(height: 20),

            // Actions (Like, Comment, Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: FontAwesomeIcons.thumbsUp,
                  count: post.likeCount,
                  label: 'Like',
                  onTap: () => socialProvider.toggleLike(post.id),
                ),
                _buildActionButton(
                    icon: FontAwesomeIcons.comment,
                    count: post.commentCount,
                    label: 'Comment',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => CommentDialog(postId: post.id),
                      );
                    }
                ),
                _buildActionButton(
                  icon: FontAwesomeIcons.share,
                  count: post.shareCount,
                  label: 'Share',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Simulated Share...')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required int count, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 16, color: primaryColor),
            const SizedBox(width: 5),
            Text(count.toString(), style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class CommentDialog extends StatefulWidget {
  final int postId;
  const CommentDialog({super.key, required this.postId});

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final _commentController = TextEditingController();

  void _submitComment() async {
    if (_commentController.text.isNotEmpty) {
      final socialProvider = Provider.of<SocialProvider>(context, listen: false);
      await socialProvider.addComment(widget.postId, _commentController.text);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment added!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a Comment'),
      content: TextField(
        controller: _commentController,
        decoration: const InputDecoration(hintText: 'Type your comment...'),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitComment,
          child: const Text('Post'),
        ),
      ],
    );
  }
}