import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outlined, text, destructive }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;

  final AppButtonVariant variant;
  final AppButtonSize size;

  final bool isLoading;
  final bool isFullWidth;

  final Widget? leadingIcon;
  final Widget? trailingIcon;

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: _isDisabled ? null : onPressed,
        style: _buttonStyle(context),
        child: _content(context),
      ),

      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: _isDisabled ? null : onPressed,
        style: _buttonStyle(context),
        child: _content(context),
      ),

      AppButtonVariant.outlined => OutlinedButton(
        onPressed: _isDisabled ? null : onPressed,
        style: _buttonStyle(context),
        child: _content(context),
      ),

      AppButtonVariant.text => TextButton(
        onPressed: _isDisabled ? null : onPressed,
        style: _buttonStyle(context),
        child: _content(context),
      ),

      AppButtonVariant.destructive => FilledButton(
        onPressed: _isDisabled ? null : onPressed,
        style: _destructiveStyle(context),
        child: _content(context),
      ),
    };

    if (!isFullWidth) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }

  Widget _content(BuildContext context) {
    if (isLoading) {
      return SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _loadingIndicatorColor(context),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: 8)],
        Flexible(child: Text(label, textAlign: TextAlign.center)),
        if (trailingIcon != null) ...[const SizedBox(width: 8), trailingIcon!],
      ],
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return switch (size) {
      AppButtonSize.small => const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(0, 36)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),

      AppButtonSize.medium => const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(0, 44)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      AppButtonSize.large => const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(0, 52)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    };
  }

  ButtonStyle _destructiveStyle(BuildContext context) {
    return _buttonStyle(context).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Theme.of(context).colorScheme.errorContainer;
        }

        return Theme.of(context).colorScheme.error;
      }),
      foregroundColor: WidgetStatePropertyAll(
        Theme.of(context).colorScheme.onError,
      ),
    );
  }

  Color _loadingIndicatorColor(BuildContext context) {
    return switch (variant) {
      AppButtonVariant.primary => Theme.of(context).colorScheme.onPrimary,

      AppButtonVariant.secondary => Theme.of(
        context,
      ).colorScheme.onSecondaryContainer,

      AppButtonVariant.outlined => Theme.of(context).colorScheme.primary,

      AppButtonVariant.text => Theme.of(context).colorScheme.primary,

      AppButtonVariant.destructive => Theme.of(context).colorScheme.onError,
    };
  }
}
