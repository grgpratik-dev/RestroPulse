import 'package:flutter/material.dart';
import 'package:restropulse/src/core/widgets/app_confirmation_dialog.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({
    required this.onCancel,
    required this.onConfirm,
    super.key,
  });

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AppConfirmationDialog(
      key: const ValueKey('logout-confirmation-dialog'),
      title: 'Log out of RestroPulse?',
      message:
          'You’ll need to sign in again to access your restaurant dashboard and reports.',
      confirmLabel: 'Log Out',
      icon: AppIcons.logout_rounded,
      isDestructive: true,
      onCancel: onCancel,
      onConfirm: onConfirm,
    );
  }
}
