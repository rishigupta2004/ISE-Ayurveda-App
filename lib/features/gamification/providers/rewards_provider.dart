import 'package:flutter/foundation.dart';

/// Provider for managing user rewards and gamification features
class RewardsProvider extends ChangeNotifier {
  /// User's current points
  int _points = 0;
  
  /// User's current level
  int _level = 1;
  
  /// User's achievements
  final List<Achievement> _achievements = [];
  
  /// User's completed challenges
  final List<Challenge> _completedChallenges = [];
  
  /// Get user's current points
  int get points => _points;
  
  /// Get user's current level
  int get level => _level;
  
  /// Get user's achievements
  List<Achievement> get achievements => List.unmodifiable(_achievements);
  
  /// Get user's completed challenges
  List<Challenge> get completedChallenges => List.unmodifiable(_completedChallenges);
  
  /// Add points to user's account
  void addPoints(int amount) {
    _points += amount;
    _checkLevelUp();
    notifyListeners();
  }
  
  /// Check if user should level up
  void _checkLevelUp() {
    // Simple level up formula: level * 100 points needed for next level
    if (_points >= _level * 100) {
      _level++;
      // Add level up achievement
      _achievements.add(
        Achievement(
          id: 'level_$_level',
          title: 'Reached Level $_level',
          description: 'You have reached level $_level in your Ayurvedic journey',
          points: 50,
          iconPath: 'assets/icons/level_up.png',
        ),
      );
    }
  }
  
  /// Complete a challenge
  void completeChallenge(Challenge challenge) {
    if (!_completedChallenges.contains(challenge)) {
      _completedChallenges.add(challenge);
      addPoints(challenge.points);
      notifyListeners();
    }
  }
  
  /// Unlock an achievement
  void unlockAchievement(Achievement achievement) {
    if (!_achievements.contains(achievement)) {
      _achievements.add(achievement);
      addPoints(achievement.points);
      notifyListeners();
    }
  }
  
  /// Reset user progress (for testing)
  void resetProgress() {
    _points = 0;
    _level = 1;
    _achievements.clear();
    _completedChallenges.clear();
    notifyListeners();
  }
}

/// Model class for achievements
class Achievement {
  /// Unique identifier
  final String id;
  
  /// Achievement title
  final String title;
  
  /// Achievement description
  final String description;
  
  /// Points awarded for this achievement
  final int points;
  
  /// Path to achievement icon
  final String iconPath;
  
  /// Constructor
  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.iconPath,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Achievement && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}

/// Model class for challenges
class Challenge {
  /// Unique identifier
  final String id;
  
  /// Challenge title
  final String title;
  
  /// Challenge description
  final String description;
  
  /// Points awarded for completing this challenge
  final int points;
  
  /// Path to challenge icon
  final String iconPath;
  
  /// Constructor
  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.iconPath,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Challenge && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}