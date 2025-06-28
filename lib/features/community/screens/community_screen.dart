import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/community_provider.dart';

/// Screen for displaying community posts and interactions
class CommunityScreen extends StatefulWidget {
  /// Constructor
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _showSavedOnly = false;

  @override
  Widget build(BuildContext context) {
    final communityProvider = Provider.of<CommunityProvider>(context);
    final posts = _showSavedOnly ? communityProvider.savedPosts : communityProvider.posts;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayurveda Community'),
        actions: [
          IconButton(
            icon: Icon(_showSavedOnly ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () {
              setState(() {
                _showSavedOnly = !_showSavedOnly;
              });
            },
            tooltip: 'Show saved posts',
          ),
        ],
      ),
      body: posts.isEmpty
          ? const Center(child: Text('No posts available'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return _CommunityPostCard(
                  post: post,
                  onLike: () => communityProvider.likePost(post.id),
                  onSave: () => communityProvider.savePost(post.id),
                  onUnsave: () => communityProvider.unsavePost(post.id),
                  isSaved: communityProvider.savedPosts.any((p) => p.id == post.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement post creation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post creation coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CommunityPostCard extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onUnsave;
  final bool isSaved;

  const _CommunityPostCard({
    required this.post,
    required this.onLike,
    required this.onSave,
    required this.onUnsave,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.imageUrl != null)
            Image.asset(
              post.imageUrl!,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'By ${post.authorName} • ${_formatDate(post.timestamp)}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8.0),
                Text(post.content),
                const SizedBox(height: 12.0),
                Wrap(
                  spacing: 8.0,
                  children: post.tags.map((tag) => Chip(
                    label: Text(tag),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  )).toList(),
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: onLike,
                      tooltip: 'Like',
                    ),
                    Text('${post.likes}'),
                    const SizedBox(width: 16.0),
                    IconButton(
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () {
                        // TODO: Implement comments view
                      },
                      tooltip: 'Comment',
                    ),
                    Text('${post.comments}'),
                    const Spacer(),
                    IconButton(
                      icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                      onPressed: isSaved ? onUnsave : onSave,
                      tooltip: isSaved ? 'Unsave' : 'Save',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}