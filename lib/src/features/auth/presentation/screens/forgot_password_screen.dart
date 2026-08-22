import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'widgets/password_recovery_header.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

typedef SendResetLink = Future<void> Function(String email);

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    this.initialEmail,
    this.onSendResetLink,
    super.key,
  });

  final String? initialEmail;
  final SendResetLink? onSendResetLink;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _isSending = false;
  bool _linkSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        leading: IconButton(
          tooltip: 'Back to sign in',
          onPressed: _backToLogin,
          icon: SvgPicture.asset(
            AppIcons.arrow_back_rounded,
            width: 24,
            height: 24,
          ),
        ),
      ),
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
                child: _linkSent ? _buildConfirmation() : _buildRequestForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PasswordRecoveryHeader(
            title: 'Forgot your password?',
            message:
                'Enter the email address you use for RestroPulse and we’ll send you a secure reset link.',
          ),
          const SizedBox(height: AppSpacing.spaceXl),
          TextFormField(
            key: const ValueKey('recovery-email-field'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Email address',
              hintText: 'Enter your email',
              prefixIcon: SvgPicture.asset(
                AppIcons.email_outlined,
                width: 22,
                height: 22,
              ),
            ),
            validator: _validateEmail,
            onFieldSubmitted: (_) => _sendResetLink(),
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          SizedBox(
            height: 52,
            child: FilledButton(
              key: const ValueKey('send-reset-link-button'),
              onPressed: _isSending ? null : _sendResetLink,
              child: _isSending
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send reset link'),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          TextButton(
            onPressed: _backToLogin,
            child: const Text('Back to sign in'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmation() {
    final email = _emailController.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PasswordRecoveryHeader(
          title: 'Check your email',
          message:
              'If an account exists for $email, you’ll receive a password reset link shortly.',
          success: true,
        ),
        const SizedBox(height: AppSpacing.spaceXl),
        FilledButton(
          key: const ValueKey('recovery-back-to-login-button'),
          onPressed: _backToLogin,
          child: const Text('Back to sign in'),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        TextButton(
          key: const ValueKey('resend-reset-link-button'),
          onPressed: _isSending ? null : _resend,
          child: const Text('Resend reset link'),
        ),
        TextButton(
          onPressed: () => setState(() => _linkSent = false),
          child: const Text('Use a different email'),
        ),
      ],
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSending = true);
    try {
      await widget.onSendResetLink?.call(_emailController.text.trim());
      if (mounted) setState(() => _linkSent = true);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _resend() async {
    setState(() => _isSending = true);
    try {
      await widget.onSendResetLink?.call(_emailController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Reset link resent.')));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _backToLogin() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.goNamed(AppRoute.login.name);
    }
  }
}
