import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/prakriti_provider.dart';
import '../models/prakriti_question.dart';
import 'prakriti_result_screen.dart';

class PrakritiAssessmentScreen extends StatefulWidget {
  const PrakritiAssessmentScreen({super.key});

  @override
  State<PrakritiAssessmentScreen> createState() => _PrakritiAssessmentScreenState();
}

class _PrakritiAssessmentScreenState extends State<PrakritiAssessmentScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Reset the assessment when starting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrakritiProvider>(context, listen: false).resetAssessment();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _answerQuestion(String doshaType) {
    final provider = Provider.of<PrakritiProvider>(context, listen: false);
    provider.answerQuestion(doshaType);
    
    if (provider.hasCompletedAssessment) {
      // Use GoRouter for consistent navigation
      context.go('/prakriti-result');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Your Prakriti'),
        elevation: 0,
      ),
      body: Consumer<PrakritiProvider>(builder: (context, provider, child) {
        return Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (provider.currentQuestionIndex + 1) / provider.questions.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8E7F61)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Question ${provider.currentQuestionIndex + 1}/${provider.questions.length}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            // Questions
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionCard(provider.questions[index]);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildQuestionCard(PrakritiQuestion question) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          _buildOptionCard('vata', question.vataOption),
          const SizedBox(height: 16),
          _buildOptionCard('pitta', question.pittaOption),
          const SizedBox(height: 16),
          _buildOptionCard('kapha', question.kaphaOption),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String doshaType, String optionText) {
    Color cardColor;
    switch (doshaType) {
      case 'vata':
        cardColor = const Color(0xFF85A1C1).withOpacity(0.1);
        break;
      case 'pitta':
        cardColor = const Color(0xFFE8A87C).withOpacity(0.1);
        break;
      case 'kapha':
        cardColor = const Color(0xFF8E7F61).withOpacity(0.1);
        break;
      default:
        cardColor = Colors.white;
    }

    return InkWell(
      onTap: () => _answerQuestion(doshaType),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Text(
          optionText,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}