import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/yoga_meditation_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';

class YogaProgressTrackerScreen extends StatefulWidget {
  const YogaProgressTrackerScreen({super.key});

  @override
  State<YogaProgressTrackerScreen> createState() => _YogaProgressTrackerScreenState();
}

class _YogaProgressTrackerScreenState extends State<YogaProgressTrackerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeFilter = 'Week';
  final List<String> _timeFilters = ['Week', 'Month', 'Year'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Progress Tracker'),
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
      body: Consumer2<YogaMeditationProvider, PrakritiProvider>(
        builder: (context, yogaProvider, prakritiProvider, child) {
          final dominantDosha = prakritiProvider.hasCompletedAssessment
              ? prakritiProvider.dominantDosha
              : '';
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(yogaProvider),
                  const SizedBox(height: 24),
                  _buildProgressSummary(yogaProvider),
                  const SizedBox(height: 24),
                  _buildCaloriesStatistics(),
                  const SizedBox(height: 24),
                  _buildRecentSessions(yogaProvider),
                  const SizedBox(height: 24),
                  _buildRecommendedCourses(dominantDosha),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeCard(YogaMeditationProvider provider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Practice',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: AppTheme.primaryColor, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${provider.streak} day streak',
                        style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Day 5 - Level 1',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),
            LinearPercentIndicator(
              percent: 0.45,
              lineHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              progressColor: Colors.white,
              barRadius: const Radius.circular(4),
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress: 45%',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '${provider.completedYogaSessions.length} sessions completed',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSummary(YogaMeditationProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress Summary',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildProgressCard(
                title: 'Total Time',
                value: '${provider.completedYogaSessions.length * 15} min',
                icon: Icons.timer,
                color: AppTheme.vataColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildProgressCard(
                title: 'Sessions',
                value: '${provider.completedYogaSessions.length}',
                icon: Icons.fitness_center,
                color: AppTheme.pittaColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildProgressCard(
                title: 'Poses',
                value: '${provider.completedYogaSessions.length * 8}',
                icon: Icons.self_improvement,
                color: AppTheme.kaphaColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Calories Statistics',
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCaloriesStat('Daily', '124', Colors.blue),
                  _buildCaloriesStat('Weekly', '534', Colors.green),
                  _buildCaloriesStat('Monthly', '2,234', Colors.orange),
                ],
              ),
              const SizedBox(height: 24),
              // Placeholder for the chart
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomPaint(
                  size: const Size(double.infinity, 150),
                  painter: CaloriesChartPainter(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mon', style: TextStyle(color: Colors.grey)),
                  const Text('Tue', style: TextStyle(color: Colors.grey)),
                  const Text('Wed', style: TextStyle(color: Colors.grey)),
                  const Text('Thu', style: TextStyle(color: Colors.grey)),
                  const Text('Fri', style: TextStyle(color: Colors.grey)),
                  const Text('Sat', style: TextStyle(color: Colors.grey)),
                  const Text('Sun', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCaloriesStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRecentSessions(YogaMeditationProvider provider) {
    // Sample recent sessions data
    final recentSessions = [
      {
        'name': 'Morning Flow',
        'duration': '15 min',
        'date': 'Today',
        'calories': '75',
        'icon': 'Images_illustrations/Warrior_I.svg',
      },
      {
        'name': 'Evening Relaxation',
        'duration': '20 min',
        'date': 'Yesterday',
        'calories': '90',
        'icon': 'Images_illustrations/Childs_Pose.svg',
      },
      {
        'name': 'Full Body Stretch',
        'duration': '30 min',
        'date': '2 days ago',
        'calories': '120',
        'icon': 'Images_illustrations/Cobra_Pose.svg',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Sessions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...recentSessions.map((session) => _buildSessionCard(session)).toList(),
      ],
    );
  }

  Widget _buildSessionCard(Map<String, String> session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  session['icon']!,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session['name']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${session['duration']} • ${session['date']}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${session['calories']} cal',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Burned',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedCourses(String dominantDosha) {
    // Sample courses data
    final courses = [
      {
        'name': 'Yoga Pilates',
        'lessons': '5 lessons',
        'rating': '4.5',
        'instructor': 'Sarah Wilson',
        'level': 'All Level',
        'image': 'Images_illustrations/Warrior_II.svg',
      },
      {
        'name': 'Full Body Stretch',
        'lessons': '8 lessons',
        'rating': '4.8',
        'instructor': 'Sarah Wilson',
        'level': 'All Level',
        'image': 'Images_illustrations/Downward_Facing_Dog.svg',
      },
      {
        'name': 'Gentle Flow',
        'lessons': '6 lessons',
        'rating': '4.3',
        'instructor': 'Sarah Wilson',
        'level': 'All Level',
        'image': 'Images_illustrations/Cobra_Pose.svg',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended Courses',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('5-10 min', true),
              _buildFilterChip('15-20 min', false),
              _buildFilterChip('+ 25 min', false),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...courses.map((course) => _buildCourseCard(course)).toList(),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // Handle filter selection
        },
        backgroundColor: Colors.grey.withOpacity(0.1),
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.black,
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, String> course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  course['image']!,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['name']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course['lessons']!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        course['rating']!,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'By ${course['instructor']}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        course['level']!,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Yoga Progress Tracker'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This tracker helps you monitor your yoga practice journey. It shows:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text('• Your current streak and progress'),
              Text('• Calories burned during sessions'),
              Text('• Recent yoga sessions'),
              Text('• Recommended courses based on your dosha'),
              SizedBox(height: 16),
              Text(
                'Regular practice is key to experiencing the full benefits of yoga for your mind and body.',
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

class CaloriesChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    // Sample data points for the chart
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width / 6, size.height * 0.5),
      Offset(size.width / 3, size.height * 0.8),
      Offset(size.width / 2, size.height * 0.3),
      Offset(2 * size.width / 3, size.height * 0.6),
      Offset(5 * size.width / 6, size.height * 0.4),
      Offset(size.width, size.height * 0.5),
    ];

    // Draw the line
    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, size.height);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
      fillPath.lineTo(points[i].dx, points[i].dy);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pointStrokePaint = Paint()
      ..color = AppTheme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var point in points) {
      canvas.drawCircle(point, 5, pointPaint);
      canvas.drawCircle(point, 5, pointStrokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}