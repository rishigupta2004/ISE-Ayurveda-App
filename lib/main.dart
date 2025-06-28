import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

// Import local files
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/home/screens/home_screen.dart';

// Providers
import 'features/auth/providers/auth_provider.dart';
import 'features/prakriti/providers/prakriti_provider.dart';
import 'features/wellness_tracker/providers/wellness_provider.dart';
import 'features/ayurvedic_remedies/providers/remedies_provider.dart';
import 'features/yoga_meditation/providers/yoga_meditation_provider.dart';
import 'features/diet_plan/providers/diet_provider.dart';
import 'features/gamification/providers/rewards_provider.dart';
import 'features/community/providers/community_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Register Hive adapters here
  await Hive.openBox('userBox');
  await Hive.openBox('prakritBox');
  await Hive.openBox('wellnessBox');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PrakritiProvider()),
        ChangeNotifierProvider(create: (_) => WellnessProvider()),
        ChangeNotifierProvider(create: (_) => RemediesProvider()),
        ChangeNotifierProvider(create: (_) => YogaMeditationProvider()),
        ChangeNotifierProvider(create: (_) => DietProvider()),
        ChangeNotifierProvider(create: (_) => RewardsProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
      ],
      child: MaterialApp.router(
        title: 'Ayurveda App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
