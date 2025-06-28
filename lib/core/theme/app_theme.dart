import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Traditional Vedic Colors
  static const Color primaryColor = Color(0xFFFF7F00); // Sacred Saffron (Spirituality)
  static const Color secondaryColor = Color(0xFF800020); // Kumkum Red (Divine)
  static const Color accentColor = Color(0xFFB8860B); // Sacred Turmeric
  static const Color backgroundColor = Color(0xFFFFF8E7); // Sacred Parchment
  static const Color darkBackgroundColor = Color(0xFF0F0A0A); // Deep Meditation

  // Dosha Colors (Ayurvedic Elements)
  static const Color vataColor = Color(0xFF6A5ACD); // Ethereal Purple (Air & Ether)
  static const Color pittaColor = Color(0xFFB22222); // Transformative Red (Fire)
  static const Color kaphaColor = Color(0xFF006400); // Nurturing Green (Earth & Water)
  static const Color tridoshaColor = Color(0xFF9370DB); // Balanced Tridosha

  // Chakra Colors
  static const Color muladharaColor = Color(0xFFDC143C); // Root Chakra
  static const Color svadhishthanaColor = Color(0xFFFF4500); // Sacral Chakra
  static const Color manipuraColor = Color(0xFFFFD700); // Solar Plexus Chakra
  static const Color anahataColor = Color(0xFF228B22); // Heart Chakra
  static const Color vishuddhaColor = Color(0xFF00CED1); // Throat Chakra
  static const Color ajnaColor = Color(0xFF4B0082); // Third Eye Chakra
  static const Color sahasraraColor = Color(0xFF9370DB); // Crown Chakra

  // Sacred Elements
  static const Color chakraGold = Color(0xFFDAA520); // Divine Gold
  static const Color sacredCopper = Color(0xFFCB6D51); // Healing Copper
  static const Color tulsiGreen = Color(0xFF355E3B); // Holy Basil
  
  // Traditional Ayurvedic Elements
  static const Color sandalwoodBeige = Color(0xFFD2B48C); // Chandan
  static const Color kumkumRed = Color(0xFFCD5C5C); // Sacred Kumkum
  static const Color haldiYellow = Color(0xFFFFD700); // Turmeric
  static const Color neemGreen = Color(0xFF9DC183); // Neem
  static const Color ashwagandhaAmber = Color(0xFFFFBF00); // Ashwagandha
  static const Color brahmiBlue = Color(0xFF6495ED); // Brahmi
  static const Color lotusWhite = Color(0xFFF5F5F5); // Sacred Lotus
  static const Color rudrakshaRust = Color(0xFFB7410E); // Rudraksha

  // Text colors
  static const Color textPrimaryDark = Color(0xFF2D2D2D);
  static const Color textPrimaryLight = Color(0xFFF9F5F0);
  static const Color textSecondaryDark = Color(0xFF6D6D6D);
  static const Color textSecondaryLight = Color(0xFFE0E0E0);

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: backgroundColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: textPrimaryDark,
      onBackground: textPrimaryDark,
      onSurface: textPrimaryDark,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrimaryDark),
      titleTextStyle: TextStyle(color: textPrimaryDark, fontSize: 20, fontWeight: FontWeight.w600),
    ),
    textTheme: GoogleFonts.spectralTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(color: textPrimaryDark, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(color: textPrimaryDark, fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.poppins(color: textPrimaryDark, fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.poppins(color: textPrimaryDark, fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.poppins(color: textPrimaryDark, fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(color: textPrimaryDark, fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.poppins(color: textPrimaryDark, fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.poppins(color: textPrimaryDark, fontSize: 16),
      bodyMedium: GoogleFonts.poppins(color: textPrimaryDark, fontSize: 14),
      bodySmall: GoogleFonts.poppins(color: textSecondaryDark, fontSize: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      hintStyle: GoogleFonts.poppins(color: textSecondaryDark, fontSize: 14),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
      shadowColor: primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: sacredCopper, width: 0.5),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: darkBackgroundColor,
      surface: const Color(0xFF3D3D3D),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: textPrimaryLight,
      onSurface: textPrimaryLight,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrimaryLight),
      titleTextStyle: TextStyle(color: textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w600),
    ),
    textTheme: GoogleFonts.spectralTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(color: textPrimaryLight, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(color: textPrimaryLight, fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.poppins(color: textPrimaryLight, fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.poppins(color: textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.poppins(color: textPrimaryLight, fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(color: textPrimaryLight, fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.poppins(color: textPrimaryLight, fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.poppins(color: textPrimaryLight, fontSize: 16),
      bodyMedium: GoogleFonts.poppins(color: textPrimaryLight, fontSize: 14),
      bodySmall: GoogleFonts.poppins(color: textSecondaryLight, fontSize: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF3D3D3D),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      hintStyle: GoogleFonts.poppins(color: textSecondaryLight, fontSize: 14),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF3D3D3D),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF3D3D3D),
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}