import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_spacing.dart';

enum AppTextFieldInputType { text, name, number, decimal, phone, search }

enum AppTextFieldVariant { outlined, borderless }

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.scrollController,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.inputType = AppTextFieldInputType.text,
    this.variant = AppTextFieldVariant.outlined,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : assert(
         controller == null || initialValue == null,
         'controller and initialValue cannot both be provided.',
       );

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ScrollController? scrollController;

  final String? labelText;
  final String? hintText;
  final String? initialValue;

  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? style;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;

  final AppTextFieldInputType inputType;
  final AppTextFieldVariant variant;

  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autofocus;
  final bool enableSuggestions;
  final bool autocorrect;

  final int maxLines;
  final int? minLines;
  final int? maxLength;

  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final resolvedKeyboardType = keyboardType ?? _keyboardTypeFor(inputType);

    final resolvedInputFormatters =
        inputFormatters ?? _inputFormattersFor(inputType);

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      scrollController: scrollController,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      autofocus: autofocus,
      enableSuggestions: obscureText ? false : enableSuggestions,
      autocorrect: obscureText ? false : autocorrect,
      keyboardType: resolvedKeyboardType,
      textInputAction: textInputAction,
      inputFormatters: resolvedInputFormatters,
      autofillHints: autofillHints,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      maxLength: maxLength,
      style: style,
      textAlign: textAlign,
      textCapitalization: textCapitalization,
      autovalidateMode: autovalidateMode,
      decoration: _getDecoration(),
    );
  }

  InputDecoration _getDecoration() {
    final decoration = InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Container(
        padding: EdgeInsets.all(AppSpacing.spaceSm),
        child: prefixIcon,
      ),
      suffixIcon: suffixIcon == null
          ? null
          : Container(
              padding: EdgeInsets.all(AppSpacing.spaceSm),
              child: suffixIcon,
            ),
    );

    return switch (variant) {
      AppTextFieldVariant.outlined => decoration,
      AppTextFieldVariant.borderless => decoration.copyWith(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    };
  }

  TextInputType _keyboardTypeFor(AppTextFieldInputType inputType) {
    return switch (inputType) {
      AppTextFieldInputType.text => TextInputType.text,
      AppTextFieldInputType.name => TextInputType.name,
      AppTextFieldInputType.number => TextInputType.number,
      AppTextFieldInputType.decimal => const TextInputType.numberWithOptions(
        decimal: true,
      ),
      AppTextFieldInputType.phone => TextInputType.phone,
      AppTextFieldInputType.search => TextInputType.text,
    };
  }

  List<TextInputFormatter>? _inputFormattersFor(
    AppTextFieldInputType inputType,
  ) {
    return switch (inputType) {
      AppTextFieldInputType.text => null,

      AppTextFieldInputType.name => [
        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'-]")),
      ],

      AppTextFieldInputType.number => [FilteringTextInputFormatter.digitsOnly],

      AppTextFieldInputType.decimal => [_DecimalTextInputFormatter()],

      AppTextFieldInputType.phone => [FilteringTextInputFormatter.digitsOnly],

      AppTextFieldInputType.search => null,
    };
  }
}

class _DecimalTextInputFormatter extends TextInputFormatter {
  const _DecimalTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final decimalPattern = RegExp(r'^\d*\.?\d*$');

    return decimalPattern.hasMatch(newValue.text) ? newValue : oldValue;
  }
}
