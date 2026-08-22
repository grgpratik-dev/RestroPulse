import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/features/profile/presentation/widgets/help_and_support/issue_category_selector.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  static const _categories = [
    'Sales',
    'Expenses',
    'Menu',
    'Reports',
    'Restaurant Pulse',
    'Account',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _category;
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a Problem'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: _isSubmitted ? _buildSuccess(context) : _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.spaceMd,
          AppSpacing.spaceSm,
          AppSpacing.spaceMd,
          AppSpacing.space2xl,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.spaceMd),
            decoration: BoxDecoration(
              color: AppColors.splashAccent.withValues(alpha: 0.34),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppIcons.info_outline_rounded,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                Expanded(
                  child: Text(
                    'Tell us what went wrong. A clear description helps us understand the issue faster.',
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          IssueCategorySelector(
            value: _category,
            items: _categories,
            onChanged: (value) => setState(() => _category = value),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          TextFormField(
            key: const ValueKey('issue-subject-field'),
            controller: _subjectController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Subject',
              hintText: 'Briefly describe the issue',
              prefixIcon: SvgPicture.asset(AppIcons.short_text_rounded),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a short subject.';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          TextFormField(
            key: const ValueKey('issue-description-field'),
            controller: _descriptionController,
            minLines: 5,
            maxLines: 8,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText:
                  'Tell us what happened and what you expected to happen.',
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please describe what happened.';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          OutlinedButton.icon(
            onPressed: _showAttachmentPlaceholder,
            icon: SvgPicture.asset(AppIcons.attach_file_rounded),
            label: const Text('Attach Screenshot (Optional)'),
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          FilledButton(
            key: const ValueKey('submit-report-button'),
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : const Text('Submit Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spaceLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.splashAccent.withValues(alpha: 0.48),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppIcons.check_rounded,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
                width: 42,
                height: 42,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            Text(
              'Report submitted',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              "Thanks for letting us know. We'll review your issue as soon as possible.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceXl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to Help'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentPlaceholder() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Screenshot attachments will be available soon.'),
        ),
      );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await _sendMockReport();
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _isSubmitted = true;
      });
    } on Exception {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('We could not submit your report. Please try again.'),
        ),
      );
    }
  }

  Future<void> _sendMockReport() {
    return Future<void>.delayed(const Duration(milliseconds: 700));
  }
}
