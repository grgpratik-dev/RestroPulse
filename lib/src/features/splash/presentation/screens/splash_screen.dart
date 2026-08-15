import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/gen/assets.gen.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/app/theme/app_typography.dart';

part 'widgets/pulse_glow_painter_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _pulseDuration = Duration(milliseconds: 1800);
  static const _pulseAreaSize = 320.0;
  static const _logoWidth = 184.0;

  late final AnimationController _pulseController;
  late final Animation<double> _logoScale;
  bool? _animationsDisabled;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: _pulseDuration,
    );
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 1.045,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.045,
          end: 0.99,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.99,
          end: 1.02,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.02,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 12,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 60),
    ]).animate(_pulseController);

    // delayed navigation for now
    Future.delayed(Duration(seconds: 3)).then((value) {
      if (mounted) {
        context.goNamed(AppRoute.onboarding.name);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final animationsDisabled = MediaQuery.disableAnimationsOf(context);
    if (_animationsDisabled == animationsDisabled) return;

    _animationsDisabled = animationsDisabled;
    if (animationsDisabled) {
      _pulseController
        ..stop()
        ..value = 0;
    } else {
      _pulseController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff11B981),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceLg),
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              RepaintBoundary(
                child: SizedBox.square(
                  dimension: _pulseAreaSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ExcludeSemantics(
                        child: CustomPaint(
                          key: const ValueKey('splash-pulse-glow'),
                          size: const Size.square(_pulseAreaSize),
                          painter: PulseGlowPainter(_pulseController),
                        ),
                      ),
                      ScaleTransition(
                        key: const ValueKey('splash-logo-scale'),
                        scale: _logoScale,
                        child: ExcludeSemantics(
                          child: Image.asset(
                            Assets.logo.applogo.path,
                            key: const ValueKey('splash-logo'),
                            width: _logoWidth,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text.rich(
                TextSpan(
                  text: 'Restro',
                  children: const [
                    TextSpan(
                      text: 'Pulse',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTypography.plusJakartaSansFontFamily,
                ),
                semanticsLabel: 'RestroPulse',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
