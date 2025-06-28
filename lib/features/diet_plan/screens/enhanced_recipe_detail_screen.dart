import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/diet_provider.dart';

class EnhancedRecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const EnhancedRecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<EnhancedRecipeDetailScreen> createState() => _EnhancedRecipeDetailScreenState();
}

class _EnhancedRecipeDetailScreenState extends State<EnhancedRecipeDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DietProvider>(builder: (context, provider, child) {
      final recipe = provider.getRecipeById(int.parse(widget.recipeId));
      
      if (recipe == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Recipe Not Found')),
          body: const Center(child: Text('Recipe not found')),
        );
      }
      
      // Extract recipe details
      final title = recipe['title'] as String;
      final imageUrl = recipe['imageUrl'] as String;
      final prepTime = recipe['prepTime'] as String;
      final cookTime = recipe['cookTime'] as String;
      final servings = int.parse(recipe['servings'].toString());
      final calories = int.parse(recipe['calories'].toString());
      final description = recipe['description'] as String;
      final ingredients = List<String>.from(recipe['ingredients']);
      final instructions = List<String>.from(recipe['instructions']);
      final doshaBalances = Map<String, String>.from(recipe['doshaBalances'] ?? {});
      final nutritionalInfo = Map<String, dynamic>.from(recipe['nutritionalInfo'] ?? {});
      final ayurvedicBenefits = List<String>.from(recipe['ayurvedicBenefits'] ?? []);
      final seasonality = recipe['seasonality'] as String? ?? 'All seasons';
      final tags = List<String>.from(recipe['tags'] ?? []);
      
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Recipe title at the bottom
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                    // TODO: Implement favorite functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    // TODO: Implement share functionality
                  },
                ),
              ],
            ),
            
            // Recipe Quick Info
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe quick info cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoCard(Icons.timer, 'Prep', prepTime),
                        _buildInfoCard(Icons.local_fire_department, 'Cook', cookTime),
                        _buildInfoCard(Icons.people, 'Serves', servings.toString()),
                        _buildInfoCard(Icons.local_dining, 'Calories', '$calories kcal'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Dosha balance indicators
                    if (doshaBalances.isNotEmpty) ...[  
                      const Text(
                        'Dosha Balance',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDoshaIndicator('Vata', doshaBalances['Vata'] ?? 'Neutral'),
                          _buildDoshaIndicator('Pitta', doshaBalances['Pitta'] ?? 'Neutral'),
                          _buildDoshaIndicator('Kapha', doshaBalances['Kapha'] ?? 'Neutral'),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Seasonality and tags
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text('Best in: $seasonality'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map((tag) => _buildTag(tag)).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    // Description
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    
                    // Tab Bar
                    TabBar(
                      controller: _tabController,
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: 'Ingredients'),
                        Tab(text: 'Instructions'),
                        Tab(text: 'Nutrition'),
                        Tab(text: 'Benefits'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Tab Content
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Ingredients Tab
                  _buildIngredientsTab(ingredients),
                  
                  // Instructions Tab
                  _buildInstructionsTab(instructions),
                  
                  // Nutrition Tab
                  _buildNutritionTab(nutritionalInfo),
                  
                  // Ayurvedic Benefits Tab
                  _buildBenefitsTab(ayurvedicBenefits),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Implement add to meal plan functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to your meal plan')),
            );
          },
          label: const Text('Add to Meal Plan'),
          icon: const Icon(Icons.add),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    });
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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
    
    return Column(
      children: [
        Text(dosha, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(effect, style: TextStyle(color: color)),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Text(
        tag,
        style: TextStyle(color: AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildIngredientsTab(List<String> ingredients) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
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
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ingredients[index],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructionsTab(List<String> instructions) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: instructions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  instructions[index],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutritionTab(Map<String, dynamic> nutritionalInfo) {
    if (nutritionalInfo.isEmpty) {
      return const Center(
        child: Text('Nutritional information not available'),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Macronutrients
        const Text(
          'Macronutrients',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNutrientCircle('Carbs', nutritionalInfo['carbs'] ?? 0, Colors.orange),
            _buildNutrientCircle('Protein', nutritionalInfo['protein'] ?? 0, Colors.red),
            _buildNutrientCircle('Fat', nutritionalInfo['fat'] ?? 0, Colors.blue),
          ],
        ),
        const SizedBox(height: 24),
        
        // Detailed nutrients
        const Text(
          'Detailed Nutrients',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...nutritionalInfo.entries
            .where((entry) => !['carbs', 'protein', 'fat'].contains(entry.key))
            .map((entry) => _buildNutrientRow(entry.key, entry.value))
            .toList(),
      ],
    );
  }

  Widget _buildNutrientCircle(String label, dynamic value, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: color, width: 3),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$value g',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildNutrientRow(String nutrient, dynamic value) {
    // Format the nutrient name for display
    final formattedName = nutrient.split('_').map((word) {
      return word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '';
    }).join(' ');
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(formattedName),
          Text(
            '$value g',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsTab(List<String> benefits) {
    if (benefits.isEmpty) {
      return const Center(
        child: Text('Ayurvedic benefits information not available'),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Ayurvedic Benefits',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...benefits.map((benefit) => _buildBenefitItem(benefit)).toList(),
      ],
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.spa, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              benefit,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}