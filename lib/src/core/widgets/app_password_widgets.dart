import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class AppPasswordField extends StatelessWidget {
  const AppPasswordField({
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.onVisibilityChanged,
    this.fieldKey,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.autofillHints,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback onVisibilityChanged;
  final Key? fieldKey;
  final FormFieldValidator<String>? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      enableSuggestions: false,
      autocorrect: false,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          tooltip: obscureText ? 'Show $label' : 'Hide $label',
          onPressed: onVisibilityChanged,
          icon: AppIcon(
            obscureText
                ? AppIcons.visibility_off_outlined
                : AppIcons.visibility_outlined,
          ),
        ),
      ),
    );
  }
}

class AppPasswordRequirements extends StatelessWidget {
  const AppPasswordRequirements({required this.password, super.key});

  final String password;

  static bool isValid(String password) {
    return password.length >= 8 &&
        RegExp('[A-Za-z]').hasMatch(password) &&
        RegExp('[0-9]').hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    final hasMinimumLength = password.length >= 8;
    final hasLetter = RegExp('[A-Za-z]').hasMatch(password);
    final hasNumber = RegExp('[0-9]').hasMatch(password);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.neutral300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your new password must include',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.neutral700,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          _PasswordRequirement(
            label: 'At least 8 characters',
            isMet: hasMinimumLength,
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          _PasswordRequirement(label: 'At least one letter', isMet: hasLetter),
          const SizedBox(height: AppSpacing.spaceXs),
          _PasswordRequirement(label: 'At least one number', isMet: hasNumber),
        ],
      ),
    );
  }
}

class _PasswordRequirement extends StatelessWidget {
  const _PasswordRequirement({required this.label, required this.isMet});

  final String label;
  final bool isMet;

  @override
  Widget build(BuildContext context) {
    final color = isMet ? AppColors.success : AppColors.neutral500;
    return Row(
      children: [
        AppIcon(
          isMet ? AppIcons.check_circle_rounded : AppIcons.circle_outlined,
          color: color,
          size: 18,
        ),
        const SizedBox(width: AppSpacing.spaceXs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
