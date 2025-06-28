import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/wellness_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';
import 'wellness_tracker_screen.dart';

class WellnessDashboardScreen extends StatefulWidget {
  const WellnessDashboardScreen({super.key});

  @override
  State<WellnessDashboardScreen> createState() => _WellnessDashboardScreenState();
}

class _WellnessDashboardScreenState extends State<WellnessDashboardScreen> {
  int _selectedTimeRange = 7; // Default to 7 days

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Use GoRouter for consistent navigation
              context.go('/wellness-tracker');
            },
            tooltip: 'Add New Entry',
          ),
        ],
      ),
      body: Consumer2<WellnessProvider, PrakritiProvider>(
        builder: (context, wellnessProvider, prakritiProvider, child) {
          final wellnessScore = wellnessProvider.getWellnessScore();
          final dominantDosha = prakritiProvider.hasCompletedAssessment
              ? prakritiProvider.dominantDosha
              : '';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWellnessScoreCard(wellnessScore, dominantDosha),
                  const SizedBox(height: 24),
                  _buildTimeRangeSelector(),
                  const SizedBox(height: 16),
                  _buildWellnessCharts(wellnessProvider),
                  const SizedBox(height: 24),
                  _buildRecentActivities(wellnessProvider),
                  const SizedBox(height: 24),
                  if (dominantDosha.isNotEmpty) _buildDoshaInsights(wellnessProvider, dominantDosha),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWellnessScoreCard(int score, String dominantDosha) {
    Color scoreColor;
    String scoreText;

    if (score >= 80) {
      scoreColor = Colors.green;
      scoreText = 'Excellent';
    } else if (score >= 60) {
      scoreColor = Colors.blue;
      scoreText = 'Good';
    } else if (score >= 40) {
      scoreColor = Colors.orange;
      scoreText = 'Fair';
    } else {
      scoreColor = Colors.red;
      scoreText = 'Needs Attention';
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
                  'Your Wellness Score',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    scoreText,
                    style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$score',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                      const Text('out of 100'),
                      const SizedBox(height: 8),
                      if (dominantDosha.isNotEmpty)
                        Text(
                          'Dosha: $dominantDosha',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _getDoshaColor(dominantDosha),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 120,
                    child: _buildScoreGauge(score),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreGauge(int score) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 12,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(score)),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite, color: Colors.redAccent),
            const SizedBox(height: 4),
            Text(
              '${score}%',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.blue;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  Color _getDoshaColor(String dosha) {
    if (dosha == 'Vata') return AppTheme.vataColor;
    if (dosha == 'Pitta') return AppTheme.pittaColor;
    if (dosha == 'Kapha') return AppTheme.kaphaColor;
    return Colors.grey;
  }

  Widget _buildTimeRangeSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _timeRangeButton('Week', 7),
            _timeRangeButton('Month', 30),
            _timeRangeButton('3 Months', 90),
            _timeRangeButton('Year', 365),
          ],
        ),
      ),
    );
  }

  Widget _timeRangeButton(String label, int days) {
    final isSelected = _selectedTimeRange == days;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTimeRange = days;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildWellnessCharts(WellnessProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wellness Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 2 == 0) {
                            final date = DateTime.now().subtract(Duration(days: (_selectedTimeRange - value.toInt())));
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('d/M').format(date),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    // Sleep data
                    LineChartBarData(
                      spots: List.generate(7, (index) {
                        return FlSpot(index.toDouble(), (index * 0.5 + 5).clamp(0, 10));
                      }),
                      isCurved: true,
                      color: AppTheme.vataColor,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                    // Energy data
                    LineChartBarData(
                      spots: List.generate(7, (index) {
                        return FlSpot(index.toDouble(), (index * 0.3 + 3).clamp(0, 5));
                      }),
                      isCurved: true,
                      color: AppTheme.pittaColor,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChartLegend('Sleep Hours', AppTheme.vataColor),
                const SizedBox(width: 24),
                _buildChartLegend('Energy Level', AppTheme.pittaColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildRecentActivities(WellnessProvider provider) {
    // Sample data - in a real app, this would come from the provider
    final activities = [
      {'date': DateTime.now().subtract(const Duration(days: 1)), 'type': 'Sleep', 'value': '8 hours'},
      {'date': DateTime.now().subtract(const Duration(days: 2)), 'type': 'Water', 'value': '8 glasses'},
      {'date': DateTime.now().subtract(const Duration(days: 3)), 'type': 'Stress', 'value': 'Low'},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'View All',
                  style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...activities.map((activity) => _buildActivityItem(activity)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    IconData icon;
    Color color;

    switch (activity['type']) {
      case 'Sleep':
        icon = Icons.nightlight_round;
        color = AppTheme.vataColor;
        break;
      case 'Water':
        icon = Icons.water_drop;
        color = AppTheme.pittaColor;
        break;
      case 'Stress':
        icon = Icons.psychology;
        color = AppTheme.kaphaColor;
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activity['type']}: ${activity['value']}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  DateFormat('EEEE, MMMM d').format(activity['date']),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoshaInsights(WellnessProvider provider, String dominantDosha) {
    final recommendations = provider.getRecommendationsForDosha(dominantDosha);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$dominantDosha Dosha Insights',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...recommendations.map((recommendation) => _buildRecommendationItem(recommendation, dominantDosha)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String recommendation, String dosha) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: _getDoshaColor(dosha), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(recommendation),
          ),
        ],
      ),
    );
  }
}