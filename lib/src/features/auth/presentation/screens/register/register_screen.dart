import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';

import '../widgets/ambient_glow_widget.dart';
import '../widgets/fields_label_widget.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppColors.authBackground,
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
                              Text(
                                'Create your account',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.displaySmall?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.spaceXs),
                              Text(
                                'Join the healthy business partner platform. Start optimizing your restaurant today.',
                                textAlign: TextAlign.start,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.spaceXl),
                              const FieldLabel('Full name'),
                              const SizedBox(height: AppSpacing.spaceXs),
                              TextFormField(
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.name],
                                decoration: InputDecoration(
                                  fillColor: colorScheme.surface,
                                  hintText: 'Enter full name',
                                  prefixIcon: SvgPicture.asset(
                                    AppIcons.person_outline_rounded,
                                    width: 22,
                                    height: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.spaceMd),
                              const FieldLabel('Email address'),
                              const SizedBox(height: AppSpacing.spaceXs),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                autocorrect: false,
                                decoration: InputDecoration(
                                  fillColor: colorScheme.surface,
                                  hintText: 'Enter email address',
                                  prefixIcon: SvgPicture.asset(
                                    AppIcons.email_outlined,
                                    width: 22,
                                    height: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.spaceMd),
                              const FieldLabel('Password'),
                              const SizedBox(height: AppSpacing.spaceXs),
                              TextFormField(
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [
                                  AutofillHints.newPassword,
                                ],
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  fillColor: colorScheme.surface,
                                  hintText: 'Create a password',
                                  prefixIcon: SvgPicture.asset(
                                    AppIcons.lock_outline_rounded,
                                    width: 22,
                                    height: 22,
                                  ),
                                  suffixIcon: IconButton(
                                    tooltip: _obscurePassword
                                        ? 'Show password'
                                        : 'Hide password',
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: SvgPicture.asset(
                                      _obscurePassword
                                          ? AppIcons.visibility_off_outlined
                                          : AppIcons.visibility_outlined,
                                      width: 22,
                                      height: 22,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.spaceMd),
                              const FieldLabel('Confirm password'),
                              const SizedBox(height: AppSpacing.spaceXs),
                              TextFormField(
                                obscureText: _obscureConfirmation,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [
                                  AutofillHints.newPassword,
                                ],
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  fillColor: colorScheme.surface,
                                  hintText: 'Re-enter your password',
                                  prefixIcon: SvgPicture.asset(
                                    AppIcons.lock_outline,
                                    width: 22,
                                    height: 22,
                                  ),
                                  suffixIcon: IconButton(
                                    tooltip: _obscureConfirmation
                                        ? 'Show password confirmation'
                                        : 'Hide password confirmation',
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmation =
                                            !_obscureConfirmation;
                                      });
                                    },
                                    icon: SvgPicture.asset(
                                      _obscureConfirmation
                                          ? AppIcons.visibility_off_outlined
                                          : AppIcons.visibility_outlined,
                                      width: 22,
                                      height: 22,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.spaceLg),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  key: const ValueKey('register-submit-button'),
                                  onPressed: () {
                                    context.goNamed(
                                      AppRoute.restaurantAccess.name,
                                    );
                                  },
                                  child: Text('Create account'),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.spaceSm),
                              Text.rich(
                                TextSpan(
                                  text:
                                      'By creating an account, you agree to our ',
                                  children: const [
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(text: '.'),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.spaceLg),
                              SizedBox(
                                width: double.infinity,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: AppSpacing.space2xs,
                                  children: [
                                    Text(
                                      'Already have an account?',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                            fontSize: 14,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.goNamed(AppRoute.login.name);
                                      },
                                      child: const Text('Sign in'),
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
