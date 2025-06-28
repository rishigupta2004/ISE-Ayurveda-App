import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class VedicDecorations {
  static BoxDecoration mandalaBackground(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      // SVG patterns need to be loaded differently than raster images
      // For repeating patterns, we'll handle this in the widget that uses this decoration
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.sahasraraColor.withOpacity(0.05),
          AppTheme.muladharaColor.withOpacity(0.05),
        ],
      ),
    );
  }

  static BoxDecoration chakraGradientCard(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppTheme.chakraGold.withOpacity(0.15),
          AppTheme.sacredCopper.withOpacity(0.08),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: AppTheme.sacredCopper.withOpacity(0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: AppTheme.chakraGold.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration doshaCard(BuildContext context, String dosha) {
    Color doshaColor;
    switch (dosha.toLowerCase()) {
      case 'vata':
        doshaColor = AppTheme.vataColor;
        break;
      case 'pitta':
        doshaColor = AppTheme.pittaColor;
        break;
      case 'kapha':
        doshaColor = AppTheme.kaphaColor;
        break;
      default:
        doshaColor = AppTheme.primaryColor;
    }

    return BoxDecoration(
      color: doshaColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: doshaColor.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  static BoxDecoration sacredGeometryCard(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: AppTheme.sacredCopper.withOpacity(0.3),
        width: 1,
      ),
      // SVG patterns will be handled by the SvgPicture widget in the component
      // that uses this decoration instead of using DecorationImage
    );
  }

  static ShapeDecoration lotusButtonDecoration(BuildContext context) {
    return ShapeDecoration(
      color: AppTheme.primaryColor,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      shadows: [
        BoxShadow(
          color: AppTheme.primaryColor.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}