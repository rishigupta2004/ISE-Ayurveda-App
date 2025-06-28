import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';

class EnhancedProfileScreen extends StatefulWidget {
  const EnhancedProfileScreen({super.key});

  @override
  State<EnhancedProfileScreen> createState() => _EnhancedProfileScreenState();
}

class _EnhancedProfileScreenState extends State<EnhancedProfileScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  bool _isEditing = false;
  bool _isDarkMode = false;
  bool _enableNotifications = true;
  bool _enableReminders = true;
  bool _enableDosha = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize controllers with current user data
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController.text = authProvider.userName;
    _emailController.text = authProvider.userEmail;
    _ageController.text = '32'; // Example data
    _heightController.text = '175'; // Example data in cm
    _weightController.text = '68'; // Example data in kg
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: Consumer2<AuthProvider, PrakritiProvider>(
        builder: (context, authProvider, prakritiProvider, child) {
          final dominantDosha = prakritiProvider.hasCompletedAssessment
              ? prakritiProvider.dominantDosha
              : '';
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                // Profile Avatar with improved design
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primaryColor, width: 2),
                        color: Colors.white,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: Text(
                          _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    if (!_isEditing)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Dosha Badge
                if (dominantDosha.isNotEmpty) ...[  
                  _buildDoshaBadge(dominantDosha),
                  const SizedBox(height: 20),
                ],
                
                // Profile Form
                if (_isEditing) ...[  
                  _buildProfileForm(),
                ] else ...[  
                  _buildProfileInfo(),
                ],
                
                const SizedBox(height: 24),
                
                // Tab Bar for Settings, Recommendations, and Activity
                TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'Settings'),
                    Tab(text: 'Recommendations'),
                    Tab(text: 'Activity'),
                  ],
                ),
                
                // Tab Content
                SizedBox(
                  height: 400, // Fixed height for tab content
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Settings Tab
                      _buildSettingsTab(),
                      
                      // Recommendations Tab
                      _buildRecommendationsTab(dominantDosha),
                      
                      // Activity Tab
                      _buildActivityTab(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoshaBadge(String dosha) {
    Color badgeColor;
    String assetName;
    
    switch (dosha) {
      case 'Vata':
        badgeColor = AppTheme.vataColor;
        assetName = 'assets/patterns/vata_symbol.svg';
        break;
      case 'Pitta':
        badgeColor = AppTheme.pittaColor;
        assetName = 'assets/patterns/pitta_symbol.svg';
        break;
      case 'Kapha':
        badgeColor = AppTheme.kaphaColor;
        assetName = 'assets/patterns/kapha_symbol.svg';
        break;
      default:
        badgeColor = AppTheme.primaryColor;
        assetName = 'assets/patterns/sacred_geometry.svg';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetName,
            height: 24,
            width: 24,
            color: badgeColor,
          ),
          const SizedBox(width: 8),
          Text(
            '$dosha Dominant',
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              prefixIcon: Icon(Icons.monitor_weight),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                  });
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save profile information
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    authProvider.updateUserName(_nameController.text);
                    authProvider.updateUserEmail(_emailController.text);
                    
                    setState(() {
                      _isEditing = false;
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        _buildInfoTile('Name', _nameController.text, Icons.person),
        _buildInfoTile('Email', _emailController.text, Icons.email),
        _buildInfoTile('Age', '${_ageController.text} years', Icons.calendar_today),
        _buildInfoTile('Height', '${_heightController.text} cm', Icons.height),
        _buildInfoTile('Weight', '${_weightController.text} kg', Icons.monitor_weight),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        // Appearance Section
        const Text(
          'Appearance',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Enable dark theme throughout the app'),
          value: _isDarkMode,
          onChanged: (value) {
            setState(() {
              _isDarkMode = value;
            });
            // TODO: Implement theme switching
          },
          secondary: const Icon(Icons.dark_mode),
        ),
        const Divider(),
        
        // Notifications Section
        const Text(
          'Notifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Receive updates and important alerts'),
          value: _enableNotifications,
          onChanged: (value) {
            setState(() {
              _enableNotifications = value;
            });
          },
          secondary: const Icon(Icons.notifications),
        ),
        SwitchListTile(
          title: const Text('Daily Reminders'),
          subtitle: const Text('Get reminders for your daily routines'),
          value: _enableReminders,
          onChanged: (value) {
            setState(() {
              _enableReminders = value;
            });
          },
          secondary: const Icon(Icons.alarm),
        ),
        const Divider(),
        
        // Privacy Section
        const Text(
          'Privacy',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Dosha-Based Recommendations'),
          subtitle: const Text('Personalize content based on your dosha'),
          value: _enableDosha,
          onChanged: (value) {
            setState(() {
              _enableDosha = value;
            });
          },
          secondary: const Icon(Icons.spa),
        ),
        ListTile(
          title: const Text('Clear App Data'),
          subtitle: const Text('Reset all app data and preferences'),
          leading: const Icon(Icons.delete_outline, color: Colors.red),
          onTap: () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Clear App Data'),
                content: const Text('Are you sure you want to clear all app data? This action cannot be undone.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement clear data functionality
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('App data cleared')),
                      );
                    },
                    child: const Text('Clear', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecommendationsTab(String dominantDosha) {
    if (dominantDosha.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.spa, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Complete Your Prakriti Assessment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Take the assessment to get personalized Ayurvedic recommendations',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to prakriti assessment
              },
              child: const Text('Take Assessment'),
            ),
          ],
        ),
      );
    }
    
    // Recommendations based on dosha
    List<Map<String, dynamic>> recommendations = _getDoshaRecommendations(dominantDosha);
    
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        Text(
          'Personalized $dominantDosha Recommendations',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...recommendations.map((recommendation) => _buildRecommendationCard(recommendation)),
      ],
    );
  }

  List<Map<String, dynamic>> _getDoshaRecommendations(String dosha) {
    switch (dosha) {
      case 'Vata':
        return [
          {
            'title': 'Daily Routine',
            'description': 'Establish a consistent daily routine to balance Vata energy',
            'icon': Icons.schedule,
            'color': AppTheme.vataColor,
          },
          {
            'title': 'Nutrition',
            'description': 'Favor warm, cooked, moist foods with healthy oils and warming spices',
            'icon': Icons.restaurant,
            'color': AppTheme.vataColor,
          },
          {
            'title': 'Yoga Poses',
            'description': 'Practice grounding yoga poses like Mountain Pose and Child\'s Pose',
            'icon': Icons.self_improvement,
            'color': AppTheme.vataColor,
          },
          {
            'title': 'Meditation',
            'description': 'Try grounding meditation techniques with deep breathing',
            'icon': Icons.spa,
            'color': AppTheme.vataColor,
          },
        ];
      case 'Pitta':
        return [
          {
            'title': 'Daily Routine',
            'description': 'Avoid excessive heat and intense activity during peak sun hours',
            'icon': Icons.schedule,
            'color': AppTheme.pittaColor,
          },
          {
            'title': 'Nutrition',
            'description': 'Favor cooling foods like fresh vegetables, sweet fruits, and herbs like mint and coriander',
            'icon': Icons.restaurant,
            'color': AppTheme.pittaColor,
          },
          {
            'title': 'Yoga Poses',
            'description': 'Practice cooling yoga poses like Moon Salutation and Forward Bends',
            'icon': Icons.self_improvement,
            'color': AppTheme.pittaColor,
          },
          {
            'title': 'Meditation',
            'description': 'Try cooling meditation techniques focusing on surrender and acceptance',
            'icon': Icons.spa,
            'color': AppTheme.pittaColor,
          },
        ];
      case 'Kapha':
        return [
          {
            'title': 'Daily Routine',
            'description': 'Wake up early and incorporate regular, stimulating exercise',
            'icon': Icons.schedule,
            'color': AppTheme.kaphaColor,
          },
          {
            'title': 'Nutrition',
            'description': 'Favor light, warm, dry foods with pungent, bitter, and astringent tastes',
            'icon': Icons.restaurant,
            'color': AppTheme.kaphaColor,
          },
          {
            'title': 'Yoga Poses',
            'description': 'Practice energizing yoga poses like Sun Salutation and Warrior Poses',
            'icon': Icons.self_improvement,
            'color': AppTheme.kaphaColor,
          },
          {
            'title': 'Meditation',
            'description': 'Try stimulating meditation techniques with visualization',
            'icon': Icons.spa,
            'color': AppTheme.kaphaColor,
          },
        ];
      default:
        return [];
    }
  }

  Widget _buildRecommendationCard(Map<String, dynamic> recommendation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: recommendation['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                recommendation['icon'],
                color: recommendation['color'],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(recommendation['description']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTab() {
    // Sample activity data
    final List<Map<String, dynamic>> activities = [
      {
        'type': 'Yoga',
        'name': 'Morning Flow',
        'date': 'Today, 7:30 AM',
        'duration': '20 min',
        'icon': Icons.self_improvement,
      },
      {
        'type': 'Meditation',
        'name': 'Mindfulness Session',
        'date': 'Yesterday, 9:00 PM',
        'duration': '15 min',
        'icon': Icons.spa,
      },
      {
        'type': 'Diet',
        'name': 'Logged Breakfast',
        'date': 'Yesterday, 8:15 AM',
        'duration': '',
        'icon': Icons.restaurant,
      },
      {
        'type': 'Assessment',
        'name': 'Prakriti Assessment',
        'date': '3 days ago',
        'duration': '',
        'icon': Icons.assignment,
      },
    ];
    
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...activities.map((activity) => _buildActivityItem(activity)),
        
        const SizedBox(height: 24),
        const Text(
          'Wellness Streak',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildStreakCard(),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(activity['icon'], color: AppTheme.primaryColor),
      ),
      title: Text(activity['name']),
      subtitle: Text(activity['date']),
      trailing: activity['duration'].isNotEmpty
          ? Text(
              activity['duration'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          : null,
    );
  }

  Widget _buildStreakCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Streak',
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '7 days',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                7,
                (index) => _buildDayCircle(index),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Keep up the good work! You\'re on your way to building healthy Ayurvedic habits.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCircle(int index) {
    final bool isCompleted = index < 7; // All days completed in this example
    
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? AppTheme.primaryColor : Colors.grey[300],
          ),
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
          style: TextStyle(
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}