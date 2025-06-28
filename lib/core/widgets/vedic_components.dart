import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'vedic_decorations.dart';

class VedicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final String? doshaType;

  const VedicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.doshaType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: doshaType != null
          ? VedicDecorations.doshaCard(context, doshaType!)
          : VedicDecorations.chakraGradientCard(context),
      child: child,
    );
  }
}



class VedicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double height;
  final double width;

  const VedicButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 56,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: VedicDecorations.lotusButtonDecoration(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(40),
          child: Center(child: child),
        ),
      ),
    );
  }
}



class VedicDivider extends StatelessWidget {
  final double height;
  final Color? color;

  const VedicDivider({
    super.key,
    this.height = 1,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            color ?? AppTheme.sacredCopper.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}



class VedicIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double size;

  const VedicIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (color ?? AppTheme.primaryColor).withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: color ?? AppTheme.primaryColor,
          size: size,
        ),
      ),
    );
  }
}



class VedicChakraCard extends StatelessWidget {
  final Widget child;
  final String chakraType;
  final EdgeInsetsGeometry padding;

  const VedicChakraCard({
    super.key,
    required this.child,
    required this.chakraType,
    this.padding = const EdgeInsets.all(16),
  });

  Color _getChakraColor() {
    switch (chakraType.toLowerCase()) {
      case 'muladhara': return AppTheme.muladharaColor;
      case 'svadhishthana': return AppTheme.svadhishthanaColor;
      case 'manipura': return AppTheme.manipuraColor;
      case 'anahata': return AppTheme.anahataColor;
      case 'vishuddha': return AppTheme.vishuddhaColor;
      case 'ajna': return AppTheme.ajnaColor;
      case 'sahasrara': return AppTheme.sahasraraColor;
      default: return AppTheme.chakraGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chakraColor = _getChakraColor();
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: chakraColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: chakraColor.withOpacity(0.3),
          width: 1,
        ),
        image: DecorationImage(
          image: AssetImage('assets/patterns/${chakraType.toLowerCase()}_chakra.svg'),
          opacity: 0.08,
          alignment: Alignment.bottomRight,
          scale: 2.0,
        ),
      ),
      child: child,
    );
  }
}



class VedicProgressIndicator extends StatelessWidget {
  final double value;
  final Color? color;
  final double height;

  const VedicProgressIndicator({
    super.key,
    required this.value,
    this.color,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color: (color ?? AppTheme.primaryColor).withOpacity(0.1),
      ),
      child: FractionallySizedBox(
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            gradient: LinearGradient(
              colors: [
                color ?? AppTheme.primaryColor,
                AppTheme.chakraGold,
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class AyurvedicDoshaCard extends StatelessWidget {
  final Widget child;
  final String doshaType;
  final EdgeInsetsGeometry padding;
  final bool showDoshaSymbol;

  const AyurvedicDoshaCard({
    super.key,
    required this.child,
    required this.doshaType,
    this.padding = const EdgeInsets.all(16),
    this.showDoshaSymbol = true,
  });

  Color _getDoshaColor() {
    switch (doshaType.toLowerCase()) {
      case 'vata': return AppTheme.vataColor;
      case 'pitta': return AppTheme.pittaColor;
      case 'kapha': return AppTheme.kaphaColor;
      default: return AppTheme.primaryColor;
    }
  }

  String _getDoshaSymbolAsset() {
    switch (doshaType.toLowerCase()) {
      case 'vata': return 'assets/patterns/vata_symbol.svg';
      case 'pitta': return 'assets/patterns/pitta_symbol.svg';
      case 'kapha': return 'assets/patterns/kapha_symbol.svg';
      default: return 'assets/patterns/tridosha_symbol.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final doshaColor = _getDoshaColor();
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: doshaColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: doshaColor.withOpacity(0.3),
          width: 1,
        ),
        image: showDoshaSymbol ? DecorationImage(
          image: AssetImage(_getDoshaSymbolAsset()),
          opacity: 0.08,
          alignment: Alignment.bottomRight,
          scale: 2.0,
        ) : null,
      ),
      child: child,
    );
  }
}



class SacredGeometryBackground extends StatelessWidget {
  final Widget child;
  final String patternType;
  final double opacity;

  const SacredGeometryBackground({
    super.key,
    required this.child,
    this.patternType = 'sri_yantra',
    this.opacity = 0.05,
  });

  String _getPatternAsset() {
    switch (patternType.toLowerCase()) {
      case 'sri_yantra': return 'assets/patterns/sri_yantra.svg';
      case 'flower_of_life': return 'assets/patterns/flower_of_life.svg';
      case 'metatron_cube': return 'assets/patterns/metatron_cube.svg';
      case 'seed_of_life': return 'assets/patterns/seed_of_life.svg';
      default: return 'assets/patterns/sacred_geometry.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        image: DecorationImage(
          image: AssetImage(_getPatternAsset()),
          opacity: opacity,
          repeat: ImageRepeat.repeat,
          scale: 0.8,
        ),
      ),
      child: child,
    );
  }
}



class MandalaProgressIndicator extends StatelessWidget {
  final double value;
  final double size;
  final Color? color;
  final String chakraType;

  const MandalaProgressIndicator({
    super.key,
    required this.value,
    this.size = 60,
    this.color,
    this.chakraType = 'anahata',
  });

  Color _getChakraColor() {
    switch (chakraType.toLowerCase()) {
      case 'muladhara': return AppTheme.muladharaColor;
      case 'svadhishthana': return AppTheme.svadhishthanaColor;
      case 'manipura': return AppTheme.manipuraColor;
      case 'anahata': return AppTheme.anahataColor;
      case 'vishuddha': return AppTheme.vishuddhaColor;
      case 'ajna': return AppTheme.ajnaColor;
      case 'sahasrara': return AppTheme.sahasraraColor;
      default: return AppTheme.chakraGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chakraColor = color ?? _getChakraColor();
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background mandala
          Image.asset(
            'assets/patterns/${chakraType.toLowerCase()}_mandala.svg',
            width: size,
            height: size,
            color: chakraColor.withOpacity(0.2),
          ),
          // Progress circle
          CircularProgressIndicator(
            value: value,
            strokeWidth: size / 10,
            backgroundColor: chakraColor.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(chakraColor),
          ),
          // Center dot
          Container(
            width: size / 5,
            height: size / 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: chakraColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}