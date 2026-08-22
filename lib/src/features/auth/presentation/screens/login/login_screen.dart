import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/gen/assets.gen.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_divider.dart';
import 'package:restropulse/src/core/widgets/app_name.dart';
import 'package:restropulse/src/core/widgets/app_text_form_field.dart';

import '../../../../../app/router/app_route.dart';
import '../widgets/ambient_glow_widget.dart';
import '../widgets/fields_label_widget.dart';

part '../widgets/brand_header.dart';
part '../widgets/section_divider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: -110,
            right: -90,
            child: AmbientGlow(size: 280),
          ),
          const Positioned(
            bottom: -150,
            left: -130,
            child: AmbientGlow(size: 330, opacity: 0.55),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final minimumContentHeight =
                    (constraints.maxHeight - (AppSpacing.spaceLg * 2))
                        .clamp(0.0, double.infinity)
                        .toDouble();

                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(AppSpacing.spaceLg),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: minimumContentHeight,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 460),
                        child: AutofillGroup(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const BrandHeader(),
                              const SizedBox(height: AppSpacing.space2xl),
                              Text(
                                'Welcome back',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.displaySmall,
                              ),
                              const SizedBox(height: AppSpacing.spaceXs),
                              Text(
                                'Sign in to monitor your restaurant\'s health.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: AppSpacing.spaceXl),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const FieldLabel('Email address'),
                                  const SizedBox(height: AppSpacing.spaceXs),
                                  AppTextFormField(
                                    key: const ValueKey('login-email-field'),
                                    controller: _emailController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [AutofillHints.email],
                                    autocorrect: false,
                                    hintText: "Email address",

                                    prefixIcon: SvgPicture.asset(
                                      AppIcons.email_outlined,
                                      width: 10,
                                      height: 10,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.spaceMd),
                                  const FieldLabel('Password'),
                                  const SizedBox(height: AppSpacing.spaceXs),
                                  AppTextFormField(
                                    key: const ValueKey('login-password-field'),
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    hintText: "Password",
                                    prefixIcon: SvgPicture.asset(
                                      AppIcons.lock_outline_rounded,
                                      width: 22,
                                      height: 22,
                                    ),
                                    suffixIcon: SvgPicture.asset(
                                      _obscurePassword
                                          ? AppIcons.visibility_off_outlined
                                          : AppIcons.visibility_outlined,
                                      width: 22,
                                      height: 22,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.spaceSm),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () => context.pushNamed(
                                        AppRoute.forgotPassword.name,
                                        extra: _emailController.text.trim(),
                                      ),
                                      child: const Text('Forgot password?'),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.spaceMd),
                                  SizedBox(
                                    key: const ValueKey('login-submit-button'),
                                    width: double.infinity,
                                    height: 54,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        context.goNamed(
                                          AppRoute.dashboard.name,
                                        );
                                      },
                                      child: Text('Sign in'),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.spaceLg),
                                  const SectionDivider(),
                                  const SizedBox(height: AppSpacing.spaceLg),
                                  SizedBox(
                                    height: 52,
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 28,
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                            child: Image.asset(
                                              key: const ValueKey(
                                                'login-google-mark',
                                              ),
                                              Assets.images.googleLogo.path,
                                              fit: BoxFit.contain,
                                              filterQuality: FilterQuality.high,
                                            ),
                                          ),
                                          SizedBox(width: AppSpacing.spaceSm),
                                          Flexible(
                                            child: Text(
                                              'Continue with Google',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.spaceLg),
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      'New to RestroPulse?',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(fontSize: 14),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.goNamed(AppRoute.register.name);
                                      },
                                      child: const Text('Create account'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
