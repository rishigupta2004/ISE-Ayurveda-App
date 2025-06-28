class PrakritiResult {
  final String dominantDosha;
  final int vataScore;
  final int pittaScore;
  final int kaphaScore;
  final List<String> dietRecommendations;
  final List<String> lifestyleRecommendations;
  final List<String> exerciseRecommendations;

  PrakritiResult({
    required this.dominantDosha,
    required this.vataScore,
    required this.pittaScore,
    required this.kaphaScore,
    required this.dietRecommendations,
    required this.lifestyleRecommendations,
    required this.exerciseRecommendations,
  });

  // Calculate percentages for visualization
  double get vataPercentage => vataScore / (vataScore + pittaScore + kaphaScore) * 100;
  double get pittaPercentage => pittaScore / (vataScore + pittaScore + kaphaScore) * 100;
  double get kaphaPercentage => kaphaScore / (vataScore + pittaScore + kaphaScore) * 100;

  // Get dosha description
  String get doshaDescription {
    switch (dominantDosha) {
      case 'Vata':
        return 'Vata represents the elements of space and air. Vata individuals are typically creative, energetic, and quick-thinking. When in balance, you are vibrant and enthusiastic. Focus on grounding practices and regularity to maintain balance.';
      case 'Pitta':
        return 'Pitta represents the elements of fire and water. Pitta individuals are typically intelligent, focused, and ambitious. When in balance, you are warm and articulate. Focus on cooling practices and moderation to maintain balance.';
      case 'Kapha':
        return 'Kapha represents the elements of earth and water. Kapha individuals are typically calm, strong, and loyal. When in balance, you are nurturing and stable. Focus on stimulating practices and variety to maintain balance.';
      default:
        return '';
    }
  }

  // Get dosha characteristics
  List<String> get doshaCharacteristics {
    switch (dominantDosha) {
      case 'Vata':
        return [
          'Creative and imaginative',
          'Quick to learn and grasp new concepts',
          'Energetic and lively when in balance',
          'Tendency toward dry skin and hair',
          'Variable appetite and digestion',
          'Light and interrupted sleep patterns',
        ];
      case 'Pitta':
        return [
          'Sharp intellect and good concentration',
          'Strong digestion and metabolism',
          'Precise and articulate communication',
          'Tendency toward redness and inflammation',
          'Moderate sleep needs',
          'Natural leaders with strong drive',
        ];
      case 'Kapha':
        return [
          'Strong, stable energy and endurance',
          'Calm and thoughtful nature',
          'Excellent long-term memory',
          'Tendency toward smooth, oily skin',
          'Regular digestion and appetite',
          'Deep, heavy sleep patterns',
        ];
      default:
        return [];
    }
  }
}