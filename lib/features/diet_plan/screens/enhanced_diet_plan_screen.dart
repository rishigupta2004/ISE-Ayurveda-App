import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/diet_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';
import 'enhanced_recipe_detail_screen.dart';

class EnhancedDietPlanScreen extends StatefulWidget {
  const EnhancedDietPlanScreen({super.key});

  @override
  State<EnhancedDietPlanScreen> createState() => _EnhancedDietPlanScreenState();
}

class _EnhancedDietPlanScreenState extends State<EnhancedDietPlanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  
  final List<String> _filters = [
    'All',
    'Vata',
    'Pitta',
    'Kapha',
    'Vegetarian',
    'Seasonal',
    'Detox',
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayurvedic Diet Plan'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Recommendations'),
            Tab(text: 'Breakfast'),
            Tab(text: 'Lunch'),
            Tab(text: 'Dinner'),
            Tab(text: 'Meal Plans'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and filter section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                
                // Filter chips
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? filter : 'All';
                            });
                          },
                          selectedColor: _getFilterColor(filter).withOpacity(0.2),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: Consumer2<DietProvider, PrakritiProvider>(
              builder: (context, dietProvider, prakritiProvider, child) {
                final dominantDosha = prakritiProvider.hasCompletedAssessment
                    ? prakritiProvider.dominantDosha
                    : '';
                
                return TabBarView(
                  controller: _tabController,
                  children: [
                    // Recommendations Tab
                    _buildRecommendationsTab(dietProvider, dominantDosha),
                    
                    // Breakfast Tab
                    _buildRecipesList(
                      dietProvider.getRecipesByMealType('Breakfast'),
                      dietProvider,
                      dominantDosha,
                    ),
                    
                    // Lunch Tab
                    _buildRecipesList(
                      dietProvider.getRecipesByMealType('Lunch'),
                      dietProvider,
                      dominantDosha,
                    ),
                    
                    // Dinner Tab
                    _buildRecipesList(
                      dietProvider.getRecipesByMealType('Dinner'),
                      dietProvider,
                      dominantDosha,
                    ),
                    
                    // Meal Plans Tab
                    _buildMealPlansTab(dietProvider, dominantDosha),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateMealPlanDialog(context);
        },
        child: const Icon(Icons.add),
        tooltip: 'Create Custom Meal Plan',
      ),
    );
  }

  Widget _buildRecommendationsTab(DietProvider dietProvider, String dominantDosha) {
    if (dominantDosha.isEmpty) {
      return _buildPrakritiAssessmentPrompt();
    }
    
    // Get recipes recommended for the user's dosha
    final recommendedRecipes = dietProvider.getRecipesByMealType('All').where((recipe) {
      final doshaBalances = Map<String, String>.from(recipe['doshaBalances'] ?? {});
      return doshaBalances[dominantDosha] == 'balances' || doshaBalances[dominantDosha] == 'decreases';
    }).toList();
    
    // Filter recipes based on search query and selected filter
    final filteredRecipes = _filterRecipes(recommendedRecipes);
    
    if (filteredRecipes.isEmpty) {
      return const Center(
        child: Text('No recipes found matching your criteria'),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dosha-specific dietary guidelines
          _buildDoshaGuidelines(dominantDosha),
          const SizedBox(height: 24),
          
          // Recommended recipes
          Text(
            'Recommended for $dominantDosha',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredRecipes.length,
            itemBuilder: (context, index) {
              return _buildRecipeCard(filteredRecipes[index], dominantDosha);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoshaGuidelines(String dosha) {
    String title;
    List<String> guidelines;
    Color color;
    String assetName;
    
    switch (dosha) {
      case 'Vata':
        title = 'Vata Balancing Diet';
        guidelines = [
          'Favor warm, cooked, moist foods',
          'Include healthy oils and fats',
          'Use warming spices like ginger and cinnamon',
          'Limit raw vegetables and cold foods',
          'Maintain regular meal times',
        ];
        color = AppTheme.vataColor;
        assetName = 'assets/patterns/vata_symbol.svg';
        break;
      case 'Pitta':
        title = 'Pitta Balancing Diet';
        guidelines = [
          'Favor cooling, fresh foods',
          'Include sweet, bitter, and astringent tastes',
          'Use cooling spices like coriander and fennel',
          'Limit hot, spicy, and fermented foods',
          'Avoid eating when angry or stressed',
        ];
        color = AppTheme.pittaColor;
        assetName = 'assets/patterns/pitta_symbol.svg';
        break;
      case 'Kapha':
        title = 'Kapha Balancing Diet';
        guidelines = [
          'Favor light, warm, dry foods',
          'Include pungent, bitter, and astringent tastes',
          'Use stimulating spices like black pepper and turmeric',
          'Limit heavy, oily, and sweet foods',
          'Consider intermittent fasting',
        ];
        color = AppTheme.kaphaColor;
        assetName = 'assets/patterns/kapha_symbol.svg';
        break;
      default:
        title = 'Balanced Ayurvedic Diet';
        guidelines = [
          'Eat according to your dominant dosha',
          'Include all six tastes in your meals',
          'Practice mindful eating',
          'Adjust diet according to seasons',
          'Listen to your bodys needs',
        ];
        color = AppTheme.primaryColor;
        assetName = 'assets/patterns/sacred_geometry.svg';
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                assetName,
                height: 24,
                width: 24,
                color: color,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...guidelines.map((guideline) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, size: 16, color: color),
                const SizedBox(width: 8),
                Expanded(child: Text(guideline)),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildPrakritiAssessmentPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/patterns/sacred_geometry.svg',
            height: 80,
            width: 80,
            color: AppTheme.primaryColor.withOpacity(0.7),
          ),
          const SizedBox(height: 24),
          const Text(
            'Discover Your Dosha',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Complete your Prakriti assessment to get personalized diet recommendations based on your Ayurvedic body type.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to prakriti assessment
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Take Assessment'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesList(List<Map<String, dynamic>> recipes, DietProvider dietProvider, String dominantDosha) {
    // Filter recipes based on search query and selected filter
    final filteredRecipes = _filterRecipes(recipes);
    
    if (filteredRecipes.isEmpty) {
      return const Center(
        child: Text('No recipes found matching your criteria'),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        return _buildRecipeCard(filteredRecipes[index], dominantDosha);
      },
    );
  }

  List<Map<String, dynamic>> _filterRecipes(List<Map<String, dynamic>> recipes) {
    return recipes.where((recipe) {
      // Filter by search query
      final matchesSearch = _searchQuery.isEmpty ||
          recipe['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filter by selected filter
      bool matchesFilter = true;
      if (_selectedFilter != 'All') {
        if (_selectedFilter == 'Vata' || _selectedFilter == 'Pitta' || _selectedFilter == 'Kapha') {
          // Check if recipe is recommended for the selected dosha
          final doshaBalances = Map<String, String>.from(recipe['doshaBalances'] ?? {});
          matchesFilter = doshaBalances[_selectedFilter] == 'balances' || 
                         doshaBalances[_selectedFilter] == 'decreases';
        } else {
          // Check if recipe has the selected tag
          final tags = List<String>.from(recipe['tags'] ?? []);
          matchesFilter = tags.contains(_selectedFilter);
        }
      }
      
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe, String userDosha) {
    final recipeId = recipe['id'] as String;
    final title = recipe['title'] as String;
    final imageUrl = recipe['imageUrl'] as String;
    final prepTime = recipe['prepTime'] as String;
    final doshaBalances = Map<String, String>.from(recipe['doshaBalances'] ?? {});
    final isRecommended = doshaBalances[userDosha] == 'balances' || 
                         doshaBalances[userDosha] == 'decreases';
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnhancedRecipeDetailScreen(recipeId: recipeId),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image with dosha badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (userDosha.isNotEmpty && isRecommended)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDoshaColor(userDosha),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'For $userDosha',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Recipe details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        prepTime,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildDoshaIndicator('V', doshaBalances['Vata'] ?? 'neutral'),
                      const SizedBox(width: 8),
                      _buildDoshaIndicator('P', doshaBalances['Pitta'] ?? 'neutral'),
                      const SizedBox(width: 8),
                      _buildDoshaIndicator('K', doshaBalances['Kapha'] ?? 'neutral'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoshaIndicator(String dosha, String effect) {
    Color color;
    IconData icon;
    
    switch (effect.toLowerCase()) {
      case 'increases':
        color = Colors.red;
        icon = Icons.arrow_upward;
        break;
      case 'decreases':
        color = Colors.green;
        icon = Icons.arrow_downward;
        break;
      case 'balances':
        color = Colors.blue;
        icon = Icons.balance;
        break;
      default: // Neutral
        color = Colors.grey;
        icon = Icons.remove;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(
            dosha,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Icon(icon, size: 10, color: color),
        ],
      ),
    );
  }

  Widget _buildMealPlansTab(DietProvider dietProvider, String dominantDosha) {
    // Sample meal plans with enhanced details
    final List<Map<String, dynamic>> mealPlans = [
      {
        'title': 'Vata Balancing Weekly Plan',
        'description': 'A 7-day meal plan designed to balance Vata dosha with warm, grounding foods.',
        'dosha': 'Vata',
        'duration': '7 days',
        'imageUrl': 'assets/images/meal_plan_vata.jpg',
        'featured': true,
        'meals': {
          'breakfast': ['Golden Milk Oatmeal', 'Spiced Quinoa Porridge', 'Almond Date Smoothie'],
          'lunch': ['Kitchari with Ghee', 'Root Vegetable Soup', 'Warm Quinoa Bowl'],
          'dinner': ['Spiced Rice with Vegetables', 'Mung Bean Stew', 'Sweet Potato Curry'],
          'snacks': ['Dates with Warm Milk', 'Roasted Nuts', 'Stewed Fruits']
        },
        'benefits': [
          'Reduces anxiety and nervousness',
          'Improves digestion and absorption',
          'Promotes better sleep',
          'Maintains joint health'
        ]
      },
      {
        'title': 'Pitta Cooling Plan',
        'description': 'A meal plan with cooling foods to pacify Pitta dosha during summer months.',
        'dosha': 'Pitta',
        'duration': '5 days',
        'imageUrl': 'assets/images/meal_plan_pitta.jpg',
        'featured': true,
        'meals': {
          'breakfast': ['Coconut Rice Pudding', 'Sweet Fruit Salad', 'Rose Petal Smoothie'],
          'lunch': ['Cucumber Mint Raita', 'Cooling Green Salad', 'Coconut Vegetable Curry'],
          'dinner': ['Basmati Rice with Cilantro', 'Mung Bean Soup', 'Steamed Vegetables'],
          'snacks': ['Coconut Water', 'Fresh Fruits', 'Mint Tea']
        },
        'benefits': [
          'Reduces inflammation and heat',
          'Calms irritability and anger',
          'Improves skin health',
          'Supports liver function'
        ]
      },
      {
        'title': 'Kapha Energizing Plan',
        'description': 'A stimulating meal plan to balance Kapha dosha with light, warming foods.',
        'dosha': 'Kapha',
        'duration': '7 days',
        'imageUrl': 'assets/images/meal_plan_kapha.jpg',
        'featured': false,
        'meals': {
          'breakfast': ['Spicy Vegetable Upma', 'Ginger Tea with Honey', 'Light Buckwheat Porridge'],
          'lunch': ['Spiced Lentil Soup', 'Bitter Greens Salad', 'Roasted Vegetables'],
          'dinner': ['Millet with Vegetables', 'Spicy Bean Curry', 'Light Vegetable Soup'],
          'snacks': ['Roasted Chickpeas', 'Pumpkin Seeds', 'Ginger Tea']
        },
        'benefits': [
          'Increases energy and metabolism',
          'Reduces congestion and heaviness',
          'Supports weight management',
          'Improves mental clarity'
        ]
      },
      {
        'title': 'Seasonal Detox Plan',
        'description': 'A gentle cleansing meal plan for transitioning between seasons.',
        'dosha': 'All',
        'duration': '3 days',
        'imageUrl': 'assets/images/meal_plan_detox.jpg',
        'featured': false,
        'meals': {
          'breakfast': ['Warm Lemon Water', 'Simple Kitchari', 'Herbal Tea'],
          'lunch': ['Steamed Vegetables', 'Mung Bean Soup', 'Light Grain Porridge'],
          'dinner': ['Vegetable Broth', 'Simple Kitchari', 'Herbal Tea'],
          'snacks': ['Fresh Fruits', 'Herbal Teas', 'Vegetable Juices']
        },
        'benefits': [
          'Removes accumulated toxins',
          'Resets digestive system',
          'Improves energy levels',
          'Enhances mental clarity'
        ]
      },
      {
        'title': 'Tridoshic Balance Plan',
        'description': 'A balanced meal plan suitable for all doshas with seasonal adjustments.',
        'dosha': 'All',
        'duration': '14 days',
        'imageUrl': 'assets/images/meal_plan_tridoshic.jpg',
        'featured': true,
        'meals': {
          'breakfast': ['Seasonal Fruit Salad', 'Balanced Porridge', 'Herbal Tea'],
          'lunch': ['Mixed Vegetable Kitchari', 'Balanced Grain Bowl', 'Seasonal Soup'],
          'dinner': ['Light Rice with Vegetables', 'Mixed Bean Curry', 'Seasonal Stew'],
          'snacks': ['Seasonal Fruits', 'Mixed Nuts', 'Herbal Teas']
        },
        'benefits': [
          'Maintains overall dosha balance',
          'Adapts to seasonal changes',
          'Supports overall wellbeing',
          'Enhances digestive health'
        ]
      },
    ];
    
    // Filter meal plans based on search query and selected filter
    final filteredMealPlans = mealPlans.where((plan) {
      // Filter by search query
      final matchesSearch = _searchQuery.isEmpty ||
          plan['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          plan['description'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filter by selected filter
      bool matchesFilter = true;
      if (_selectedFilter != 'All') {
        if (_selectedFilter == 'Vata' || _selectedFilter == 'Pitta' || _selectedFilter == 'Kapha') {
          matchesFilter = plan['dosha'] == _selectedFilter || plan['dosha'] == 'All';
        } else {
          // For other filters like 'Vegetarian', 'Seasonal', etc.
          final tags = List<String>.from(plan['tags'] ?? []);
          matchesFilter = tags.contains(_selectedFilter) || plan['dosha'] == _selectedFilter;
        }
      }
      
      return matchesSearch && matchesFilter;
    }).toList();
    
    if (filteredMealPlans.isEmpty) {
      return const Center(
        child: Text('No meal plans found matching your criteria'),
      );
    }
    
    // Featured meal plans section
    final featuredPlans = filteredMealPlans.where((plan) => plan['featured'] == true).toList();
    final regularPlans = filteredMealPlans.where((plan) => plan['featured'] != true).toList();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured meal plans
          if (featuredPlans.isNotEmpty) ...[  
            const Text(
              'Featured Meal Plans',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredPlans.length,
                itemBuilder: (context, index) {
                  return _buildFeaturedMealPlanCard(featuredPlans[index]);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          
          // All meal plans
          const Text(
            'All Meal Plans',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...filteredMealPlans.map((plan) => _buildMealPlanCard(plan)).toList(),
          
          // Personalized recommendation
          if (dominantDosha.isNotEmpty) ...[  
            const SizedBox(height: 24),
            _buildPersonalizedRecommendation(dominantDosha),
          ],
        ],
      ),
    );
  }
  
  Widget _buildPersonalizedRecommendation(String dosha) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getDoshaColor(dosha).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getDoshaColor(dosha).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.recommend, color: _getDoshaColor(dosha)),
              const SizedBox(width: 8),
              Text(
                'Personalized for Your $dosha Dosha',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getDoshaColor(dosha),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Based on your dominant dosha, we recommend creating a custom meal plan that incorporates the following principles:',
          ),
          const SizedBox(height: 12),
          _buildDoshaRecommendation(dosha),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showCreateMealPlanDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getDoshaColor(dosha),
              foregroundColor: Colors.white,
            ),
            child: const Text('Create Custom Plan'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDoshaRecommendation(String dosha) {
    List<String> recommendations = [];
    
    switch (dosha) {
      case 'Vata':
        recommendations = [
          'Include warm, moist, and grounding foods',
          'Favor sweet, sour, and salty tastes',
          'Maintain regular meal times',
          'Include healthy oils and fats',
          'Limit raw vegetables and cold foods',
        ];
        break;
      case 'Pitta':
        recommendations = [
          'Focus on cooling, fresh foods',
          'Favor sweet, bitter, and astringent tastes',
          'Moderate spices and salt',
          'Include plenty of fresh fruits and vegetables',
          'Avoid eating when angry or stressed',
        ];
        break;
      case 'Kapha':
        recommendations = [
          'Choose light, warm, and dry foods',
          'Favor pungent, bitter, and astringent tastes',
          'Include stimulating spices',
          'Limit heavy, oily, and sweet foods',
          'Consider intermittent fasting',
        ];
        break;
      default:
        recommendations = [
          'Balance all six tastes in your meals',
          'Eat according to the seasons',
          'Practice mindful eating',
          'Listen to your bodys needs',
          'Adjust your diet based on how you feel',
        ];
    }
    
    return Column(
      children: recommendations.map((rec) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle, size: 16, color: _getDoshaColor(dosha)),
            const SizedBox(width: 8),
            Expanded(child: Text(rec)),
          ],
        ),
      )).toList(),
    );
  }
  
  Widget _buildFeaturedMealPlanCard(Map<String, dynamic> mealPlan) {
    final title = mealPlan['title'] as String;
    final description = mealPlan['description'] as String;
    final dosha = mealPlan['dosha'] as String;
    final duration = mealPlan['duration'] as String;
    final imageUrl = mealPlan['imageUrl'] as String;
    
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal plan image with dosha badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDoshaColor(dosha),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      dosha,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Meal plan details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14),
                      const SizedBox(width: 4),
                      Text(duration, style: const TextStyle(fontSize: 12)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          _showMealPlanDetailsDialog(context, mealPlan);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(60, 30),
                        ),
                        child: const Text('View'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealPlanCard(Map<String, dynamic> mealPlan) {
    final title = mealPlan['title'] as String;
    final description = mealPlan['description'] as String;
    final dosha = mealPlan['dosha'] as String;
    final duration = mealPlan['duration'] as String;
    final imageUrl = mealPlan['imageUrl'] as String;
    final benefits = List<String>.from(mealPlan['benefits'] ?? []);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal plan image with dosha badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getDoshaColor(dosha),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    dosha,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Meal plan details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(description),
                const SizedBox(height: 12),
                
                // Benefits preview
                if (benefits.isNotEmpty) ...[  
                  const Text(
                    'Benefits:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          benefits.take(2).join(' • '),
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(duration),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        _showMealPlanDetailsDialog(context, mealPlan);
                      },
                      child: const Text('View Plan'),
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
  
  void _showMealPlanDetailsDialog(BuildContext context, Map<String, dynamic> mealPlan) {
    final title = mealPlan['title'] as String;
    final description = mealPlan['description'] as String;
    final dosha = mealPlan['dosha'] as String;
    final duration = mealPlan['duration'] as String;
    final benefits = List<String>.from(mealPlan['benefits'] ?? []);
    final meals = Map<String, List<String>>.from(mealPlan['meals'] ?? {});
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and close button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getDoshaColor(dosha),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description and duration
                      Text(description),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getDoshaColor(dosha).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _getDoshaColor(dosha).withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.spa, size: 16, color: _getDoshaColor(dosha)),
                                const SizedBox(width: 4),
                                Text(
                                  dosha,
                                  style: TextStyle(color: _getDoshaColor(dosha)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(duration, style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Benefits section
                      if (benefits.isNotEmpty) ...[  
                        const Text(
                          'Benefits',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...benefits.map((benefit) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle, size: 16, color: _getDoshaColor(dosha)),
                              const SizedBox(width: 8),
                              Expanded(child: Text(benefit)),
                            ],
                          ),
                        )).toList(),
                        const SizedBox(height: 24),
                      ],
                      
                      // Meal plan details
                      const Text(
                        'Sample Meals',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      // Breakfast
                      if (meals.containsKey('breakfast') && meals['breakfast']!.isNotEmpty) ...[  
                        _buildMealTypeSection('Breakfast', meals['breakfast']!, Icons.wb_sunny),
                        const SizedBox(height: 16),
                      ],
                      
                      // Lunch
                      if (meals.containsKey('lunch') && meals['lunch']!.isNotEmpty) ...[  
                        _buildMealTypeSection('Lunch', meals['lunch']!, Icons.wb_cloudy),
                        const SizedBox(height: 16),
                      ],
                      
                      // Dinner
                      if (meals.containsKey('dinner') && meals['dinner']!.isNotEmpty) ...[  
                        _buildMealTypeSection('Dinner', meals['dinner']!, Icons.nights_stay),
                        const SizedBox(height: 16),
                      ],
                      
                      // Snacks
                      if (meals.containsKey('snacks') && meals['snacks']!.isNotEmpty) ...[  
                        _buildMealTypeSection('Snacks', meals['snacks']!, Icons.restaurant),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showCreateMealPlanDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getDoshaColor(dosha),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Customize Plan'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMealTypeSection(String title, List<String> meals, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...meals.map((meal) => Padding(
          padding: const EdgeInsets.only(left: 26, bottom: 8),
          child: Text('• $meal'),
        )).toList(),
      ],
    );
  }

  void _showCreateMealPlanDialog(BuildContext context) {
    // Default values for form
    String selectedDosha = Provider.of<PrakritiProvider>(context, listen: false).hasCompletedAssessment
        ? Provider.of<PrakritiProvider>(context, listen: false).dominantDosha
        : 'Vata';
    int durationDays = 7;
    List<String> selectedDietaryRestrictions = [];
    String seasonality = 'Current Season';
    
    // Dietary restrictions options
    final List<String> dietaryRestrictions = [
      'Vegetarian',
      'Vegan',
      'Gluten-Free',
      'Dairy-Free',
      'Nut-Free',
      'Low Sugar',
    ];
    
    // Seasonality options
    final List<String> seasonalityOptions = [
      'Current Season',
      'Spring',
      'Summer',
      'Fall',
      'Winter',
      'All Seasons',
    ];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Create Custom Meal Plan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // Form content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dosha selection
                        const Text(
                          'Primary Dosha',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'Vata', label: Text('Vata')),
                            ButtonSegment(value: 'Pitta', label: Text('Pitta')),
                            ButtonSegment(value: 'Kapha', label: Text('Kapha')),
                          ],
                          selected: {selectedDosha},
                          onSelectionChanged: (Set<String> selection) {
                            setState(() {
                              selectedDosha = selection.first;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Duration selection
                        const Text(
                          'Duration',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: durationDays.toDouble(),
                                min: 1,
                                max: 30,
                                divisions: 29,
                                label: '$durationDays days',
                                onChanged: (value) {
                                  setState(() {
                                    durationDays = value.round();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$durationDays days',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Seasonality
                        const Text(
                          'Seasonality',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: seasonality,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                          items: seasonalityOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                seasonality = newValue;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Dietary restrictions
                        const Text(
                          'Dietary Restrictions',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: dietaryRestrictions.map((restriction) {
                            return FilterChip(
                              label: Text(restriction),
                              selected: selectedDietaryRestrictions.contains(restriction),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedDietaryRestrictions.add(restriction);
                                  } else {
                                    selectedDietaryRestrictions.remove(restriction);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        
                        // Meal preferences
                        const Text(
                          'Meal Preferences',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          title: const Text('Include breakfast'),
                          value: true,
                          onChanged: (value) {},
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        ),
                        CheckboxListTile(
                          title: const Text('Include lunch'),
                          value: true,
                          onChanged: (value) {},
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        ),
                        CheckboxListTile(
                          title: const Text('Include dinner'),
                          value: true,
                          onChanged: (value) {},
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        ),
                        CheckboxListTile(
                          title: const Text('Include snacks'),
                          value: true,
                          onChanged: (value) {},
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Save meal plan preferences to provider
                          final dietProvider = Provider.of<DietProvider>(context, listen: false);
                          // TODO: Implement saving custom meal plan
                          
                          Navigator.pop(context);
                          
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Custom $selectedDosha meal plan created for $durationDays days!'),
                              backgroundColor: _getDoshaColor(selectedDosha),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getDoshaColor(selectedDosha),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Create Plan'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Color _getDoshaColor(String dosha) {
    switch (dosha) {
      case 'Vata': return AppTheme.vataColor;
      case 'Pitta': return AppTheme.pittaColor;
      case 'Kapha': return AppTheme.kaphaColor;
      default: return AppTheme.primaryColor;
    }
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'Vata': return AppTheme.vataColor;
      case 'Pitta': return AppTheme.pittaColor;
      case 'Kapha': return AppTheme.kaphaColor;
      case 'Vegetarian': return Colors.green;
      case 'Seasonal': return Colors.orange;
      case 'Detox': return Colors.purple;
      default: return AppTheme.primaryColor;
    }
  }
}