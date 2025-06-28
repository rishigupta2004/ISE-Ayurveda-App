import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../prakriti/providers/prakriti_provider.dart';
import '../../prakriti/screens/prakriti_assessment_screen.dart';
import '../../prakriti/screens/prakriti_result_screen.dart';
import '../../wellness_tracker/screens/wellness_tracker_screen.dart';
import '../../ayurvedic_remedies/screens/remedies_screen.dart';
import '../../yoga_meditation/screens/yoga_meditation_screen.dart';
import '../../yoga_meditation/screens/yoga_progress_tracker_screen.dart';
import '../../diet_plan/screens/enhanced_diet_plan_screen.dart';
import '../../diet_plan/screens/diet_tracker_screen.dart';
import '../../gamification/screens/rewards_screen.dart';
import '../../community/screens/community_screen.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Show options for Yoga & Meditation
  void _showYogaOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Yoga & Meditation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.self_improvement, color: AppTheme.primaryColor),
              ),
              title: const Text('Yoga Poses & Meditation'),
              subtitle: const Text('Browse poses and meditation techniques'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const YogaMeditationScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.trending_up, color: AppTheme.primaryColor),
              ),
              title: const Text('Yoga Progress Tracker'),
              subtitle: const Text('Track your yoga practice and progress'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const YogaProgressTrackerScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method removed - duplicate definition

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ISE Ayurveda'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // Navigate to profile page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 24),
              _buildPrakritiSummary(),
              const SizedBox(height: 24),
              _buildFeatureGrid(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Navigate to the appropriate screen based on the tab index
          setState(() {
            _selectedIndex = index;
          });
          
          switch (index) {
            case 0: // Home - already on this screen
              break;
            case 1: // Wellness
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WellnessTrackerScreen(),
                ),
              ).then((_) => setState(() => _selectedIndex = 0));
              break;
            case 2: // Diet
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EnhancedDietPlanScreen(),
                ),
              ).then((_) => setState(() => _selectedIndex = 0));
              break;
            case 3: // Yoga
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const YogaMeditationScreen(),
                ),
              ).then((_) => setState(() => _selectedIndex = 0));
              break;
            case 4: // Community
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CommunityScreen(),
                ),
              ).then((_) => setState(() => _selectedIndex = 0));
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.spa), label: 'Wellness'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Diet'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Yoga'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Namaste!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Welcome to your personalized Ayurvedic wellness journey.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement daily wellness check
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Daily wellness check coming soon!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text('Daily Check-in'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method removed - duplicate definition

  Widget _buildPrakritiSummary() {
    return Consumer<PrakritiProvider>(builder: (context, provider, child) {
      if (!provider.hasCompletedAssessment) {
        return _buildPrakritiAssessmentCard();
      }
      
      final result = provider.getPrakritiResult();
      Color doshaColor;
      switch (result.dominantDosha) {
        case 'Vata':
          doshaColor = AppTheme.vataColor;
          break;
        case 'Pitta':
          doshaColor = AppTheme.pittaColor;
          break;
        case 'Kapha':
          doshaColor = AppTheme.kaphaColor;
          break;
        default:
          doshaColor = Colors.grey;
      }
      
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Prakriti',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PrakritiResultScreen(),
                        ),
                      );
                    },
                    child: const Text('View Details'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: doshaColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        result.dominantDosha[0],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: doshaColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${result.dominantDosha} Dominant',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          result.doshaDescription,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
    });
  }

  // Show options for Diet Plans
  void _showDietOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Diet Plans',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.restaurant_menu, color: AppTheme.primaryColor),
              ),
              title: const Text('Personalized Diet Plan'),
              subtitle: const Text('View your dosha-specific diet recommendations'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EnhancedDietPlanScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.track_changes, color: AppTheme.primaryColor),
              ),
              title: const Text('Diet Tracker'),
              subtitle: const Text('Track your daily food intake and habits'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DietTrackerScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrakritiAssessmentCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Discover Your Prakriti',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Take the assessment to learn about your unique Ayurvedic constitution.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PrakritiAssessmentScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Take Assessment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method removed - duplicate definition

  Widget _buildFeatureGrid() {
    final features = [
      {
        'title': 'Wellness Tracker',
        'icon': Icons.trending_up,
        'color': Colors.blue,
      },
      {
        'title': 'Ayurvedic Remedies',
        'icon': Icons.healing,
        'color': Colors.green,
      },
      {
        'title': 'Meditation & Yoga',
        'icon': Icons.self_improvement,
        'color': Colors.purple,
      },
      {
        'title': 'Diet Plans',
        'icon': Icons.restaurant_menu,
        'color': Colors.orange,
      },
      {
        'title': 'Achievements',
        'icon': Icons.emoji_events,
        'color': Colors.amber,
      },
      {
        'title': 'Community',
        'icon': Icons.people,
        'color': Colors.teal,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore Features',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            return _buildFeatureCard(
              title: features[index]['title'] as String,
              icon: features[index]['icon'] as IconData,
              color: features[index]['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  // Method removed - duplicate definition

  Widget _buildFeatureCard({required String title, required IconData icon, required Color color}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to the appropriate screen based on the feature title
          switch (title) {
            case 'Wellness Tracker':
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WellnessTrackerScreen(),
                ),
              );
              break;
            case 'Ayurvedic Remedies':
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RemediesScreen(),
                ),
              );
              break;
            case 'Meditation & Yoga':
              _showYogaOptions();
              break;
            case 'Diet Plans':
              _showDietOptions();
              break;
            case 'Achievements':
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RewardsScreen(),
                ),
              );
              break;
            case 'Community':
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CommunityScreen(),
                ),
              );
              break;
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}