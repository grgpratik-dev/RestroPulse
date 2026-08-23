import 'package:flutter/material.dart';
import 'package:restropulse/gen/assets.gen.dart';
import 'package:restropulse/src/app/di/dependency_injection.dart';
import 'package:restropulse/src/app/session/app_session_controller.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final onboardingData = [
  {
    'image': Assets.onboarding.onboarding1.path,
    'title': 'Know Your Restaurant’s Pulse',
    'description':
        'Get a clear view of your restaurant’s overall health at a glance.',
  },
  {
    'image': Assets.onboarding.onboarding2.path,
    'title': 'Track Sales & Expenses Easily',
    'description':
        'Record sales, manage expenses, and keep your restaurant’s numbers organized.',
  },
  {
    'image': Assets.onboarding.onboarding3.path,
    'title': 'Get Insights & Grow Your Business',
    'description':
        'Understand what’s working, identify what needs attention, and make better decisions to grow.',
  },
];

ValueNotifier<bool> _isLastPageView = ValueNotifier<bool>(false);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: .center,
          children: [
            Positioned(
              top: 16,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: onboardingData.length,

                effect: ExpandingDotsEffect(
                  dotColor: AppColors.primary.withAlpha(60),
                  dotHeight: 8,
                  expansionFactor: 2,
                  dotWidth: 74,
                ),
              ),
            ),

            PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: onboardingData.map((data) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(data['image']!, height: 400),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        children: [
                          Text(
                            data['title']!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data['description']!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            Positioned(
              bottom: 0,
              left: 16,
              right: 16,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_isLastPageView.value) {
                      sl.get<AppSessionController>().completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );

                      _isLastPageView.value =
                          _pageController.page == onboardingData.length - 2;
                    }
                  },

                  child: ValueListenableBuilder(
                    valueListenable: _isLastPageView,
                    builder: (context, value, child) {
                      return Text(value ? 'Get Started' : 'Next');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
