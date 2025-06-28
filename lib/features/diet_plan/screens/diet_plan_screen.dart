import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/diet_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';
import 'recipe_detail_screen.dart';

class DietPlanScreen extends StatefulWidget {
  const DietPlanScreen({super.key});

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Diet Plan'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Recommendations'),
            Tab(text: 'Breakfast'),
            Tab(text: 'Lunch'),
            Tab(text: 'Dinner'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
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
          ),
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
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsTab(DietProvider provider, String dominantDosha) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dosha-specific diet guidelines
          if (dominantDosha.isNotEmpty) ...[  
            _buildDoshaGuidelines(dominantDosha),
            const SizedBox(height: 24),
          ],
          
          // General Ayurvedic diet principles
          _buildAyurvedicPrinciples(),
          const SizedBox(height: 24),
          
          // Recommended recipes
          if (dominantDosha.isNotEmpty) ...[  
            Text(
              'Recommended Recipes for $dominantDosha',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRecommendedRecipes(provider, dominantDosha),
          ],
        ],
      ),
    );
  }

  Widget _buildDoshaGuidelines(String dosha) {
    final Map<String, List<String>> doshaGuidelines = {
      'Vata': [
        'Favor warm, cooked, moist foods',
        'Include healthy oils and fats',
        'Prefer sweet, sour, and salty tastes',
        'Limit cold, dry, and light foods',
        'Maintain regular meal times',
      ],
      'Pitta': [
        'Favor cooling, fresh foods',
        'Include sweet, bitter, and astringent tastes',
        'Moderate use of oils and fats',
        'Limit hot, spicy, and fermented foods',
        'Eat largest meal at midday when digestion is strongest',
      ],
      'Kapha': [
        'Favor light, dry, warm foods',
        'Include pungent, bitter, and astringent tastes',
        'Limit heavy, oily, and cold foods',
        'Reduce sweet, sour, and salty tastes',
        'Smaller, more frequent meals',
      ],
    };
    
    final Color doshaColor = _getDoshaColor(dosha);
    final guidelines = doshaGuidelines[dosha] ?? [];
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant, color: doshaColor),
                const SizedBox(width: 8),
                Text(
                  '$dosha Diet Guidelines',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: doshaColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...guidelines.map((guideline) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: doshaColor, fontWeight: FontWeight.bold)),
                  Expanded(child: Text(guideline)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAyurvedicPrinciples() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  'Ayurvedic Diet Principles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPrincipleItem('Eat according to your dominant dosha'),
            _buildPrincipleItem('Include all six tastes in your meals: sweet, sour, salty, pungent, bitter, and astringent'),
            _buildPrincipleItem('Eat mindfully and in a calm environment'),
            _buildPrincipleItem('Favor freshly cooked, whole foods'),
            _buildPrincipleItem('Adjust your diet according to the seasons'),
          ],
        ),
      ),
    );
  }

  Widget _buildPrincipleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildRecommendedRecipes(DietProvider provider, String dosha) {
    final recipes = provider.getRecipesForDosha(dosha);
    
    if (recipes.isEmpty) {
      return const Center(
        child: Text('No recommended recipes available.'),
      );
    }
    
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return _buildRecipeCard(recipe, provider, dosha, horizontal: true);
        },
      ),
    );
  }

  Widget _buildRecipesList(List<Map<String, dynamic>> recipes, DietProvider provider, String userDosha) {
    // Filter recipes based on search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      recipes = recipes.where((recipe) {
        return recipe['name'].toLowerCase().contains(query) ||
            recipe['description'].toLowerCase().contains(query) ||
            (recipe['ingredients'] as List).any((ingredient) =>
                ingredient.toLowerCase().contains(query));
      }).toList();
    }
    
    if (recipes.isEmpty) {
      return const Center(
        child: Text('No recipes found matching your search.'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return _buildRecipeCard(recipe, provider, userDosha);
      },
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe, DietProvider provider, String userDosha, {bool horizontal = false}) {
    final isFavorite = provider.favoriteRecipes.contains(recipe['id']);
    final isRecommended = userDosha.isNotEmpty &&
        (recipe['suitableFor'] as List).contains(userDosha);
    
    if (horizontal) {
      return Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipeId: recipe['id']),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe image placeholder
                Stack(
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: _getColorForMealType(recipe['mealType']).withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getIconForMealType(recipe['mealType']),
                          size: 40,
                          color: _getColorForMealType(recipe['mealType']),
                        ),
                      ),
                    ),
                    if (isRecommended)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recipe['prepTime'],
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            recipe['mealType'],
                            style: TextStyle(
                              fontSize: 12,
                              color: _getColorForMealType(recipe['mealType']),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (isFavorite) {
                                provider.removeRecipeFromFavorites(recipe['id']);
                              } else {
                                provider.addRecipeToFavorites(recipe['id']);
                              }
                            },
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 16,
                            ),
                          ),
                        ],
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
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipeId: recipe['id']),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image placeholder
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _getColorForMealType(recipe['mealType']).withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _getIconForMealType(recipe['mealType']),
                      size: 60,
                      color: _getColorForMealType(recipe['mealType']),
                    ),
                  ),
                ),
                if (isRecommended)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Recommended',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          recipe['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (isFavorite) {
                            provider.removeRecipeFromFavorites(recipe['id']);
                          } else {
                            provider.addRecipeToFavorites(recipe['id']);
                          }
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe['description'],
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMetadataItem(
                        _getIconForMealType(recipe['mealType']),
                        recipe['mealType'],
                        _getColorForMealType(recipe['mealType']),
                      ),
                      const SizedBox(width: 16),
                      _buildMetadataItem(
                        Icons.timer,
                        recipe['prepTime'],
                        Colors.grey.shade700,
                      ),
                      const SizedBox(width: 16),
                      _buildMetadataItem(
                        Icons.people,
                        '${recipe['servings']} servings',
                        Colors.grey.shade700,
                      ),
                    ],
                  ),
                  if (recipe['suitableFor'] != null && (recipe['suitableFor'] as List).isNotEmpty) ...[  
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: (recipe['suitableFor'] as List).map((dosha) {
                        return Chip(
                          label: Text(dosha, style: TextStyle(fontSize: 10, color: _getDoshaColor(dosha))),
                          backgroundColor: _getDoshaColor(dosha).withOpacity(0.1),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: color),
        ),
      ],
    );
  }

  Color _getDoshaColor(String dosha) {
    switch (dosha) {
      case 'Vata':
        return AppTheme.vataColor;
      case 'Pitta':
        return AppTheme.pittaColor;
      case 'Kapha':
        return AppTheme.kaphaColor;
      default:
        return Colors.grey;
    }
  }

  Color _getColorForMealType(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Colors.orange;
      case 'Lunch':
        return Colors.green;
      case 'Dinner':
        return Colors.indigo;
      case 'Snack':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForMealType(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Icons.breakfast_dining;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      case 'Snack':
        return Icons.restaurant_menu;
      default:
        return Icons.food_bank;
    }
  }
}

Widget _buildNutrientColumn(String label, String value, IconData icon) {
  return Column(
    children: [
      Icon(icon, color: AppTheme.primaryColor),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
    ],
  );
}