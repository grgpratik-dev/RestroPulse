import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_password_widgets.dart';
import 'widgets/password_recovery_header.dart';

typedef ResetPassword = Future<void> Function(String password);

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({this.onResetPassword, super.key});

  final ResetPassword? onResetPassword;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _isSaving = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_refreshRequirements);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_refreshRequirements);
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(backgroundColor: AppColors.authBackground),
      body: SafeArea(
        top: false,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceLg,
            AppSpacing.spaceMd,
            AppSpacing.spaceLg,
            AppSpacing.space2xl,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: _completed ? _buildSuccess() : _buildForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PasswordRecoveryHeader(
            title: 'Create a new password',
            message:
                'Choose a secure password you haven’t used for this account before.',
          ),
          const SizedBox(height: AppSpacing.spaceXl),
          AppPasswordField(
            fieldKey: const ValueKey('reset-password-field'),
            controller: _passwordController,
            label: 'New password',
            obscureText: _obscurePassword,
            autofillHints: const [AutofillHints.newPassword],
            onVisibilityChanged: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            validator: (value) {
              final password = value ?? '';
              if (password.isEmpty) return 'Enter a new password';
              if (!AppPasswordRequirements.isValid(password)) {
                return 'Use at least 8 characters with a letter and number';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          AppPasswordRequirements(password: _passwordController.text),
          const SizedBox(height: AppSpacing.spaceLg),
          AppPasswordField(
            fieldKey: const ValueKey('reset-password-confirmation-field'),
            controller: _confirmationController,
            label: 'Confirm new password',
            obscureText: _obscureConfirmation,
            autofillHints: const [AutofillHints.newPassword],
            textInputAction: TextInputAction.done,
            onVisibilityChanged: () =>
                setState(() => _obscureConfirmation = !_obscureConfirmation),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm your new password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            onFieldSubmitted: (_) => _savePassword(),
          ),
          const SizedBox(height: AppSpacing.spaceXl),
          SizedBox(
            height: 52,
            child: FilledButton(
              key: const ValueKey('reset-password-submit-button'),
              onPressed: _isSaving ? null : _savePassword,
              child: _isSaving
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Update password'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PasswordRecoveryHeader(
          title: 'Password updated',
          message:
              'Your password has been changed. You can now sign in with your new password.',
          success: true,
        ),
        const SizedBox(height: AppSpacing.spaceXl),
        FilledButton(
          key: const ValueKey('reset-success-login-button'),
          onPressed: () => context.goNamed(AppRoute.login.name),
          child: const Text('Continue to sign in'),
        ),
      ],
    );
  }

  Future<void> _savePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await widget.onResetPassword?.call(_passwordController.text);
      if (mounted) setState(() => _completed = true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _refreshRequirements() => setState(() {});
}
