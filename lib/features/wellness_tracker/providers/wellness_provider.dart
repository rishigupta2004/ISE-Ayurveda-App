import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/wellness_log.dart';

class WellnessProvider extends ChangeNotifier {
  // List of wellness logs
  List<WellnessLog> _logs = [];
  
  // Current wellness metrics
  int _sleepHours = 0;
  int _waterIntake = 0; // in glasses
  int _stressLevel = 3; // 1-5 scale
  int _energyLevel = 3; // 1-5 scale
  int _digestionQuality = 3; // 1-5 scale
  
  // Getters
  List<WellnessLog> get logs => _logs;
  int get sleepHours => _sleepHours;
  int get waterIntake => _waterIntake;
  int get stressLevel => _stressLevel;
  int get energyLevel => _energyLevel;
  int get digestionQuality => _digestionQuality;
  
  // Initialize from local storage
  Future<void> initializeWellness() async {
    final prefs = await SharedPreferences.getInstance();
    _sleepHours = prefs.getInt('sleepHours') ?? 0;
    _waterIntake = prefs.getInt('waterIntake') ?? 0;
    _stressLevel = prefs.getInt('stressLevel') ?? 3;
    _energyLevel = prefs.getInt('energyLevel') ?? 3;
    _digestionQuality = prefs.getInt('digestionQuality') ?? 3;
    
    // TODO: Load logs from storage
    notifyListeners();
  }
  
  // Log daily wellness metrics
  void logWellness({
    required int sleepHours,
    required int waterIntake,
    required int stressLevel,
    required int energyLevel,
    required int digestionQuality,
    String? notes,
  }) {
    _sleepHours = sleepHours;
    _waterIntake = waterIntake;
    _stressLevel = stressLevel;
    _energyLevel = energyLevel;
    _digestionQuality = digestionQuality;
    
    final log = WellnessLog(
      date: DateTime.now(),
      sleepHours: sleepHours,
      waterIntake: waterIntake,
      stressLevel: stressLevel,
      energyLevel: energyLevel,
      digestionQuality: digestionQuality,
      notes: notes,
    );
    
    _logs.add(log);
    _saveWellnessData();
    notifyListeners();
  }
  
  // Save wellness data to local storage
  Future<void> _saveWellnessData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('sleepHours', _sleepHours);
    prefs.setInt('waterIntake', _waterIntake);
    prefs.setInt('stressLevel', _stressLevel);
    prefs.setInt('energyLevel', _energyLevel);
    prefs.setInt('digestionQuality', _digestionQuality);
    
    // TODO: Save logs to storage
  }
  
  // Get wellness recommendations based on metrics and prakriti
  List<String> getWellnessRecommendations(String dominantDosha) {
    final recommendations = <String>[];
    
    // Sleep recommendations
    if (_sleepHours < 6) {
      if (dominantDosha == 'Vata') {
        recommendations.add('Try to get at least 7-8 hours of sleep to balance Vata energy.');
      } else if (dominantDosha == 'Pitta') {
        recommendations.add('Aim for 7-8 hours of sleep, preferably before 10 PM to balance Pitta.');
      } else { // Kapha
        recommendations.add('While you need less sleep than other doshas, aim for 6-7 hours of quality sleep.');
      }
    }
    
    // Water intake recommendations
    if (_waterIntake < 8) {
      if (dominantDosha == 'Vata') {
        recommendations.add('Increase your water intake to 8-10 glasses per day, preferably warm.');
      } else if (dominantDosha == 'Pitta') {
        recommendations.add('Stay hydrated with 8-10 glasses of cool water to balance Pitta fire.');
      } else { // Kapha
        recommendations.add('Drink 6-8 glasses of warm water, preferably with ginger or lemon to stimulate metabolism.');
      }
    }
    
    // Stress recommendations
    if (_stressLevel > 3) {
      if (dominantDosha == 'Vata') {
        recommendations.add('Practice grounding meditation and regular routine to reduce Vata-related anxiety.');
      } else if (dominantDosha == 'Pitta') {
        recommendations.add('Try cooling breath work (sheetali) and moonlight walks to calm Pitta intensity.');
      } else { // Kapha
        recommendations.add('Engage in stimulating activities and vigorous exercise to prevent Kapha stagnation.');
      }
    }
    
    return recommendations;
  }
  
  // Get wellness score (0-100)
  int getWellnessScore() {
    int score = 0;
    
    // Sleep score (0-20)
    score += _sleepHours >= 7 ? 20 : _sleepHours * 3;
    
    // Water score (0-20)
    score += _waterIntake >= 8 ? 20 : (_waterIntake * 2.5).toInt();
    
    // Stress score (0-20) - lower stress is better
    score += (6 - _stressLevel) * 4;
    
    // Energy score (0-20)
    score += _energyLevel * 4;
    
    // Digestion score (0-20)
    score += _digestionQuality * 4;
    
    return score;
  }
  
  // Get dosha-specific recommendations
  List<String> getRecommendationsForDosha(String dosha) {
    final recommendations = <String>[];
    
    switch (dosha) {
      case 'Vata':
        recommendations.add('Maintain a regular daily routine to balance Vata energy.');
        recommendations.add('Favor warm, cooked, and moist foods over cold and dry ones.');
        recommendations.add('Practice gentle yoga and meditation to calm the mind.');
        recommendations.add('Keep warm and avoid excessive exposure to cold and wind.');
        break;
      case 'Pitta':
        recommendations.add('Avoid excessive heat and direct sunlight during peak hours.');
        recommendations.add('Include cooling foods like sweet fruits and vegetables in your diet.');
        recommendations.add('Practice cooling breath work and moonlight meditation.');
        recommendations.add('Engage in moderate exercise during cooler parts of the day.');
        break;
      case 'Kapha':
        recommendations.add('Incorporate regular vigorous exercise to stimulate energy.');
        recommendations.add('Favor warm, light, and spicy foods over heavy and oily ones.');
        recommendations.add('Rise early and avoid daytime naps to prevent lethargy.');
        recommendations.add('Practice stimulating breath work to increase energy.');
        break;
      default:
        recommendations.add('Balance your daily routine with proper diet, exercise, and rest.');
        recommendations.add('Practice mindfulness and stress management techniques.');
    }
    
    return recommendations;
  }
}