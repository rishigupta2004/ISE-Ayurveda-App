import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provider for managing community features
class CommunityProvider extends ChangeNotifier {
  /// List of community posts
  final List<CommunityPost> _posts = [];
  
  /// List of user's saved posts
  final List<String> _savedPostIds = [];
  
  /// Get all community posts
  List<CommunityPost> get posts => List.unmodifiable(_posts);
  
  /// Get user's saved posts
  List<CommunityPost> get savedPosts => _posts.where((post) => _savedPostIds.contains(post.id)).toList();
  
  /// Initialize with some sample posts
  CommunityProvider() {
    _initializeSamplePosts();
  }

  /// Add sample posts for demonstration
  void _initializeSamplePosts() {
    _posts.addAll([
      CommunityPost(
        id: '1',
        authorId: 'user1',
        authorName: 'Ayurveda Enthusiast',
        title: 'My Kapha-balancing Morning Routine',
        content: 'I\'ve been following this morning routine for balancing Kapha dosha and it\'s been life-changing! I start with dry brushing, followed by...',
        imageUrl: 'assets/images/morning_routine.jpg',
        likes: 24,
        comments: 7,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['Kapha', 'Morning Routine', 'Self-care'],
      ),
      CommunityPost(
        id: '2',
        authorId: 'user2',
        authorName: 'Vata Balancer',
        title: 'Ayurvedic Herbs for Anxiety Relief',
        content: 'These Ayurvedic herbs have helped me manage anxiety as a Vata-dominant person. Ashwagandha and Brahmi are my favorites because...',
        imageUrl: 'assets/images/herbs.jpg',
        likes: 42,
        comments: 13,
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        tags: ['Vata', 'Herbs', 'Anxiety'],
      ),
      CommunityPost(
        id: '3',
        authorId: 'user3',
        authorName: 'Pitta Cooler',
        title: 'Cooling Foods for Summer',
        content: 'As Pitta types, we need to be especially careful during summer. Here\'s my list of cooling foods that help me stay balanced...',
        imageUrl: 'assets/images/cooling_foods.jpg',
        likes: 36,
        comments: 9,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['Pitta', 'Diet', 'Summer'],
      ),
    ]);
  }
  
  /// Add a new post
  void addPost(CommunityPost post) {
    _posts.add(post);
    notifyListeners();
  }
  
  /// Like a post
  void likePost(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      _posts[postIndex] = post.copyWith(likes: post.likes + 1);
      notifyListeners();
    }
  }
  
  /// Save a post
  void savePost(String postId) {
    if (!_savedPostIds.contains(postId)) {
      _savedPostIds.add(postId);
      notifyListeners();
    }
  }
  
  /// Unsave a post
  void unsavePost(String postId) {
    if (_savedPostIds.contains(postId)) {
      _savedPostIds.remove(postId);
      notifyListeners();
    }
  }
  
  /// Add a comment to a post
  void addComment(String postId, String comment) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      _posts[postIndex] = post.copyWith(comments: post.comments + 1);
      notifyListeners();
    }
  }
}
  
/// Model class for community posts
class CommunityPost {
  /// Unique identifier
  final String id;
  
  /// ID of the post author
  final String authorId;
  
  /// Name of the post author
  final String authorName;
  
  /// Post title
  final String title;
  
  /// Post content
  final String content;
  
  /// URL to post image (if any)
  final String? imageUrl;
  
  /// Number of likes
  final int likes;
  
  /// Number of comments
  final int comments;
  
  /// Post timestamp
  final DateTime timestamp;
  
  /// Post tags
  final List<String> tags;
  
  /// Constructor
  CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.content,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    required this.timestamp,
    this.tags = const [],
  });
  
  /// Create a copy with updated fields
  CommunityPost copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? title,
    String? content,
    String? imageUrl,
    int? likes,
    int? comments,
    DateTime? timestamp,
    List<String>? tags,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      timestamp: timestamp ?? this.timestamp,
      tags: tags ?? this.tags,
    );
  }
}