import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/diet_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';

class DietTrackerScreen extends StatefulWidget {
  const DietTrackerScreen({super.key});

  @override
  State<DietTrackerScreen> createState() => _DietTrackerScreenState();
}

class _DietTrackerScreenState extends State<DietTrackerScreen> {
  String _selectedTimeFilter = 'Week';
  final List<String> _timeFilters = ['Week', 'Month', 'Year'];
  
  // Sample water intake data
  int _waterGlasses = 4;
  final int _waterGoal = 8;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayurvedic Diet Tracker'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog();
            },
          ),
        ],
      ),
      body: Consumer2<DietProvider, PrakritiProvider>(
        builder: (context, dietProvider, prakritiProvider, child) {
          final dominantDosha = prakritiProvider.hasCompletedAssessment
              ? prakritiProvider.dominantDosha
              : '';
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoshaBasedDietCard(dominantDosha),
                  const SizedBox(height: 24),
                  _buildNutritionSummary(),
                  const SizedBox(height: 24),
                  _buildWaterIntakeTracker(),
                  const SizedBox(height: 24),
                  _buildMealTracker(),
                  const SizedBox(height: 24),
                  _buildRecommendedFoods(dominantDosha),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMealDialog();
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDoshaBasedDietCard(String dominantDosha) {
    String doshaTitle = dominantDosha.isNotEmpty ? dominantDosha : 'Balanced';
    Color doshaColor;
    String doshaDescription;
    
    switch (dominantDosha) {
      case 'Vata':
        doshaColor = AppTheme.vataColor;
        doshaDescription = 'Focus on warm, moist, grounding foods with sweet, sour, and salty tastes.';
        break;
      case 'Pitta':
        doshaColor = AppTheme.pittaColor;
        doshaDescription = 'Focus on cooling, hydrating foods with sweet, bitter, and astringent tastes.';
        break;
      case 'Kapha':
        doshaColor = AppTheme.kaphaColor;
        doshaDescription = 'Focus on light, warm, dry foods with pungent, bitter, and astringent tastes.';
        break;
      default:
        doshaColor = AppTheme.tridoshaColor;
        doshaDescription = 'Focus on a balanced diet with all six tastes: sweet, sour, salty, bitter, pungent, and astringent.';
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: doshaColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.restaurant_menu, color: doshaColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  '$doshaTitle Diet Plan',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              doshaDescription,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to detailed diet recommendations
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: doshaColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('View Detailed Recommendations'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today\'s Nutrition',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SegmentedButton<String>(
              segments: _timeFilters.map((filter) => ButtonSegment<String>(
                value: filter,
                label: Text(filter),
              )).toList(),
              selected: {_selectedTimeFilter},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedTimeFilter = newSelection.first;
                });
              },
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildNutrientProgressCard(
                title: 'Calories',
                current: 1450,
                goal: 2000,
                color: AppTheme.primaryColor,
                icon: Icons.local_fire_department,
                unit: 'kcal',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildNutrientProgressCard(
                title: 'Protein',
                current: 65,
                goal: 90,
                color: AppTheme.vataColor,
                icon: Icons.fitness_center,
                unit: 'g',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildNutrientProgressCard(
                title: 'Carbs',
                current: 180,
                goal: 250,
                color: AppTheme.pittaColor,
                icon: Icons.grain,
                unit: 'g',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildNutrientProgressCard(
                title: 'Fats',
                current: 45,
                goal: 65,
                color: AppTheme.kaphaColor,
                icon: Icons.opacity,
                unit: 'g',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrientProgressCard({
    required String title,
    required int current,
    required int goal,
    required Color color,
    required IconData icon,
    required String unit,
  }) {
    final double percentage = current / goal;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              percent: percentage > 1.0 ? 1.0 : percentage,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$current',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                  ),
                  Text(
                    unit,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              progressColor: color,
              backgroundColor: color.withOpacity(0.2),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 8),
            Text(
              'Goal: $goal $unit',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterIntakeTracker() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Water Intake',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearPercentIndicator(
                        percent: _waterGlasses / _waterGoal,
                        lineHeight: 20,
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        progressColor: Colors.blue,
                        barRadius: const Radius.circular(10),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_waterGlasses of $_waterGoal glasses',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (_waterGlasses < _waterGoal) _waterGlasses++;
                          });
                        },
                        icon: const Icon(Icons.add_circle, color: Colors.blue, size: 32),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (_waterGlasses > 0) _waterGlasses--;
                          });
                        },
                        icon: const Icon(Icons.remove_circle, color: Colors.grey, size: 32),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTracker() {
    // Sample meal data
    final meals = [
      {
        'name': 'Breakfast',
        'time': '8:00 AM',
        'calories': 420,
        'completed': true,
        'items': ['Oatmeal with fruits', 'Herbal tea'],
      },
      {
        'name': 'Lunch',
        'time': '1:00 PM',
        'calories': 580,
        'completed': true,
        'items': ['Kitchari', 'Steamed vegetables'],
      },
      {
        'name': 'Snack',
        'time': '4:00 PM',
        'calories': 150,
        'completed': false,
        'items': ['Nuts and seeds', 'Fruit'],
      },
      {
        'name': 'Dinner',
        'time': '7:00 PM',
        'calories': 450,
        'completed': false,
        'items': ['Vegetable soup', 'Quinoa salad'],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Meals',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...meals.map((meal) => _buildMealCard(meal)).toList(),
      ],
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: meal['completed'] ? AppTheme.primaryColor : Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                meal['completed'] ? Icons.check : Icons.restaurant,
                color: meal['completed'] ? Colors.white : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        meal['name'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        meal['time'],
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (meal['items'] as List<String>).join(', '),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${meal['calories']} calories',
                    style: TextStyle(
                      fontSize: 14,
                      color: meal['completed'] ? AppTheme.primaryColor : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show meal options
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedFoods(String dominantDosha) {
    // Sample recommended foods based on dosha
    List<Map<String, dynamic>> foods = [];
    
    switch (dominantDosha.toLowerCase()) {
      case 'vata':
        foods = [
          {
            'name': 'Sweet Fruits',
            'description': 'Bananas, mangoes, peaches, plums',
            'icon': Icons.apple,
          },
          {
            'name': 'Warm Grains',
            'description': 'Rice, oats, wheat',
            'icon': Icons.grain,
          },
          {
            'name': 'Healthy Fats',
            'description': 'Ghee, olive oil, sesame oil',
            'icon': Icons.opacity,
          },
        ];
        break;
      case 'pitta':
        foods = [
          {
            'name': 'Cooling Vegetables',
            'description': 'Cucumber, zucchini, leafy greens',
            'icon': Icons.eco,
          },
          {
            'name': 'Sweet Fruits',
            'description': 'Apples, pears, sweet berries',
            'icon': Icons.apple,
          },
          {
            'name': 'Cooling Spices',
            'description': 'Coriander, fennel, cardamom',
            'icon': Icons.spa,
          },
        ];
        break;
      case 'kapha':
        foods = [
          {
            'name': 'Warming Spices',
            'description': 'Ginger, black pepper, turmeric',
            'icon': Icons.whatshot,
          },
          {
            'name': 'Light Grains',
            'description': 'Barley, millet, corn',
            'icon': Icons.grain,
          },
          {
            'name': 'Astringent Fruits',
            'description': 'Apples, cranberries, pomegranate',
            'icon': Icons.apple,
          },
        ];
        break;
      default:
        foods = [
          {
            'name': 'Balanced Diet',
            'description': 'Include all six tastes in your meals',
            'icon': Icons.restaurant_menu,
          },
          {
            'name': 'Seasonal Foods',
            'description': 'Focus on local and seasonal produce',
            'icon': Icons.eco,
          },
          {
            'name': 'Mindful Eating',
            'description': 'Eat in a calm environment with awareness',
            'icon': Icons.self_improvement,
          },
        ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended Foods',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...foods.map((food) => _buildFoodRecommendationCard(food)).toList(),
      ],
    );
  }

  Widget _buildFoodRecommendationCard(Map<String, dynamic> food) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(food['icon'], color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food['name'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    food['description'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {
                // Save recommendation
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMealDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Meal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Meal Type'),
                items: ['Breakfast', 'Lunch', 'Snack', 'Dinner']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Food Items (comma separated)'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Time'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add meal logic
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Ayurvedic Diet Tracker'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This tracker helps you monitor your Ayurvedic diet based on your dosha type. It shows:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text('• Dosha-specific dietary recommendations'),
              Text('• Daily nutrition intake and goals'),
              Text('• Water consumption tracking'),
              Text('• Meal planning and tracking'),
              Text('• Recommended foods for your constitution'),
              SizedBox(height: 16),
              Text(
                'Following an Ayurvedic diet tailored to your dosha can help balance your body and mind.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}