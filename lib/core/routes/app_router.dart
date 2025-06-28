import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../animations/page_transitions.dart';

// Screens
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/prakriti/screens/prakriti_assessment_screen.dart';
import '../../features/prakriti/screens/prakriti_result_screen.dart';
import '../../features/wellness_tracker/screens/wellness_dashboard_screen.dart';
import '../../features/wellness_tracker/screens/wellness_tracker_screen.dart';
import '../../features/ayurvedic_remedies/screens/remedies_screen.dart';
import '../../features/yoga_meditation/screens/yoga_list_screen.dart';
import '../../features/yoga_meditation/screens/meditation_list_screen.dart';
import '../../features/yoga_meditation/screens/yoga_detail_screen.dart';
import '../../features/yoga_meditation/screens/meditation_detail_screen.dart';
import '../../features/diet_plan/screens/diet_plan_screen.dart';
import '../../features/diet_plan/screens/recipe_detail_screen.dart';
import '../../features/diet_plan/screens/enhanced_diet_plan_screen.dart';
import '../../features/diet_plan/screens/enhanced_recipe_detail_screen.dart';
import '../../features/gamification/screens/rewards_screen.dart';
import '../../features/community/screens/community_screen.dart';
import '../../features/profile/screens/profile_screen.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    // Custom page transitions are applied in each route's pageBuilder
    routes: [
      // Onboarding and Authentication
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: AyurvedaPageTransitions.mandalaTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: AyurvedaPageTransitions.fadeTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: AyurvedaPageTransitions.fadeTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      
      // Main App Screens
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: AyurvedaPageTransitions.mandalaTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      
      // Prakriti Assessment
      GoRoute(
        path: '/prakriti-assessment',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const PrakritiAssessmentScreen(),
          transitionsBuilder: AyurvedaPageTransitions.chakraRevealTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      GoRoute(
        path: '/prakriti-result',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const PrakritiResultScreen(),
          transitionsBuilder: AyurvedaPageTransitions.scaleTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      
      // Wellness Tracker
      GoRoute(
        path: '/wellness',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const WellnessDashboardScreen(),
          transitionsBuilder: AyurvedaPageTransitions.slideTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      GoRoute(
        path: '/wellness-tracker',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const WellnessTrackerScreen(),
          transitionsBuilder: AyurvedaPageTransitions.slideTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      
      // Ayurvedic Remedies
      GoRoute(
        path: '/remedies',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const RemediesScreen(),
          transitionsBuilder: AyurvedaPageTransitions.slideTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      
      // Yoga & Meditation
      GoRoute(
        path: '/yoga',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const YogaListScreen(),
          transitionsBuilder: AyurvedaPageTransitions.slideTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      GoRoute(
        path: '/yoga/:id',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: YogaDetailScreen(
            yogaId: state.pathParameters['id'] ?? '',
          ),
          transitionsBuilder: AyurvedaPageTransitions.scaleTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      GoRoute(
        path: '/meditation',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const MeditationListScreen(),
          transitionsBuilder: AyurvedaPageTransitions.slideTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      GoRoute(
        path: '/meditation/:id',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: MeditationDetailScreen(
            meditationId: state.pathParameters['id'] ?? '',
          ),
          transitionsBuilder: AyurvedaPageTransitions.scaleTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      
      // Diet Plan
      GoRoute(
        path: '/diet-plan',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const DietPlanScreen(),
          transitionsBuilder: AyurvedaPageTransitions.slideTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      GoRoute(
        path: '/recipe/:id',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: RecipeDetailScreen(
            recipeId: state.pathParameters['id'] ?? '',
          ),
          transitionsBuilder: AyurvedaPageTransitions.scaleTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      // Enhanced Diet Plan
      GoRoute(
        path: '/enhanced-diet-plan',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const EnhancedDietPlanScreen(),
          transitionsBuilder: AyurvedaPageTransitions.slideTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      GoRoute(
        path: '/enhanced-recipe/:id',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: EnhancedRecipeDetailScreen(recipeId: state.pathParameters['id'] ?? ''),
          transitionsBuilder: AyurvedaPageTransitions.slideTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      
      // Gamification
      GoRoute(
        path: '/rewards',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const RewardsScreen(),
          transitionsBuilder: AyurvedaPageTransitions.slideTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      
      // Community
      GoRoute(
        path: '/community',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const CommunityScreen(),
          transitionsBuilder: AyurvedaPageTransitions.slideTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
      
      // Profile
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ProfileScreen(),
          transitionsBuilder: AyurvedaPageTransitions.slideTransition,
          transitionDuration: AyurvedaPageTransitions.defaultDuration,
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
}