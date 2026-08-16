import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_confirmation_dialog.dart';
import 'package:restropulse/src/core/widgets/app_divider.dart';
import 'package:restropulse/src/features/profile/presentation/widgets/members_access_widgets.dart';

class MembersAccessScreen extends StatefulWidget {
  const MembersAccessScreen({super.key});

  @override
  State<MembersAccessScreen> createState() => _MembersAccessScreenState();
}

class _MembersAccessScreenState extends State<MembersAccessScreen> {
  String? _joinCode = 'RP-7K9M2';
  int _codeVersion = 0;
  final List<_RestaurantMember> _members = [
    const _RestaurantMember(
      name: 'Pratik Gurung',
      email: 'pratik@boystoserve.com',
      role: 'Owner',
    ),
    const _RestaurantMember(
      name: 'Suman Gurung',
      email: 'suman@example.com',
      role: 'Viewer',
    ),
  ];
  final List<_AccessRequest> _pendingRequests = [
    const _AccessRequest(name: 'Nisha Thapa', email: 'nisha@example.com'),
  ];

  int get _viewerCount =>
      _members.where((member) => member.role == 'Viewer').length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Members & Access',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceSm,
            AppSpacing.spaceMd,
            AppSpacing.space2xl,
          ),
          children: [
            MembersSummaryCard(
              totalMembers: _members.length,
              viewerCount: _viewerCount,
            ),
            const SizedBox(height: AppSpacing.spaceXl),
            const _SectionTitle(
              title: 'Invite viewers',
              subtitle: 'One active code per restaurant',
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            RestaurantJoinCodeCard(
              code: _joinCode,
              onCopy: _copyCode,
              onRegenerate: _confirmRegenerateCode,
              onToggle: _toggleCode,
            ),
            const SizedBox(height: AppSpacing.spaceXl),
            _SectionTitle(
              title: 'Pending requests',
              trailing: '${_pendingRequests.length}',
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            if (_pendingRequests.isEmpty)
              const _EmptyRequests()
            else
              for (final request in _pendingRequests)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
                  child: PendingAccessRequestCard(
                    name: request.name,
                    email: request.email,
                    onApprove: () => _approveRequest(request),
                    onDecline: () => _declineRequest(request),
                  ),
                ),
            const SizedBox(height: AppSpacing.spaceLg),
            _SectionTitle(
              title: 'Restaurant members',
              trailing: '${_members.length}',
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.neutral300),
              ),
              child: Column(
                children: [
                  for (var index = 0; index < _members.length; index++) ...[
                    RestaurantMemberTile(
                      name: _members[index].name,
                      email: _members[index].email,
                      role: _members[index].role,
                      onRemove: _members[index].role == 'Viewer'
                          ? () => _removeMember(_members[index])
                          : null,
                    ),
                    if (index != _members.length - 1)
                      const AppDivider(height: 1, indent: 72),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyCode() async {
    final code = _joinCode;
    if (code == null) return;
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Join code copied')));
  }

  Future<void> _confirmRegenerateCode() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => const AppConfirmationDialog(
        title: 'Regenerate join code?',
        message:
            'The current code will stop working immediately. Existing pending requests will not be affected.',
        confirmLabel: 'Regenerate',
        icon: Icons.refresh_rounded,
        confirmButtonKey: ValueKey('confirm-regenerate-code-button'),
      ),
    );
    if (confirmed != true) return;

    const replacementCodes = ['RP-4N8Q6', 'RP-2M7X5', 'RP-9T3K8'];
    setState(() {
      _joinCode = replacementCodes[_codeVersion % replacementCodes.length];
      _codeVersion++;
    });
  }

  void _toggleCode() {
    setState(() => _joinCode = _joinCode == null ? 'RP-7K9M2' : null);
  }

  void _approveRequest(_AccessRequest request) {
    setState(() {
      _pendingRequests.remove(request);
      _members.add(
        _RestaurantMember(
          name: request.name,
          email: request.email,
          role: 'Viewer',
        ),
      );
    });
  }

  void _declineRequest(_AccessRequest request) {
    setState(() => _pendingRequests.remove(request));
  }

  void _removeMember(_RestaurantMember member) {
    setState(() => _members.remove(member));
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.space2xs),
                Text(
                  subtitle!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.neutral600),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(
              color: AppColors.neutral600,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.neutral300),
      ),
      child: const Text(
        'No pending access requests',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.neutral600),
      ),
    );
  }
}

class _RestaurantMember {
  const _RestaurantMember({
    required this.name,
    required this.email,
    required this.role,
  });

  final String name;
  final String email;
  final String role;
}

class _AccessRequest {
  const _AccessRequest({required this.name, required this.email});

  final String name;
  final String email;
}
