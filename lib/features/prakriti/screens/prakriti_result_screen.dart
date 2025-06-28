import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:confetti/confetti.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/prakriti_provider.dart';
import '../models/prakriti_result.dart';
import '../../home/screens/home_screen.dart';

class PrakritiResultScreen extends StatefulWidget {
  const PrakritiResultScreen({super.key});

  @override
  State<PrakritiResultScreen> createState() => _PrakritiResultScreenState();
}

class _PrakritiResultScreenState extends State<PrakritiResultScreen> {
  late ConfettiController _confettiController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Prakriti Results'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Use GoRouter for consistent navigation
              context.go('/home');
            },
          ),
        ],
      ),
      body: Consumer<PrakritiProvider>(builder: (context, provider, child) {
        final result = provider.getPrakritiResult();
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultHeader(result),
                    const SizedBox(height: 24),
                    _buildDoshaDescription(result),
                    const SizedBox(height: 24),
                    _buildDoshaDistribution(result),
                    const SizedBox(height: 24),
                    _buildRecommendationTabs(),
                    const SizedBox(height: 16),
                    _buildRecommendationContent(result),
                    const SizedBox(height: 32),
                    _buildContinueButton(),
                  ],
                ),
              ),
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              colors: const [
                Color(0xFF8E7F61),
                Color(0xFFE8A87C),
                Color(0xFF85A1C1),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDoshaDescription(PrakritiResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Your Dosha',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          result.doshaDescription,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
        const Text(
          'Key Characteristics',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...result.doshaCharacteristics.map((characteristic) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      characteristic,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildDoshaDistribution(PrakritiResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Dosha Distribution',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDoshaPercentage('Vata', result.vataPercentage, AppTheme.vataColor),
            _buildDoshaPercentage('Pitta', result.pittaPercentage, AppTheme.pittaColor),
            _buildDoshaPercentage('Kapha', result.kaphaPercentage, AppTheme.kaphaColor),
          ],
        ),
      ],
    );
  }

  Widget _buildDoshaPercentage(String doshaName, double percentage, Color color) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 8.0,
          percent: percentage / 100,
          center: Text(
            '${percentage.toStringAsFixed(0)}%',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          progressColor: color,
          backgroundColor: color.withOpacity(0.2),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 1500,
        ),
        const SizedBox(height: 8),
        Text(
          doshaName,
          style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRecommendationTabs() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildTabButton(0, 'Diet'),
          _buildTabButton(1, 'Lifestyle'),
          _buildTabButton(2, 'Exercise'),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationContent(PrakritiResult result) {
    List<String> recommendations;
    String title;

    switch (_selectedTabIndex) {
      case 0:
        recommendations = result.dietRecommendations;
        title = 'Diet Recommendations';
        break;
      case 1:
        recommendations = result.lifestyleRecommendations;
        title = 'Lifestyle Recommendations';
        break;
      case 2:
        recommendations = result.exerciseRecommendations;
        title = 'Exercise Recommendations';
        break;
      default:
        recommendations = result.dietRecommendations;
        title = 'Diet Recommendations';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...recommendations.map((recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Since HomeScreen is not implemented yet, we'll navigate to the onboarding screen
          // This should be updated once HomeScreen is implemented
          Navigator.of(context).pushReplacementNamed('/home');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Continue to Dashboard',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildResultHeader(PrakritiResult result) {
    Color doshaColor;
    switch (result.dominantDosha) {
      case 'Vata':
        doshaColor = const Color(0xFF85A1C1);
        break;
      case 'Pitta':
        doshaColor = const Color(0xFFE8A87C);
        break;
      case 'Kapha':
        doshaColor = const Color(0xFF8E7F61);
        break;
      default:
        doshaColor = Colors.grey;
    }

    return Center(
      child: Column(
        children: [
          const Text(
            'Your Dominant Dosha is',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            result.dominantDosha,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: doshaColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: doshaColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Based on your responses to the assessment',
              style: TextStyle(color: doshaColor),
            ),
          ),
        ],
      ),
    );
  }
}