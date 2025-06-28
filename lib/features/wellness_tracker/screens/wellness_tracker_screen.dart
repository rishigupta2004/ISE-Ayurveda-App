import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/wellness_provider.dart';
import '../models/wellness_log.dart';
import '../../prakriti/providers/prakriti_provider.dart';

class WellnessTrackerScreen extends StatefulWidget {
  const WellnessTrackerScreen({super.key});

  @override
  State<WellnessTrackerScreen> createState() => _WellnessTrackerScreenState();
}

class _WellnessTrackerScreenState extends State<WellnessTrackerScreen> {
  final _formKey = GlobalKey<FormState>();
  int _sleepHours = 7;
  int _waterIntake = 6;
  int _stressLevel = 3;
  int _energyLevel = 3;
  int _digestionQuality = 3;
  String _notes = '';

  @override
  void initState() {
    super.initState();
    // Initialize form with current values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wellnessProvider = Provider.of<WellnessProvider>(context, listen: false);
      setState(() {
        _sleepHours = wellnessProvider.sleepHours > 0 ? wellnessProvider.sleepHours : 7;
        _waterIntake = wellnessProvider.waterIntake > 0 ? wellnessProvider.waterIntake : 6;
        _stressLevel = wellnessProvider.stressLevel;
        _energyLevel = wellnessProvider.energyLevel;
        _digestionQuality = wellnessProvider.digestionQuality;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Tracker'),
        elevation: 0,
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
                  _buildWellnessScoreCard(wellnessScore),
                  const SizedBox(height: 24),
                  _buildDailyLogForm(),
                  const SizedBox(height: 24),
                  if (dominantDosha.isNotEmpty) _buildRecommendations(wellnessProvider, dominantDosha),
                  const SizedBox(height: 24),
                  _buildWellnessHistory(wellnessProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWellnessScoreCard(int score) {
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
          children: [
            const Text(
              'Your Wellness Score',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      score.toString(),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: scoreColor,
                      ),
                    ),
                    Text(
                      scoreText,
                      style: TextStyle(
                        fontSize: 16,
                        color: scoreColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Track your wellness daily to maintain balance according to your dosha.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyLogForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Log Today\'s Wellness',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSleepHoursField(),
              const SizedBox(height: 16),
              _buildWaterIntakeField(),
              const SizedBox(height: 16),
              _buildSliderField(
                title: 'Stress Level',
                value: _stressLevel,
                min: 1,
                max: 5,
                lowLabel: 'Low',
                highLabel: 'High',
                onChanged: (value) {
                  setState(() {
                    _stressLevel = value.round();
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSliderField(
                title: 'Energy Level',
                value: _energyLevel,
                min: 1,
                max: 5,
                lowLabel: 'Low',
                highLabel: 'High',
                onChanged: (value) {
                  setState(() {
                    _energyLevel = value.round();
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSliderField(
                title: 'Digestion Quality',
                value: _digestionQuality,
                min: 1,
                max: 5,
                lowLabel: 'Poor',
                highLabel: 'Excellent',
                onChanged: (value) {
                  setState(() {
                    _digestionQuality = value.round();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                initialValue: _notes,
                onChanged: (value) {
                  _notes = value;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitWellnessLog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Today\'s Log'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepHoursField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hours of Sleep'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _sleepHours.toDouble(),
                min: 0,
                max: 12,
                divisions: 12,
                label: _sleepHours.toString(),
                onChanged: (value) {
                  setState(() {
                    _sleepHours = value.round();
                  });
                },
              ),
            ),
            Container(
              width: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _sleepHours.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWaterIntakeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Water Intake (glasses)'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _waterIntake.toDouble(),
                min: 0,
                max: 12,
                divisions: 12,
                label: _waterIntake.toString(),
                onChanged: (value) {
                  setState(() {
                    _waterIntake = value.round();
                  });
                },
              ),
            ),
            Container(
              width: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _waterIntake.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSliderField({
    required String title,
    required int value,
    required double min,
    required double max,
    required String lowLabel,
    required String highLabel,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value.toDouble(),
                min: min,
                max: max,
                divisions: (max - min).round(),
                label: value.toString(),
                onChanged: onChanged,
              ),
            ),
            Container(
              width: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lowLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(highLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendations(WellnessProvider provider, String dominantDosha) {
    final recommendations = provider.getWellnessRecommendations(dominantDosha);
    
    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personalized Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...recommendations.map((recommendation) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.tips_and_updates, color: AppTheme.secondaryColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          recommendation,
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildWellnessHistory(WellnessProvider provider) {
    final logs = provider.logs;
    
    if (logs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Wellness History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length > 7 ? 7 : logs.length, // Show last 7 days
          itemBuilder: (context, index) {
            final log = logs[logs.length - 1 - index]; // Most recent first
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  DateFormat('EEEE, MMMM d').format(log.date),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Sleep: ${log.sleepHours}h | Water: ${log.waterIntake} glasses | Stress: ${log.stressLevel}/5',
                ),
                trailing: CircleAvatar(
                  backgroundColor: _getWellnessColor(log),
                  radius: 14,
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getWellnessColor(WellnessLog log) {
    // Calculate a simple score for this log
    int score = 0;
    score += log.sleepHours >= 7 ? 20 : log.sleepHours * 3;
    score += log.waterIntake >= 8 ? 20 : (log.waterIntake * 2.5).toInt();
    score += (6 - log.stressLevel) * 4;
    score += log.energyLevel * 4;
    score += log.digestionQuality * 4;
    
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.blue;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  void _submitWellnessLog() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<WellnessProvider>(context, listen: false);
      provider.logWellness(
        sleepHours: _sleepHours,
        waterIntake: _waterIntake,
        stressLevel: _stressLevel,
        energyLevel: _energyLevel,
        digestionQuality: _digestionQuality,
        notes: _notes.isNotEmpty ? _notes : null,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wellness log saved successfully!')),
      );
    }
  }
}