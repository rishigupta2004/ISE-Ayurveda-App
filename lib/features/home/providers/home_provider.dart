import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  // User's wellness score
  int _wellnessScore = 0;
  
  // User's streak (days of consecutive app usage)
  int _streak = 0;
  
  // Whether user has completed daily check-in
  bool _hasCompletedDailyCheckIn = false;
  
  // Getters
  int get wellnessScore => _wellnessScore;
  int get streak => _streak;
  bool get hasCompletedDailyCheckIn => _hasCompletedDailyCheckIn;
  
  // Complete daily check-in
  void completeDailyCheckIn() {
    if (!_hasCompletedDailyCheckIn) {
      _hasCompletedDailyCheckIn = true;
      _streak++;
      _wellnessScore += 10; // Award points for check-in
      notifyListeners();
    }
  }
  
  // Reset daily check-in status (called at midnight)
  void resetDailyCheckIn() {
    _hasCompletedDailyCheckIn = false;
    notifyListeners();
  }
  
  // Add wellness points
  void addWellnessPoints(int points) {
    _wellnessScore += points;
    notifyListeners();
  }
  
  // Reset streak (if user misses a day)
  void resetStreak() {
    _streak = 0;
    notifyListeners();
  }
}