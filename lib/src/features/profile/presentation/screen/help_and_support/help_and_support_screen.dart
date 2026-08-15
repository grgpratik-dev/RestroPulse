import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/features/profile/presentation/widgets/help_and_support/faq_tile.dart';
import 'package:restropulse/src/features/profile/presentation/widgets/help_and_support/support_action_card.dart';

import 'report_problem_screen.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  String? _expandedQuestion;

  static const _faqs = [
    _Faq(
      question: 'What is the main goal of RestroPulse?',
      answer:
          'RestroPulse helps restaurant owners answer one important question: How healthy is my restaurant business, and what should I improve next?\n\nIt brings together sales, expenses, profit, food cost, wastage, menu performance, and business trends so you can understand what is actually happening in your restaurant.',
    ),
    _Faq(
      question: 'What does Restaurant Pulse actually tell me?',
      answer:
          'Restaurant Pulse gives you a quick summary of your restaurant’s overall business health.\n\nIt considers important indicators such as:\n\n• sales trends\n• profitability\n• food cost\n• wastage\n• order performance\n\nThe goal is to help you quickly understand whether your restaurant is performing well or whether certain areas need attention.',
    ),
    _Faq(
      question:
          'Why isn’t revenue alone enough to know if my restaurant is doing well?',
      answer:
          'High revenue does not always mean high profit.\n\nYour restaurant may be making more sales while also spending more on:\n\n• ingredients\n• salaries\n• utilities\n• packaging\n• discounts\n• wastage\n• delivery costs\n\nRestroPulse helps you look beyond revenue and understand how much money the restaurant is actually keeping.',
    ),
    _Faq(
      question: 'How can RestroPulse help me increase profit?',
      answer:
          'RestroPulse helps identify where money is being earned and where it may be getting lost.\n\nFor example, it can help you notice:\n\n• rising expenses\n• increasing food cost\n• excessive wastage\n• low-margin menu items\n• falling average order value\n• declining orders\n• strong-selling items that should be promoted more\n\nThe app provides information that can help you decide what areas of the business deserve attention.',
    ),
    _Faq(
      question:
          'How do I know which menu items are actually good for my business?',
      answer:
          'A popular menu item is not always a profitable menu item.\n\nRestroPulse compares information such as:\n\n• quantity sold\n• selling price\n• estimated food cost\n• revenue generated\n• estimated contribution or margin\n\nThis can help you identify items that:\n\n• sell well and generate good profit\n• sell well but have weak margins\n• are profitable but not selling enough\n• have both weak sales and weak margins\n\nThis makes it easier to make better decisions about pricing, promotion, portion size, and menu changes.',
    ),
    _Faq(
      question: 'Why should I track food cost?',
      answer:
          'Food cost directly affects restaurant profitability.\n\nEven if sales remain strong, increasing ingredient prices, larger portions, poor purchasing decisions, or wastage can reduce profit.\n\nTracking food cost helps you understand how much of your sales revenue is being spent on producing the food you sell.',
    ),
    _Faq(
      question: 'Why should I record wastage?',
      answer:
          'Wastage represents money spent without generating customer revenue.\n\nTracking wastage can help identify repeated problems such as:\n\n• overproduction\n• expired ingredients\n• preparation mistakes\n• damaged food\n• customer returns\n• unnecessary staff consumption\n\nOver time, even small daily losses can become a significant monthly expense.',
    ),
    _Faq(
      question: 'What does average order value tell me?',
      answer:
          'Average order value shows how much customers spend on average each time an order is placed.\n\nIt is calculated as:\n\nTotal Revenue ÷ Number of Orders\n\nFor example, if customer traffic remains the same but average order value increases, your restaurant may still increase revenue through:\n\n• better menu combinations\n• add-ons\n• drinks\n• sides\n• desserts\n• pricing improvements',
    ),
    _Faq(
      question: 'Why should I compare this month with last month?',
      answer:
          'A single number does not always tell you whether the restaurant is improving.\n\nPeriod comparisons help show direction.\n\nRestroPulse can help you compare metrics such as:\n\n• revenue\n• orders\n• average order value\n• expenses\n• food cost\n• wastage\n• profit\n\nThis helps you understand whether performance is improving, declining, or remaining stable.',
    ),
    _Faq(
      question:
          'What should I look at if sales are increasing but profit is falling?',
      answer:
          'If sales are increasing but profit is decreasing, you should examine the costs behind those sales.\n\nImportant areas to review include:\n\n• food cost\n• operating expenses\n• discounts\n• wastage\n• delivery commissions\n• menu item margins\n\nRestroPulse is designed to highlight situations where revenue appears healthy while profitability is becoming weaker.',
    ),
    _Faq(
      question: 'How can I know what needs attention first?',
      answer:
          'RestroPulse combines your restaurant’s most important performance metrics so that you can identify areas that may require attention.\n\nExamples include:\n\n• rapidly increasing food cost\n• falling order volume\n• rising expenses\n• increasing wastage\n• declining profit margin\n• weak-performing menu items\n\nInstead of looking at individual numbers in isolation, the app helps you understand how different parts of the restaurant are affecting overall performance.',
    ),
    _Faq(
      question: 'Does RestroPulse replace my POS system?',
      answer:
          'No.\n\nA POS system mainly focuses on operations such as:\n\n• billing\n• transactions\n• customer orders\n• payment processing\n\nRestroPulse focuses on business performance and analytics.\n\nIts purpose is to help you understand sales, costs, profit, menu performance, wastage, and business trends.',
    ),
    _Faq(
      question: 'Does RestroPulse replace accounting software?',
      answer:
          'No.\n\nRestroPulse is a restaurant performance and decision-support tool.\n\nIt can help you estimate profitability and understand operational performance, but it should not replace professional accounting, taxation, or financial reporting software.',
    ),
    _Faq(
      question: 'How much data do I need before RestroPulse becomes useful?',
      answer:
          'You can start seeing useful daily information as soon as you begin recording data.\n\nHowever, the app becomes more valuable as consistent data builds up.\n\nFor example:\n\n• daily data helps understand current performance\n• weekly data helps identify short-term trends\n• monthly data provides stronger comparisons and business insights\n\nThe more consistently the restaurant records information, the more meaningful the analytics become.',
    ),
    _Faq(
      question: 'Do I need to enter every customer order individually?',
      answer:
          'No.\n\nRestroPulse is designed to remain lightweight and practical for restaurant owners.\n\nFor the initial version, you can record daily totals such as:\n\n• total revenue\n• number of orders\n• dine-in sales\n• takeaway sales\n• delivery sales\n• menu item quantities sold\n\nYou do not need to recreate every individual customer transaction manually.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceSm,
            AppSpacing.spaceMd,
            AppSpacing.space2xl,
          ),
          children: [
            const _HelpHeader(),
            const SizedBox(height: AppSpacing.spaceXl),
            const _SectionTitle(title: 'Frequently Asked Questions'),
            const SizedBox(height: AppSpacing.spaceSm),
            for (final faq in _faqs) ...[
              FaqTile(
                question: faq.question,
                answer: faq.answer,
                isExpanded: _expandedQuestion == faq.question,
                onTap: () => setState(() {
                  _expandedQuestion = _expandedQuestion == faq.question
                      ? null
                      : faq.question;
                }),
              ),
              const SizedBox(height: AppSpacing.spaceSm),
            ],
            const SizedBox(height: AppSpacing.spaceLg),
            SupportActionCard(
              onEmailSupport: _showEmailPlaceholder,
              onReportProblem: _openReportForm,
            ),
            const SizedBox(height: AppSpacing.spaceXl),
            Text(
              'RestroPulse v1.0.0',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.space2xs),
            Text(
              'Restaurant performance made clearer.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmailPlaceholder() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Email support will be available soon.')),
      );
  }

  Future<void> _openReportForm() {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const ReportProblemScreen()),
    );
  }
}

class _HelpHeader extends StatelessWidget {
  const _HelpHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      excludeSemantics: true,
      label:
          'How can we help? Find answers, learn how RestroPulse works, or contact support.',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spaceMd),
        decoration: BoxDecoration(
          color: AppColors.splashAccent.withValues(alpha: 0.38),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: AppSpacing.spaceSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How can we help?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space2xs),
                  Text(
                    'Find answers, learn how RestroPulse works, or contact support.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _Faq {
  const _Faq({required this.question, required this.answer});

  final String question;
  final String answer;
}
