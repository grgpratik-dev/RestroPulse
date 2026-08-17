import 'package:flutter/material.dart';

/// Shared label/value row for non-financial detail metadata.
class AppInfoRow extends StatelessWidget {
  const AppInfoRow({
    required this.label,
    required this.value,
    this.labelWidth = 104,
    super.key,
  });

  final String label;
  final String value;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.titleSmall),
        ),
      ],
    );
  }
}
