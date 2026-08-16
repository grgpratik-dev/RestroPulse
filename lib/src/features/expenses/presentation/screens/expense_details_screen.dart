import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_info_row.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/expense.dart';
import '../widgets/expense_category_icon.dart';

class ExpenseDetailsResult {
  const ExpenseDetailsResult.updated(this.expense) : deleted = false;
  const ExpenseDetailsResult.deleted() : expense = null, deleted = true;

  final Expense? expense;
  final bool deleted;
}

class ExpenseDetailsScreen extends StatefulWidget {
  const ExpenseDetailsScreen({required this.expense, super.key});

  final Expense expense;

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  late Expense _expense = widget.expense;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              Navigator.pop(context, ExpenseDetailsResult.updated(_expense)),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Expense Details'),
        actions: [
          TextButton(onPressed: _edit, child: const Text('Edit Expense')),
          const SizedBox(width: AppSpacing.spaceXs),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Center(
              child: Column(
                children: [
                  ExpenseCategoryIcon(category: _expense.category, size: 72),
                  const SizedBox(height: AppSpacing.spaceMd),
                  Text(
                    _expense.category,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Rs ${currency.format(_expense.amount)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _expense.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            CustomContainer(
              child: Column(
                children: [
                  AppInfoRow(
                    label: 'Date',
                    value: DateFormat('MMM d, yyyy').format(_expense.date),
                  ),
                  const Divider(height: 24),
                  AppInfoRow(label: 'Expense type', value: _expense.type.label),
                  if (_expense.notes?.isNotEmpty == true) ...[
                    const Divider(height: 24),
                    AppInfoRow(label: 'Notes', value: _expense.notes!),
                  ],
                ],
              ),
            ),
            if (_expense.receiptPath != null) ...[
              const SizedBox(height: AppSpacing.spaceMd),
              Text(
                'Receipt',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.spaceSm),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(_expense.receiptPath!),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.spaceXl),
            OutlinedButton.icon(
              onPressed: _confirmDelete,
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Delete Expense'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit() async {
    final updated = await context.pushNamed<Expense>(
      AppRoute.addExpense.name,
      extra: _expense,
    );
    if (!mounted || updated == null) return;
    setState(() => _expense = updated);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Expense updated')));
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.delete_outline_rounded,
          color: Theme.of(context).colorScheme.error,
        ),
        title: const Text('Delete expense?'),
        content: const Text(
          "This expense will be removed from your restaurant's spending data.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    Navigator.pop(context, const ExpenseDetailsResult.deleted());
  }
}
