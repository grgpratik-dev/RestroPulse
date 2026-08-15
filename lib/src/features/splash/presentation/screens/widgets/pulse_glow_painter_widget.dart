part of '../splash_screen.dart';


class PulseGlowPainter extends CustomPainter {
  PulseGlowPainter(this.animation) : super(repaint: animation);

  static const _minimumRadius = 82.0;
  static const _glowOpacity = 0.32;

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maximumRadius = (size.shortestSide / 2) - 4;
    final radiusProgress = Curves.easeOutCubic.transform(animation.value);
    final fadeProgress = Curves.easeInCubic.transform(animation.value);
    final opacity = _glowOpacity * (1 - fadeProgress);
    final radius =
        _minimumRadius + ((maximumRadius - _minimumRadius) * radiusProgress);
    final bounds = Rect.fromCircle(center: center, radius: radius);
    final glow = RadialGradient(
      colors: [
        AppColors.splashAccent.withValues(alpha: opacity),
        Colors.white.withValues(alpha: opacity * 0.48),
        Colors.transparent,
      ],
      stops: const [0, 0.56, 1],
    );
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = glow.createShader(bounds);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(PulseGlowPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
