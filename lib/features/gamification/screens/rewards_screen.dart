import 'package:flutter/material.dart';

/// Screen for displaying user rewards and achievements
class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards & Achievements'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User level and progress
            _buildUserLevelCard(),
            const SizedBox(height: 24),
            
            // Recent achievements
            const Text(
              'Recent Achievements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildAchievementsList(),
            const SizedBox(height: 24),
            
            // Available rewards
            const Text(
              'Available Rewards',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRewardsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserLevelCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Ayurveda Master',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Level 5',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            const Text('70/100 XP to next level'),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsList() {
    final achievements = [
      {
        'title': 'Wellness Streak',
        'description': 'Completed wellness tracking for 7 consecutive days',
        'icon': Icons.local_fire_department,
        'date': '2 days ago',
      },
      {
        'title': 'Yoga Master',
        'description': 'Completed 10 different yoga sessions',
        'icon': Icons.self_improvement,
        'date': '1 week ago',
      },
      {
        'title': 'Diet Explorer',
        'description': 'Tried 5 different Ayurvedic recipes',
        'icon': Icons.restaurant,
        'date': '2 weeks ago',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber[100],
              child: Icon(achievement['icon'] as IconData, color: Colors.amber[800]),
            ),
            title: Text(achievement['title'] as String),
            subtitle: Text(
              '${achievement['description']}\n${achievement['date']}',
            ),
            trailing: const Icon(Icons.emoji_events, color: Colors.amber),
          ),
        );
      },
    );
  }

  Widget _buildRewardsList() {
    final rewards = [
      {
        'title': 'Free Consultation',
        'description': 'One free consultation with an Ayurvedic practitioner',
        'points': 500,
        'available': true,
      },
      {
        'title': 'Premium Content',
        'description': 'Unlock exclusive meditation tracks',
        'points': 300,
        'available': true,
      },
      {
        'title': 'Recipe Book',
        'description': 'Digital Ayurvedic recipe collection',
        'points': 200,
        'available': false,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];
        final bool isAvailable = reward['available'] as bool;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(reward['title'] as String),
            subtitle: Text(reward['description'] as String),
            trailing: ElevatedButton(
              onPressed: isAvailable ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAvailable ? Colors.green : Colors.grey,
              ),
              child: Text('${reward['points']} pts'),
            ),
          ),
        );
      },
    );
  }
}