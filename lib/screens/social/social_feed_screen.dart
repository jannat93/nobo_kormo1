import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/api_config.dart';
import '../../providers/social_provider.dart';
import '../../widgets/post_card.dart';
import 'create_post_screen.dart';

class SocialFeedScreen extends StatelessWidget {
  const SocialFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final social = Provider.of<SocialProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Community Feed')),
      body: social.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: social.fetchPosts,
        child: ListView.builder(
          itemCount: social.posts.length,
          itemBuilder: (context, index) {
            return PostCard(post: social.posts[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const CreatePostScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: accentColor,
      ),
    );
  }
}