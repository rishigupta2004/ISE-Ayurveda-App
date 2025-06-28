import 'package:flutter/material.dart';

/// Custom page transitions for the Ayurveda app
class AyurvedaPageTransitions {
  /// Private constructor to prevent instantiation
  AyurvedaPageTransitions._();

  /// Default duration for transitions
  static const Duration defaultDuration = Duration(milliseconds: 400);

  /// Fade transition between pages
  static Widget fadeTransition(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Slide transition from right
  static Widget slideTransition(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  /// Scale and fade transition
  static Widget scaleTransition(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const curve = Curves.easeOutQuint;

    var fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    var scaleAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }

  /// Chakra-inspired circular reveal transition
  static Widget chakraRevealTransition(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return ClipPath(
      clipper: _CircularRevealClipper(
        fraction: animation.value,
        centerAlignment: Alignment.center,
      ),
      child: child,
    );
  }

  /// Mandala-inspired rotation and scale transition
  static Widget mandalaTransition(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const curve = Curves.easeInOutCubic;

    var rotateAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    var scaleAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return FadeTransition(
      opacity: animation,
      child: RotationTransition(
        turns: Tween(begin: 0.05, end: 0.0).animate(rotateAnimation),
        child: ScaleTransition(
          scale: Tween(begin: 0.7, end: 1.0).animate(scaleAnimation),
          child: child,
        ),
      ),
    );
  }
}

/// Circular reveal clipper for chakra transition
class _CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Alignment centerAlignment;

  _CircularRevealClipper({
    required this.fraction,
    this.centerAlignment = Alignment.center,
  });

  @override
  Path getClip(Size size) {
    final center = Offset(
      size.width * (centerAlignment.x * 0.5 + 0.5),
      size.height * (centerAlignment.y * 0.5 + 0.5),
    );
    
    final radius = size.height * fraction;

    final path = Path()
      ..addOval(Rect.fromCircle(
        center: center,
        radius: radius,
      ));

    return path;
  }

  @override
  bool shouldReclip(_CircularRevealClipper oldClipper) {
    return oldClipper.fraction != fraction || oldClipper.centerAlignment != centerAlignment;
  }
}