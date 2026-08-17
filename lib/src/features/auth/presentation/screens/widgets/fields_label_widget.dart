import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
