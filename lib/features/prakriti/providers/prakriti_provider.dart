import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/prakriti_question.dart';
import '../models/prakriti_result.dart';

class PrakritiProvider extends ChangeNotifier {
  // User's prakriti scores
  int _vataScore = 0;
  int _pittaScore = 0;
  int _kaphaScore = 0;
  
  // Whether the assessment has been completed
  bool _hasCompletedAssessment = false;
  
  // Current question index during assessment
  int _currentQuestionIndex = 0;
  
  // Dominant dosha based on scores
  String _dominantDosha = '';
  
  // Getters
  int get vataScore => _vataScore;
  int get pittaScore => _pittaScore;
  int get kaphaScore => _kaphaScore;
  bool get hasCompletedAssessment => _hasCompletedAssessment;
  int get currentQuestionIndex => _currentQuestionIndex;
  String get dominantDosha => _dominantDosha;
  
  // List of assessment questions
  final List<PrakritiQuestion> _questions = [
    PrakritiQuestion(
      question: 'What is your body frame like?',
      vataOption: 'Thin, lean, and I find it difficult to gain weight',
      pittaOption: 'Medium build with moderate muscle development',
      kaphaOption: 'Solid, sturdy build and I gain weight easily',
    ),
    PrakritiQuestion(
      question: 'How is your skin typically?',
      vataOption: 'Dry, rough, or thin',
      pittaOption: 'Warm, reddish, sensitive, or prone to rashes',
      kaphaOption: 'Thick, oily, smooth, and cool to touch',
    ),
    PrakritiQuestion(
      question: 'How would you describe your hair?',
      vataOption: 'Dry, frizzy, or brittle',
      pittaOption: 'Fine, straight, early graying, or thinning',
      kaphaOption: 'Thick, wavy, oily, or lustrous',
    ),
    PrakritiQuestion(
      question: 'How is your appetite usually?',
      vataOption: 'Irregular, I sometimes forget to eat',
      pittaOption: 'Strong and regular, I get irritable if I miss meals',
      kaphaOption: 'Steady but I can easily skip meals without discomfort',
    ),
    PrakritiQuestion(
      question: 'How do you typically respond to stress?',
      vataOption: 'Anxious, worried, or overwhelmed',
      pittaOption: 'Irritable, frustrated, or angry',
      kaphaOption: 'Calm, steady, or withdrawn',
    ),
    PrakritiQuestion(
      question: 'How is your sleep pattern?',
      vataOption: 'Light sleeper, tend to wake up easily',
      pittaOption: 'Moderate sleep, usually 6-7 hours is sufficient',
      kaphaOption: 'Deep sleeper, need 8+ hours and can oversleep',
    ),
    PrakritiQuestion(
      question: 'How do you handle cold weather?',
      vataOption: 'Dislike cold, hands and feet get cold easily',
      pittaOption: 'Tolerate it well, may even prefer cooler temperatures',
      kaphaOption: 'Handle it well but prefer warmth',
    ),
    PrakritiQuestion(
      question: 'How is your speech pattern?',
      vataOption: 'Fast, enthusiastic, or sometimes scattered',
      pittaOption: 'Clear, precise, or persuasive',
      kaphaOption: 'Slow, methodical, or thoughtful',
    ),
    PrakritiQuestion(
      question: 'How do you make decisions?',
      vataOption: 'Quickly but may change my mind later',
      pittaOption: 'Decisively after analyzing the options',
      kaphaOption: 'Carefully and methodically, sometimes taking time',
    ),
    PrakritiQuestion(
      question: 'How is your energy throughout the day?',
      vataOption: 'Variable, comes in bursts',
      pittaOption: 'Strong and purposeful',
      kaphaOption: 'Steady and enduring',
    ),
  ];
  
  List<PrakritiQuestion> get questions => _questions;
  
  // Initialize from local storage
  Future<void> initializePrakriti() async {
    final prefs = await SharedPreferences.getInstance();
    _vataScore = prefs.getInt('vataScore') ?? 0;
    _pittaScore = prefs.getInt('pittaScore') ?? 0;
    _kaphaScore = prefs.getInt('kaphaScore') ?? 0;
    _hasCompletedAssessment = prefs.getBool('hasCompletedAssessment') ?? false;
    _dominantDosha = prefs.getString('dominantDosha') ?? '';
    notifyListeners();
  }
  
  // Reset assessment
  void resetAssessment() {
    _vataScore = 0;
    _pittaScore = 0;
    _kaphaScore = 0;
    _currentQuestionIndex = 0;
    _hasCompletedAssessment = false;
    _dominantDosha = '';
    notifyListeners();
  }
  
  // Answer a question
  void answerQuestion(String doshaType) {
    if (doshaType == 'vata') {
      _vataScore++;
    } else if (doshaType == 'pitta') {
      _pittaScore++;
    } else if (doshaType == 'kapha') {
      _kaphaScore++;
    }
    
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _calculateDominantDosha();
      _saveResults();
    }
    
    notifyListeners();
  }
  
  // Calculate dominant dosha
  void _calculateDominantDosha() {
    if (_vataScore >= _pittaScore && _vataScore >= _kaphaScore) {
      _dominantDosha = 'Vata';
    } else if (_pittaScore >= _vataScore && _pittaScore >= _kaphaScore) {
      _dominantDosha = 'Pitta';
    } else {
      _dominantDosha = 'Kapha';
    }
    
    _hasCompletedAssessment = true;
  }
  
  // Save results to local storage
  Future<void> _saveResults() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('vataScore', _vataScore);
    prefs.setInt('pittaScore', _pittaScore);
    prefs.setInt('kaphaScore', _kaphaScore);
    prefs.setBool('hasCompletedAssessment', _hasCompletedAssessment);
    prefs.setString('dominantDosha', _dominantDosha);
  }
  
  // Get prakriti result with recommendations
  PrakritiResult getPrakritiResult() {
    return PrakritiResult(
      dominantDosha: _dominantDosha,
      vataScore: _vataScore,
      pittaScore: _pittaScore,
      kaphaScore: _kaphaScore,
      dietRecommendations: _getDietRecommendations(),
      lifestyleRecommendations: _getLifestyleRecommendations(),
      exerciseRecommendations: _getExerciseRecommendations(),
    );
  }
  
  // Get diet recommendations based on dominant dosha
  List<String> _getDietRecommendations() {
    if (_dominantDosha == 'Vata') {
      return [
        'Favor warm, cooked, and moist foods',
        'Include healthy oils and fats in your diet',
        'Prefer sweet, sour, and salty tastes',
        'Limit raw vegetables, dried fruits, and cold foods',
        'Maintain regular meal times',
        'Recommended spices: ginger, cinnamon, cardamom, cumin',
      ];
    } else if (_dominantDosha == 'Pitta') {
      return [
        'Favor cooling, fresh foods with moderate moisture',
        'Include sweet, bitter, and astringent tastes',
        'Limit spicy, sour, and salty foods',
        'Avoid excessive oil and fried foods',
        'Stay hydrated with cool water and herbal teas',
        'Recommended spices: coriander, fennel, cardamom, mint',
      ];
    } else {
      return [
        'Favor light, warm, and dry foods',
        'Include pungent, bitter, and astringent tastes',
        'Limit sweet, sour, and salty foods',
        'Minimize dairy, oils, and heavy foods',
        'Prefer honey as a sweetener (in moderation)',
        'Recommended spices: ginger, black pepper, turmeric, cumin',
      ];
    }
  }
  
  // Get lifestyle recommendations based on dominant dosha
  List<String> _getLifestyleRecommendations() {
    if (_dominantDosha == 'Vata') {
      return [
        'Maintain a regular daily routine',
        'Get adequate rest and sleep',
        'Practice calming meditation',
        'Avoid excessive travel and overstimulation',
        'Keep warm, especially during cold and windy weather',
        'Use warm oil massage (abhyanga) regularly',
      ];
    } else if (_dominantDosha == 'Pitta') {
      return [
        'Avoid excessive heat and direct sunlight',
        'Take time to relax and cool down',
        'Practice cooling breath work (sheetali pranayama)',
        'Engage in non-competitive activities',
        'Spend time in nature, especially near water',
        'Avoid working during peak heat hours',
      ];
    } else {
      return [
        'Stay active and maintain regular exercise',
        'Wake up early (before 6 AM)',
        'Avoid daytime naps',
        'Seek variety and stimulation in daily routine',
        'Practice energizing breath work (kapalabhati)',
        'Use dry brushing (garshana) before bathing',
      ];
    }
  }
  
  // Get exercise recommendations based on dominant dosha
  List<String> _getExerciseRecommendations() {
    if (_dominantDosha == 'Vata') {
      return [
        'Gentle, grounding yoga practices',
        'Walking at a moderate pace',
        'Swimming in warm water',
        'Tai chi or qigong',
        'Strength training with proper guidance',
        'Avoid excessive, intense exercise',
      ];
    } else if (_dominantDosha == 'Pitta') {
      return [
        'Moderate exercise during cooler hours',
        'Swimming and water sports',
        'Moon salutations (chandra namaskar)',
        'Relaxed cycling or hiking',
        'Team sports with a fun, non-competitive approach',
        'Avoid exercising during the hottest part of the day',
      ];
    } else {
      return [
        'Vigorous, stimulating exercise',
        'Brisk walking or jogging',
        'Dynamic, flowing yoga practices',
        'Aerobic activities',
        'Competitive sports',
        'Exercise in the morning to boost metabolism',
      ];
    }
  }
}