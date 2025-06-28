import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/diet_provider.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeId;
  
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DietProvider>(builder: (context, provider, child) {
      // Find the recipe with the matching ID
      final recipe = provider.getAllRecipes()
          .firstWhere((r) => r['id'] == recipeId, orElse: () => {});
      
      // If recipe is not found, show error
      if (recipe.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: const Text('Recipe')),
          body: const Center(child: Text('Recipe not found')),
        );
      }
      
      final isFavorite = provider.favoriteRecipes.contains(recipe['id']);
      
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            // App bar with recipe image
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: _getColorForMealType(recipe['mealType']).withOpacity(0.1),
                  child: Center(
                    child: Icon(
                      _getIconForMealType(recipe['mealType']),
                      size: 80,
                      color: _getColorForMealType(recipe['mealType']),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    if (isFavorite) {
                      provider.removeRecipeFromFavorites(recipe['id']);
                    } else {
                      provider.addRecipeToFavorites(recipe['id']);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // TODO: Implement share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share functionality coming soon!')),
                    );
                  },
                ),
              ],
            ),
            
            // Recipe details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe name
                    Text(
                      recipe['name'],
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    
                    // Recipe metadata
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
                    const SizedBox(height: 16),
                    
                    // Suitable for doshas
                    if (recipe['suitableFor'] != null && (recipe['suitableFor'] as List).isNotEmpty)
                      _buildDoshaChips(recipe['suitableFor']),
                    const SizedBox(height: 24),
                    
                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(recipe['description']),
                    const SizedBox(height: 24),
                    
                    // Ingredients
                    const Text(
                      'Ingredients',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildIngredientsList(recipe['ingredients']),
                    const SizedBox(height: 24),
                    
                    // Instructions
                    const Text(
                      'Instructions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildInstructionsList(recipe['instructions']),
                    const SizedBox(height: 24),
                    
                    // Nutritional information
                    if (recipe['nutritionalInfo'] != null)
                      _buildNutritionalInfo(recipe['nutritionalInfo']),
                    const SizedBox(height: 24),
                    
                    // Ayurvedic benefits
                    if (recipe['ayurvedicBenefits'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ayurvedic Benefits',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(recipe['ayurvedicBenefits']),
                          const SizedBox(height: 24),
                        ],
                      ),
                    
                    // Tips
                    if (recipe['tips'] != null && (recipe['tips'] as List).isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tips',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(
                            (recipe['tips'] as List).length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Expanded(child: Text(recipe['tips'][index])),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
  
  Widget _buildNutrientColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade700),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
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
  
  Widget _buildDoshaChips(List<dynamic> doshas) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: doshas.map((dosha) {
        Color color;
        switch (dosha) {
          case 'Vata':
            color = AppTheme.vataColor;
            break;
          case 'Pitta':
            color = AppTheme.pittaColor;
            break;
          case 'Kapha':
            color = AppTheme.kaphaColor;
            break;
          default:
            color = Colors.grey;
        }
  
        return Chip(
          label: Text(dosha),
          backgroundColor: color.withOpacity(0.1),
          side: BorderSide(color: color.withOpacity(0.3)),
          labelStyle: TextStyle(color: color),
        );
      }).toList(),
    );
  }
  
  Widget _buildIngredientsList(List<dynamic> ingredients) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ingredients.map((ingredient) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Text(ingredient)),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }
  
  Widget _buildInstructionsList(List<dynamic> instructions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        instructions.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(instructions[index])),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNutritionalInfo(Map<String, dynamic> nutritionalInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutritional Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: Colors.grey.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientColumn('Calories', '${nutritionalInfo['calories']} kcal', Icons.local_fire_department),
                _buildNutrientColumn('Protein', '${nutritionalInfo['protein']} g', Icons.fitness_center),
                _buildNutrientColumn('Carbs', '${nutritionalInfo['carbs']} g', Icons.grain),
                _buildNutrientColumn('Fat', '${nutritionalInfo['fat']} g', Icons.opacity),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  
  Color _getColorForMealType(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Colors.orange;
      case 'Lunch':
        return Colors.red;
      case 'Dinner':
        return Colors.indigo;
      case 'Snack':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForMealType(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Icons.wb_sunny;
      case 'Lunch':
        return Icons.wb_sunny_outlined;
      case 'Dinner':
        return Icons.nightlight_round;
      case 'Snack':
        return Icons.restaurant_menu;
      default:
        return Icons.restaurant;
    }
  }
}