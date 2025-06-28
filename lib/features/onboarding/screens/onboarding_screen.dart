import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../features/auth/screens/login_screen.dart';
import '../../../features/prakriti/screens/prakriti_assessment_screen.dart';
import '../widgets/onboarding_page.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Discover Ancient Wisdom for Modern Wellness',
      'description': 'Experience the power of Ayurveda and Vedic practices tailored to your unique body constitution.',
      'image': 'assets/illustrations/onboarding_1.svg',
    },
    {
      'title': 'Personalized Ayurvedic Journey',
      'description': 'Discover your Prakriti (Vata, Pitta, Kapha) and receive customized recommendations for optimal health.',
      'image': 'assets/illustrations/onboarding_2.svg',
    },
    {
      'title': 'Balance Your Mind, Body & Spirit',
      'description': 'Track your wellness, practice yoga, meditate, and follow personalized diet plans to achieve harmony.',
      'image': 'assets/illustrations/onboarding_3.svg',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Navigate to Prakriti assessment using GoRouter
      context.go('/prakriti-assessment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {
                    // Use GoRouter for navigation
                    context.go('/login');
                  },
                  child: Text(
                    _currentPage < _onboardingData.length - 1 ? 'Skip' : 'Login',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    title: _onboardingData[index]['title'] ?? '',
                    description: _onboardingData[index]['description'] ?? '',
                    imagePath: _onboardingData[index]['image'] ?? '',
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _onboardingData.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Color(0xFF8E7F61),
                      dotColor: Color(0xFFE0E0E0),
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 4,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _goToNextPage,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(_currentPage < _onboardingData.length - 1 ? 'Next' : 'Start'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}