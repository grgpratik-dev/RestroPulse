import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';

@visibleForTesting
double restaurantPulseBpmForScore(double score) {
  final normalizedScore = score.clamp(0, 100).toDouble();

  if (normalizedScore >= 75) {
    return 72 + ((normalizedScore - 75) / 25 * 10);
  }
  if (normalizedScore >= 50) {
    return 52 + ((normalizedScore - 50) / 25 * 18);
  }
  return 36 + (normalizedScore / 50 * 16);
}

class RestaurantPulseHeart extends StatefulWidget {
  const RestaurantPulseHeart({required this.score, this.size = 120, super.key});

  final double score;
  final double size;

  @override
  State<RestaurantPulseHeart> createState() => _RestaurantPulseHeartState();
}

class _RestaurantPulseHeartState extends State<RestaurantPulseHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  bool? _animationsDisabled;

  double get _score => widget.score.clamp(0, 100).toDouble();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _beatDuration);
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 1.09,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.09,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.05,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 10,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 66),
    ]).animate(_controller);
  }

  Duration get _beatDuration {
    final beatsPerMinute = restaurantPulseBpmForScore(_score);
    return Duration(milliseconds: (60000 / beatsPerMinute).round());
  }

  @override
  void didUpdateWidget(RestaurantPulseHeart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score == widget.score) return;
    _controller.duration = _beatDuration;
    if (_animationsDisabled == false) {
      _controller
        ..reset()
        ..repeat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disabled = MediaQuery.disableAnimationsOf(context);
    if (_animationsDisabled == disabled) return;
    _animationsDisabled = disabled;

    if (disabled) {
      _controller
        ..stop()
        ..value = 0;
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roundedScore = _score.round();
    final beatDescription = switch (_score) {
      >= 75 => 'healthy steady heartbeat',
      >= 50 => 'moderate heartbeat',
      _ => 'slow heartbeat',
    };

    return Semantics(
      label:
          'Restaurant Pulse score: $roundedScore out of 100, $beatDescription',
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _scale,
            builder: (context, child) => Transform.scale(
              key: const ValueKey('restaurant-pulse-heart-transform'),
              scale: _animationsDisabled == true ? 1 : _scale.value,
              child: child,
            ),
            child: SizedBox.square(
              dimension: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    key: const ValueKey('restaurant-pulse-heart-fill'),
                    size: Size.square(widget.size),
                    painter: _HeartFillPainter(progress: _score / 100),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ink.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: '$roundedScore',
                        children: const [
                          TextSpan(
                            text: '/100',
                            style: AppTypography.labelSmall,
                          ),
                        ],
                      ),
                      style: AppTypography.metricMedium.copyWith(
                        color: AppColors.ink,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeartFillPainter extends CustomPainter {
  const _HeartFillPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final heart = _heartPath(size);

    canvas.drawShadow(heart, _glowColor.withValues(alpha: 0.62), 12, false);

    canvas.drawPath(
      heart,
      Paint()..color = AppColors.surface.withValues(alpha: 0.08),
    );

    canvas.save();
    canvas.clipPath(heart);
    final fillTop = size.height * (1 - progress.clamp(0, 1));
    canvas.drawRect(
      Rect.fromLTRB(0, fillTop, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: _fillColors,
        ).createShader(Offset.zero & size),
    );
    canvas.restore();

    canvas.drawPath(
      heart,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round
        ..color = AppColors.surface.withValues(alpha: 0.88),
    );
  }

  List<Color> get _fillColors => switch (progress) {
    >= 0.75 => const [
      AppColors.pulseHealthyDeep,
      AppColors.pulseHealthy,
      AppColors.pulseHealthyHighlight,
    ],
    >= 0.5 => const [AppColors.pulseModerate, AppColors.pulseModerateHighlight],
    _ => const [AppColors.pulseLow, AppColors.pulseLowHighlight],
  };

  Color get _glowColor => switch (progress) {
    >= 0.75 => AppColors.pulseHealthyGlow,
    >= 0.5 => AppColors.pulseModerate,
    _ => AppColors.pulseLow,
  };

  Path _heartPath(Size size) {
    final width = size.width;
    final height = size.height;
    return Path()
      ..moveTo(width * 0.5, height * 0.91)
      ..cubicTo(
        width * 0.42,
        height * 0.83,
        width * 0.08,
        height * 0.61,
        width * 0.08,
        height * 0.33,
      )
      ..cubicTo(
        width * 0.08,
        height * 0.12,
        width * 0.34,
        height * 0.04,
        width * 0.5,
        height * 0.25,
      )
      ..cubicTo(
        width * 0.66,
        height * 0.04,
        width * 0.92,
        height * 0.12,
        width * 0.92,
        height * 0.33,
      )
      ..cubicTo(
        width * 0.92,
        height * 0.61,
        width * 0.58,
        height * 0.83,
        width * 0.5,
        height * 0.91,
      )
      ..close();
  }

  @override
  bool shouldRepaint(covariant _HeartFillPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
