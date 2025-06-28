import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DietProvider extends ChangeNotifier {
  // User's favorite recipes
  final List<int> _favoriteRecipes = [];
  // Diet plan types based on dosha
  final Map<String, List<String>> _doshaFoods = {
    'vata': [
      'Warm soups and stews',
      'Cooked grains',
      'Root vegetables',
      'Dairy products',
      'Sweet fruits',
      'Nuts and seeds',
    ],
    'pitta': [
      'Cooling vegetables',
      'Sweet fruits',
      'Grains like rice and oats',
      'Dairy (except sour)',
      'Mild spices',
      'Coconut water',
    ],
    'kapha': [
      'Spicy foods',
      'Bitter greens',
      'Astringent foods',
      'Light grains',
      'Honey',
      'Warm beverages',
    ],
  };
  
  // Tracked meals
  final List<Map<String, dynamic>> _trackedMeals = [];
  
  // Meal plans based on dosha
  final Map<String, Map<String, List<String>>> _doshaMealPlans = {
    'vata': {
      'breakfast': [
        'Warm oatmeal with nuts and cinnamon',
        'Stewed fruits with cardamom',
        'Scrambled eggs with ghee',
        'Whole grain toast with almond butter',
        'Warm milk with turmeric and honey'
      ],
      'lunch': [
        'Vegetable soup with root vegetables',
        'Kitchari with ghee',
        'Quinoa bowl with steamed vegetables',
        'Rice and lentil stew',
        'Warm sandwich with avocado and cheese'
      ],
      'dinner': [
        'Vegetable stir-fry with tofu',
        'Basmati rice with steamed vegetables',
        'Lentil soup with bread',
        'Sweet potato and chickpea curry',
        'Warm grain bowl with roasted vegetables'
      ],
      'snacks': [
        'Dates with warm milk',
        'Handful of soaked almonds',
        'Baked apple with cinnamon',
        'Rice pudding with cardamom',
        'Warm herbal tea with honey'
      ]
    },
    'pitta': {
      'breakfast': [
        'Cool oatmeal with coconut and berries',
        'Fresh sweet fruits like pears and plums',
        'Coconut yogurt with granola',
        'Whole grain cereal with almond milk',
        'Mint tea with a slice of melon'
      ],
      'lunch': [
        'Cucumber and mint raita with rice',
        'Cooling salad with leafy greens',
        'Coconut curry with vegetables',
        'Pasta with pesto and vegetables',
        'Vegetable wrap with hummus'
      ],
      'dinner': [
        'Basmati rice with steamed vegetables',
        'Cooling vegetable soup',
        'Quinoa salad with cucumber and mint',
        'Lentils with cooling herbs',
        'Vegetable stir-fry with tofu'
      ],
      'snacks': [
        'Fresh sweet fruits',
        'Coconut water',
        'Rice cakes with avocado',
        'Cucumber slices with mint chutney',
        'Sweet lassi with rose water'
      ]
    },
    'kapha': {
      'breakfast': [
        'Spiced millet porridge',
        'Dry toast with honey',
        'Warm ginger tea',
        'Light fruit like apples or berries',
        'Vegetable omelet with minimal oil'
      ],
      'lunch': [
        'Spicy vegetable soup',
        'Quinoa with steamed vegetables',
        'Lentil salad with bitter greens',
        'Barley bowl with roasted vegetables',
        'Spiced chickpea wrap'
      ],
      'dinner': [
        'Steamed vegetables with quinoa',
        'Light vegetable stir-fry',
        'Mung bean soup with spices',
        'Baked vegetables with minimal oil',
        'Spicy lentil curry'
      ],
      'snacks': [
        'Handful of pumpkin seeds',
        'Spicy roasted chickpeas',
        'Apple with cinnamon',
        'Vegetable sticks with spicy hummus',
        'Warm ginger or cinnamon tea'
      ]
    }
  };
  
  // Nutritional guidelines based on dosha
  final Map<String, Map<String, String>> _doshaNutritionGuidelines = {
    'vata': {
      'general': 'Focus on warm, moist, and grounding foods. Favor sweet, sour, and salty tastes.',
      'avoid': 'Cold, dry, and light foods. Minimize bitter, pungent, and astringent tastes.',
      'cooking_methods': 'Use moist cooking methods like steaming, boiling, and stewing.',
      'eating_habits': 'Eat regular meals in a calm environment. Avoid eating while distracted.'
    },
    'pitta': {
      'general': 'Focus on cool, refreshing foods with moderate oil content. Favor sweet, bitter, and astringent tastes.',
      'avoid': 'Hot, spicy, and fermented foods. Minimize sour, salty, and pungent tastes.',
      'cooking_methods': 'Use moderate cooking methods like steaming and sautéing with minimal heat.',
      'eating_habits': 'Eat in a cool, pleasant environment. Avoid eating when angry or stressed.'
    },
    'kapha': {
      'general': 'Focus on light, dry, and warming foods. Favor pungent, bitter, and astringent tastes.',
      'avoid': 'Heavy, oily, and cold foods. Minimize sweet, sour, and salty tastes.',
      'cooking_methods': 'Use dry cooking methods like baking, grilling, and sautéing with minimal oil.',
      'eating_habits': 'Eat smaller meals and avoid eating late at night. Stay active after eating.'
    }
  };

  // Recommended recipes
  final List<Map<String, dynamic>> _recipes = [
    {
      'id': 1,
      'name': 'Golden Milk',
      'dosha': ['vata', 'kapha'],
      'mealType': 'Beverage',
      'prepTime': '10 min',
      'description': 'A soothing Ayurvedic drink with anti-inflammatory properties',
      'ingredients': [
        '1 cup milk (almond milk for vegan option)',
        '1 tsp turmeric powder',
        '1/2 tsp cinnamon',
        '1/4 tsp ginger powder',
        'Pinch of black pepper',
        'Honey to taste',
      ],
      'instructions': [
        'Heat milk in a small saucepan over medium heat until hot but not boiling.',
        'Add turmeric, cinnamon, ginger, and black pepper.',
        'Whisk to combine and simmer for 5 minutes.',
        'Remove from heat and add honey to taste.',
        'Strain if desired and serve warm.',
      ],
      'benefits': 'Reduces inflammation, supports digestion, and promotes relaxation.',
      'imageUrl': 'assets/images/golden_milk.jpg',
      'nutritionalInfo': {
        'calories': 120,
        'protein': 4,
        'carbs': 10,
        'fat': 7
      }
    },
    {
      'id': 2,
      'name': 'Kitchari',
      'dosha': ['vata', 'pitta', 'kapha'],
      'mealType': 'Lunch',
      'prepTime': '40 min',
      'description': 'A nourishing one-pot meal that balances all doshas',
      'ingredients': [
        '1 cup basmati rice',
        '1/2 cup split mung beans',
        '2 tbsp ghee',
        '1 tsp cumin seeds',
        '1 tsp turmeric',
        '1 tsp ginger, grated',
        'Seasonal vegetables, chopped',
        'Salt to taste',
      ],
      'instructions': [
        'Rinse rice and mung beans until water runs clear.',
        'Heat ghee in a pot, add cumin seeds until they pop.',
        'Add turmeric and ginger, sauté for 30 seconds.',
        'Add rice, mung beans, and 4 cups of water.',
        'Bring to a boil, then simmer for 20 minutes.',
        'Add vegetables and cook until tender.',
        'Season with salt and serve warm.',
      ],
      'benefits': 'Balances all doshas, supports digestion, and detoxifies the body.',
      'imageUrl': 'assets/images/kitchari.jpg',
      'nutritionalInfo': {
        'calories': 350,
        'protein': 12,
        'carbs': 60,
        'fat': 8
      }
    },
    {
      'id': 3,
      'name': 'Coconut Mint Chutney',
      'dosha': ['pitta'],
      'mealType': 'Condiment',
      'prepTime': '15 min',
      'description': 'A cooling condiment perfect for pitta dosha',
      'ingredients': [
        '1 cup fresh coconut, grated',
        '1 cup fresh mint leaves',
        '1/2 cup cilantro leaves',
        '1 small green chili (optional)',
        '1 tbsp lime juice',
        'Salt to taste',
      ],
      'instructions': [
        'Combine all ingredients in a blender.',
        'Pulse until a smooth paste forms.',
        'Add water if needed to adjust consistency.',
        'Taste and adjust seasoning.',
        'Serve fresh with meals or as a dip.',
      ],
      'benefits': 'Cooling for pitta, aids digestion, and freshens breath.',
      'imageUrl': 'assets/images/mint_chutney.jpg',
      'nutritionalInfo': {
        'calories': 85,
        'protein': 2,
        'carbs': 4,
        'fat': 7
      }
    },
    {
      'id': 4,
      'name': 'Spiced Ginger Tea',
      'dosha': ['kapha', 'vata'],
      'mealType': 'Beverage',
      'prepTime': '10 min',
      'description': 'A warming tea that stimulates digestion and clears congestion',
      'ingredients': [
        '1 inch fresh ginger, sliced',
        '2 cups water',
        '1 cinnamon stick',
        '2 cardamom pods, crushed',
        '2 cloves',
        'Honey to taste (optional)',
      ],
      'instructions': [
        'Bring water to a boil in a small pot.',
        'Add ginger, cinnamon, cardamom, and cloves.',
        'Reduce heat and simmer for 5-10 minutes.',
        'Strain into a cup and add honey if desired.',
        'Sip while warm.',
      ],
      'benefits': 'Improves digestion, reduces congestion, and warms the body.',
      'imageUrl': 'assets/images/ginger_tea.jpg',
      'nutritionalInfo': {
        'calories': 30,
        'protein': 0,
        'carbs': 8,
        'fat': 0
      }
    },
    {
      'id': 5,
      'name': 'Cooling Cucumber Raita',
      'dosha': ['pitta'],
      'mealType': 'Side Dish',
      'prepTime': '10 min',
      'description': 'A refreshing yogurt side dish that balances spicy meals',
      'ingredients': [
        '1 cup yogurt',
        '1 cucumber, grated',
        '1/4 tsp cumin powder',
        '1/4 tsp coriander powder',
        'Fresh mint leaves, chopped',
        'Salt to taste',
      ],
      'instructions': [
        'Whisk yogurt until smooth.',
        'Squeeze excess water from grated cucumber.',
        'Mix cucumber into yogurt.',
        'Add spices, mint, and salt.',
        'Chill before serving.',
      ],
      'benefits': 'Cools the body, aids digestion, and balances spicy foods.',
      'imageUrl': 'assets/images/raita.jpg',
      'nutritionalInfo': {
        'calories': 80,
        'protein': 5,
        'carbs': 6,
        'fat': 4
      }
    },
    {
      'id': 6,
      'name': 'Spiced Quinoa Porridge',
      'dosha': ['kapha'],
      'mealType': 'Breakfast',
      'prepTime': '20 min',
      'description': 'A light, warming breakfast ideal for kapha types',
      'ingredients': [
        '1/2 cup quinoa, rinsed',
        '1 cup water',
        '1/2 tsp cinnamon',
        '1/4 tsp ginger powder',
        '1 tbsp honey',
        '1 tbsp chopped almonds',
      ],
      'instructions': [
        'Combine quinoa and water in a pot and bring to a boil.',
        'Reduce heat and simmer for 15 minutes until water is absorbed.',
        'Stir in cinnamon and ginger powder.',
        'Serve topped with honey and almonds.',
      ],
      'benefits': 'Light and easy to digest, stimulates metabolism, and provides sustained energy.',
      'imageUrl': 'assets/images/quinoa_porridge.jpg',
      'nutritionalInfo': {
        'calories': 220,
        'protein': 8,
        'carbs': 35,
        'fat': 6
      }
    },
    {
      'id': 7,
      'name': 'Triphala Tea',
      'dosha': ['vata', 'pitta', 'kapha'],
      'mealType': 'Beverage',
      'prepTime': '5 min',
      'description': 'A traditional Ayurvedic herbal tea that supports digestion and detoxification',
      'ingredients': [
        '1 tsp Triphala powder',
        '1 cup hot water',
        '1 tsp honey (optional)',
        '1 slice lemon (optional)',
      ],
      'instructions': [
        'Bring water to a boil.',
        'Add Triphala powder to a cup.',
        'Pour hot water over the powder and stir well.',
        'Let steep for 5 minutes.',
        'Add honey and lemon if desired.',
      ],
      'benefits': 'Supports digestion, detoxifies the body, and balances all three doshas.',
      'imageUrl': 'assets/images/triphala_tea.jpg',
      'nutritionalInfo': {
        'calories': 25,
        'protein': 0,
        'carbs': 6,
        'fat': 0
      }
    },
    {
      'id': 8,
      'name': 'Ashwagandha Milk',
      'dosha': ['vata'],
      'mealType': 'Beverage',
      'prepTime': '10 min',
      'description': 'A calming nighttime drink that promotes restful sleep',
      'ingredients': [
        '1 cup milk (almond milk for vegan option)',
        '1/2 tsp ashwagandha powder',
        '1/4 tsp cardamom powder',
        '1/4 tsp cinnamon',
        '1 tsp honey or jaggery',
      ],
      'instructions': [
        'Heat milk in a small saucepan over medium heat.',
        'Add ashwagandha powder, cardamom, and cinnamon.',
        'Whisk to combine and simmer for 3-5 minutes.',
        'Remove from heat and add sweetener.',
        'Drink warm before bedtime.',
      ],
      'benefits': 'Reduces stress and anxiety, promotes sleep, and builds strength and immunity.',
      'imageUrl': 'assets/images/ashwagandha_milk.jpg',
      'nutritionalInfo': {
        'calories': 110,
        'protein': 4,
        'carbs': 9,
        'fat': 6
      }
    },
    {
      'id': 9,
      'name': 'Mung Bean Soup',
      'dosha': ['kapha', 'pitta'],
      'mealType': 'Dinner',
      'prepTime': '30 min',
      'description': 'A light, protein-rich soup that is easy to digest',
      'ingredients': [
        '1 cup split mung beans',
        '4 cups water',
        '1 tbsp ghee or coconut oil',
        '1 tsp cumin seeds',
        '1/2 tsp turmeric',
        '1 tsp ginger, grated',
        '1/4 tsp asafoetida (hing)',
        'Fresh cilantro, chopped',
        'Salt to taste',
      ],
      'instructions': [
        'Rinse mung beans thoroughly.',
        'In a pot, heat ghee and add cumin seeds until they pop.',
        'Add turmeric, ginger, and asafoetida, sauté for 30 seconds.',
        'Add mung beans and water, bring to a boil.',
        'Reduce heat and simmer for 20-25 minutes until beans are soft.',
        'Season with salt and garnish with fresh cilantro.',
      ],
      'benefits': 'Easy to digest, detoxifies the body, and provides plant-based protein.',
      'imageUrl': 'assets/images/mung_soup.jpg',
      'nutritionalInfo': {
        'calories': 200,
        'protein': 14,
        'carbs': 30,
        'fat': 4
      }
    },
    {
      'id': 10,
      'name': 'Saffron Rice Pudding',
      'dosha': ['vata', 'pitta'],
      'mealType': 'Dessert',
      'prepTime': '35 min',
      'description': 'A luxurious dessert that nourishes and satisfies the sweet tooth',
      'ingredients': [
        '1/2 cup basmati rice',
        '4 cups milk',
        '1/4 cup jaggery or sugar',
        'A pinch of saffron strands',
        '1/4 tsp cardamom powder',
        '1 tbsp ghee',
        '1 tbsp chopped nuts (almonds, pistachios)',
        'A few raisins',
      ],
      'instructions': [
        'Rinse rice and soak for 20 minutes, then drain.',
        'In a heavy-bottomed pot, bring milk to a gentle boil.',
        'Add rice and simmer on low heat for 25-30 minutes, stirring occasionally.',
        'Soak saffron in 1 tbsp warm milk and add to the pot.',
        'Add jaggery, cardamom, and ghee, stir well.',
        'Garnish with nuts and raisins before serving.',
      ],
      'benefits': 'Nourishes the tissues, calms the mind, and provides sustained energy.',
      'imageUrl': 'assets/images/saffron_pudding.jpg',
      'nutritionalInfo': {
        'calories': 280,
        'protein': 7,
        'carbs': 40,
        'fat': 10
      }
    }
  ];
  

  // User's dosha type (would be set based on assessment)
  String _userDosha = 'vata';

  // Getters
  String get userDosha => _userDosha;
  List<String> get recommendedFoods => _doshaFoods[_userDosha] ?? [];
  List<Map<String, dynamic>> get allRecipes => _recipes;
  List<int> get favoriteRecipes => _favoriteRecipes;
  
  List<Map<String, dynamic>> get recommendedRecipes {
    return _recipes.where((recipe) => 
      (recipe['dosha'] as List<String>).contains(_userDosha)
    ).toList();
  }

  // Methods
  void setUserDosha(String dosha) {
    if (['vata', 'pitta', 'kapha'].contains(dosha)) {
      _userDosha = dosha;
      notifyListeners();
    }
  }

  Map<String, dynamic>? getRecipeById(int id) {
    try {
      return _recipes.firstWhere((recipe) => recipe['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Add a new recipe
  void addRecipe(Map<String, dynamic> recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }

  // Get recipes filtered by dosha type
  List<Map<String, dynamic>> getRecipesForDosha(String dosha) {
    if (dosha.isEmpty) return [];
    
    // Convert dosha to lowercase for case-insensitive comparison
    final doshaLower = dosha.toLowerCase();
    
    return _recipes.where((recipe) => 
      (recipe['dosha'] as List<String>).contains(doshaLower)
    ).toList();
  }
  
  // Get recipes filtered by meal type
  List<Map<String, dynamic>> getRecipesByMealType(String mealType) {
    if (mealType.isEmpty) return [];
    
    // Filter recipes by meal type if the field exists
    return _recipes.where((recipe) => 
      recipe.containsKey('mealType') && recipe['mealType'] == mealType
    ).toList();
  }
  
  // Get recipes filtered by multiple criteria
  List<Map<String, dynamic>> getFilteredRecipes({String? dosha, String? mealType, String? searchQuery}) {
    // Start with all recipes
    List<Map<String, dynamic>> filteredRecipes = _recipes;
    
    // Apply dosha filter if provided
    if (dosha != null && dosha.isNotEmpty) {
      filteredRecipes = filteredRecipes.where((recipe) => 
        (recipe['dosha'] as List<String>).contains(dosha.toLowerCase())
      ).toList();
    }
    
    // Apply meal type filter if provided
    if (mealType != null && mealType.isNotEmpty) {
      filteredRecipes = filteredRecipes.where((recipe) => 
        recipe['mealType'] == mealType
      ).toList();
    }
    
    // Apply search query if provided
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filteredRecipes = filteredRecipes.where((recipe) => 
        recipe['name'].toString().toLowerCase().contains(query) ||
        recipe['description'].toString().toLowerCase().contains(query)
      ).toList();
    }
    
    return filteredRecipes;
  }
  
  // Helper methods for recipe detail screen
  Color _getColorForMealType(String? mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Colors.orange;
      case 'Lunch':
        return Colors.green;
      case 'Dinner':
        return Colors.indigo;
      case 'Snack':
        return Colors.amber;
      case 'Beverage':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getIconForMealType(String? mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Icons.wb_sunny;
      case 'Lunch':
        return Icons.restaurant;
      case 'Dinner':
        return Icons.nightlight_round;
      case 'Snack':
        return Icons.cookie;
      case 'Beverage':
        return Icons.local_cafe;
      default:
        return Icons.food_bank;
    }
  }
  
  // Get all recipes
  List<Map<String, dynamic>> getAllRecipes() {
    return _recipes;
  }
  
  // Add recipe to favorites
  void addRecipeToFavorites(int recipeId) {
    if (!_favoriteRecipes.contains(recipeId)) {
      _favoriteRecipes.add(recipeId);
      notifyListeners();
    }
  }
  
  // Remove recipe from favorites
  void removeRecipeFromFavorites(int recipeId) {
    if (_favoriteRecipes.contains(recipeId)) {
      _favoriteRecipes.remove(recipeId);
      notifyListeners();
    }
  }
}