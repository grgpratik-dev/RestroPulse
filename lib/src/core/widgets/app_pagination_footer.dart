import 'package:flutter/material.dart';

class AppPaginationFooter extends StatelessWidget {
  const AppPaginationFooter({
    super.key,
    required this.isLoading,
    required this.hasReachedEnd,
    this.endMessage,
  });

  final bool isLoading;
  final bool hasReachedEnd;
  final String? endMessage;

  @override
  Widget build(BuildContext context) {
    if (hasReachedEnd) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            endMessage ?? 'You have reached the end.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
