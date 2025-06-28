import 'package:flutter/material.dart';

class RemediesProvider extends ChangeNotifier {
  // List of favorite remedies
  final List<String> _favoriteRemedies = [];
  
  // Getters
  List<String> get favoriteRemedies => _favoriteRemedies;
  
  // Add a remedy to favorites
  void addToFavorites(String remedyId) {
    if (!_favoriteRemedies.contains(remedyId)) {
      _favoriteRemedies.add(remedyId);
      notifyListeners();
    }
  }
  
  // Remove a remedy from favorites
  void removeFromFavorites(String remedyId) {
    if (_favoriteRemedies.contains(remedyId)) {
      _favoriteRemedies.remove(remedyId);
      notifyListeners();
    }
  }
  
  // Check if a remedy is in favorites
  bool isFavorite(String remedyId) {
    return _favoriteRemedies.contains(remedyId);
  }
  
  // Get remedies for a specific dosha
  List<Map<String, dynamic>> getRemediesForDosha(String dosha) {
    switch (dosha) {
      case 'Vata':
        return _vataRemedies;
      case 'Pitta':
        return _pittaRemedies;
      case 'Kapha':
        return _kaphaRemedies;
      default:
        return [];
    }
  }
  
  // Get remedies for a specific condition
  List<Map<String, dynamic>> getRemediesForCondition(String condition) {
    final allRemedies = [..._vataRemedies, ..._pittaRemedies, ..._kaphaRemedies];
    return allRemedies.where((remedy) => 
      remedy['conditions'].contains(condition.toLowerCase())
    ).toList();
  }
  
  // Vata remedies
  final List<Map<String, dynamic>> _vataRemedies = [
    {
      'id': 'v1',
      'name': 'Warming Ginger Tea',
      'description': 'A warming tea that helps balance Vata dosha and aids digestion.',
      'ingredients': [
        '1 inch fresh ginger root, sliced',
        '2 cups water',
        '1 tsp honey (optional)',
        '1/4 tsp cinnamon powder',
        'Pinch of cardamom powder',
      ],
      'preparation': 'Boil water with sliced ginger for 5-10 minutes. Strain into a cup and add honey, cinnamon, and cardamom.',
      'dosage': 'Drink 1-2 cups daily, especially in the morning and evening.',
      'conditions': ['digestion', 'cold', 'anxiety', 'joint pain'],
      'image': 'assets/images/remedies/ginger_tea.jpg',
    },
    {
      'id': 'v2',
      'name': 'Sesame Oil Massage',
      'description': 'A warming self-massage (abhyanga) that helps ground Vata energy and nourishes the skin.',
      'ingredients': [
        '1/4 cup organic sesame oil',
        '2-3 drops lavender essential oil (optional)',
      ],
      'preparation': 'Warm the oil slightly by placing the container in hot water. Add essential oil if using.',
      'dosage': 'Apply to the entire body before showering, focusing on joints and dry areas. Leave on for 15-20 minutes before washing off.',
      'conditions': ['dry skin', 'anxiety', 'insomnia', 'joint pain'],
      'image': 'assets/images/remedies/sesame_oil.jpg',
    },
    {
      'id': 'v3',
      'name': 'Calming Ashwagandha Milk',
      'description': 'A nourishing nighttime drink that helps reduce anxiety and promotes restful sleep.',
      'ingredients': [
        '1 cup milk (or almond milk)',
        '1/2 tsp ashwagandha powder',
        '1/4 tsp cinnamon',
        'Pinch of nutmeg',
        '1 tsp honey or maple syrup',
      ],
      'preparation': 'Heat milk on low. Add ashwagandha and spices, simmer for 5 minutes. Remove from heat, add sweetener.',
      'dosage': 'Drink one cup 30-60 minutes before bedtime.',
      'conditions': ['insomnia', 'anxiety', 'stress', 'fatigue'],
      'image': 'assets/images/remedies/ashwagandha_milk.jpg',
    },
  ];
  
  // Pitta remedies
  final List<Map<String, dynamic>> _pittaRemedies = [
    {
      'id': 'p1',
      'name': 'Cooling Cucumber-Mint Drink',
      'description': 'A refreshing drink that helps cool Pitta dosha and reduce inflammation.',
      'ingredients': [
        '1 cucumber, peeled and chopped',
        '10-12 fresh mint leaves',
        '2 cups water',
        '1 tbsp lime juice',
        '1 tsp honey (optional)',
        'Pinch of cumin powder',
      ],
      'preparation': 'Blend cucumber, mint, and water until smooth. Strain if desired. Add lime juice, honey, and cumin.',
      'dosage': 'Drink 1-2 cups daily, especially during hot weather or when feeling irritated.',
      'conditions': ['inflammation', 'acidity', 'skin rash', 'heat sensitivity'],
      'image': 'assets/images/remedies/cucumber_mint.jpg',
    },
    {
      'id': 'p2',
      'name': 'Aloe Vera Juice',
      'description': 'A cooling juice that helps soothe the digestive system and reduce inflammation.',
      'ingredients': [
        '2 tbsp fresh aloe vera gel',
        '1 cup water',
        '1 tsp lime juice',
        '1 tsp honey (optional)',
      ],
      'preparation': 'Blend aloe vera gel with water until smooth. Add lime juice and honey if desired.',
      'dosage': 'Drink 1/4 cup before meals, up to twice daily.',
      'conditions': ['acidity', 'heartburn', 'skin inflammation', 'ulcers'],
      'image': 'assets/images/remedies/aloe_vera.jpg',
    },
    {
      'id': 'p3',
      'name': 'Cooling Coconut Oil Hair Treatment',
      'description': 'A cooling hair treatment that helps reduce scalp inflammation and premature graying.',
      'ingredients': [
        '2-3 tbsp coconut oil',
        '5-6 curry leaves',
        '1/4 tsp brahmi powder (optional)',
      ],
      'preparation': 'Warm coconut oil slightly. Add curry leaves and brahmi powder if using. Let it infuse for 5-10 minutes.',
      'dosage': 'Apply to scalp and hair, leave for 30-60 minutes or overnight before washing.',
      'conditions': ['hair loss', 'premature graying', 'scalp inflammation'],
      'image': 'assets/images/remedies/coconut_oil.jpg',
    },
  ];
  
  // Kapha remedies
  final List<Map<String, dynamic>> _kaphaRemedies = [
    {
      'id': 'k1',
      'name': 'Stimulating Honey-Lemon-Ginger Tea',
      'description': 'An invigorating tea that helps stimulate Kapha dosha and boost metabolism.',
      'ingredients': [
        '1 inch fresh ginger root, grated',
        '1 tbsp lemon juice',
        '1 tsp honey',
        'Pinch of black pepper',
        '1 cup hot water',
      ],
      'preparation': 'Add grated ginger to hot water and steep for 5 minutes. Add lemon juice, honey, and black pepper.',
      'dosage': 'Drink 1-2 cups daily, especially in the morning.',
      'conditions': ['congestion', 'sluggish digestion', 'weight management', 'cough'],
      'image': 'assets/images/remedies/honey_lemon_tea.jpg',
    },
    {
      'id': 'k2',
      'name': 'Dry Brushing Technique',
      'description': 'A stimulating massage technique that helps improve circulation and reduce Kapha stagnation.',
      'ingredients': [
        'Natural bristle dry brush',
      ],
      'preparation': 'No preparation needed. Use a natural bristle brush with a long handle for hard-to-reach areas.',
      'dosage': 'Brush the entire body using long strokes toward the heart for 5-10 minutes before showering. Do this 2-3 times per week.',
      'conditions': ['poor circulation', 'cellulite', 'lymphatic congestion', 'dull skin'],
      'image': 'assets/images/remedies/dry_brush.jpg',
    },
    {
      'id': 'k3',
      'name': 'Triphala Digestive Tonic',
      'description': 'A balancing herbal formula that helps improve digestion and elimination.',
      'ingredients': [
        '1/2 tsp triphala powder',
        '1 cup warm water',
        '1/4 tsp honey (optional)',
      ],
      'preparation': 'Mix triphala powder in warm water. Let it steep for 5 minutes. Add honey if desired.',
      'dosage': 'Drink before bedtime or first thing in the morning on an empty stomach.',
      'conditions': ['constipation', 'sluggish digestion', 'detoxification', 'weight management'],
      'image': 'assets/images/remedies/triphala.jpg',
    },
  ];
}