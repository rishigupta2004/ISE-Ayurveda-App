import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dart:math' as Math;

/// Collection of custom animations for the Ayurveda app
class VedicAnimations {
  /// Private constructor to prevent instantiation
  VedicAnimations._();

  /// Creates a pulsating effect, ideal for chakra points or energy indicators
  static Widget pulsatingEffect({
    required Widget child,
    Duration duration = const Duration(seconds: 2),
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: minScale, end: maxScale),
      duration: duration,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
      onEnd: () {},
    );
  }

  /// Creates a breathing animation effect, simulating meditation breathing
  static Widget breathingAnimation({
    required Widget child,
    Duration duration = const Duration(seconds: 4),
    double minOpacity = 0.7,
    double maxOpacity = 1.0,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: minOpacity, end: maxOpacity),
          duration: duration,
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
          child: child,
          onEnd: () {},
        );
      },
    );
  }

  /// Creates a chakra spinning animation
  static Widget chakraSpinning({
    required Widget child,
    Duration duration = const Duration(seconds: 20),
    bool clockwise = true,
  }) {
    return RotationTransition(
      turns: clockwise
          ? TweenSequence<double>([
              TweenSequenceItem<double>(
                tween: Tween<double>(begin: 0, end: 1),
                weight: 1,
              ),
            ]).animate(
              CurvedAnimation(
                parent: const AlwaysStoppedAnimation(1),
                curve: Curves.linear,
              ),
            )
          : TweenSequence<double>([
              TweenSequenceItem<double>(
                tween: Tween<double>(begin: 0, end: -1),
                weight: 1,
              ),
            ]).animate(
              CurvedAnimation(
                parent: const AlwaysStoppedAnimation(1),
                curve: Curves.linear,
              ),
            ),
      child: child,
    );
  }

  /// Creates a shimmer loading effect with ayurvedic colors
  static Widget shimmerLoading({
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    Color baseColor = AppTheme.backgroundColor,
    Color highlightColor = AppTheme.chakraGold,
  }) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [baseColor, highlightColor, baseColor],
          stops: const [0.1, 0.3, 0.4],
          begin: const Alignment(-1.0, -0.3),
          end: const Alignment(1.0, 0.3),
          tileMode: TileMode.clamp,
        ).createShader(bounds);
      },
      child: child,
    );
  }

  /// Creates a staggered fade-in animation for lists
  static Widget staggeredFadeIn({
    required Widget child,
    required int index,
    Duration delay = const Duration(milliseconds: 50),
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// A loading spinner with Ayurvedic design elements
class VedicLoadingSpinner extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const VedicLoadingSpinner({
    super.key,
    this.size = 50.0,
    this.color = AppTheme.primaryColor,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<VedicLoadingSpinner> createState() => _VedicLoadingSpinnerState();
}

class _VedicLoadingSpinnerState extends State<VedicLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _MandalaSpinnerPainter(
              color: widget.color,
              progress: _controller.value,
            ),
            size: Size(widget.size, widget.size),
          );
        },
      ),
    );
  }
}

class _MandalaSpinnerPainter extends CustomPainter {
  final Color color;
  final double progress;

  _MandalaSpinnerPainter({
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Draw the outer circle
    final outerPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawCircle(center, radius * 0.9, outerPaint);
    
    // Draw the spinning arc
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    
    final startAngle = -0.5 * 3.14159;
    final sweepAngle = 2 * 3.14159 * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.9),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
    
    // Draw the inner petals
    final petalPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    for (int i = 0; i < 8; i++) {
      final angle = 2 * 3.14159 * i / 8 + (progress * 2 * 3.14159);
      final x = center.dx + radius * 0.5 * cos(angle);
      final y = center.dy + radius * 0.5 * sin(angle);
      
      canvas.drawCircle(Offset(x, y), radius * 0.1, petalPaint);
    }
  }

  @override
  bool shouldRepaint(_MandalaSpinnerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
  
  // Helper method for trigonometric calculations
  double sin(double angle) => Math.sin(angle);
  double cos(double angle) => Math.cos(angle);
}

