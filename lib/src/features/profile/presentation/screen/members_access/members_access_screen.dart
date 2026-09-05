import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restropulse/src/app/di/dependency_injection.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_confirmation_dialog.dart';
import 'package:restropulse/src/features/profile/presentation/widgets/members_access_widgets.dart';
import '../../cubits/members_access/members_access_cubit.dart';

class MembersAccessScreen extends StatelessWidget {
  const MembersAccessScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<MembersAccessCubit>()..load(),
    child: const _MembersAccessView(),
  );
}

class _MembersAccessView extends StatelessWidget {
  const _MembersAccessView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembersAccessCubit, MembersAccessState>(
      builder: (context, state) {
        final cubit = context.read<MembersAccessCubit>();
        final data = state.data;
        final busy = state.loading || state.saving;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Members & Access'),
            actions: [
              IconButton(
                tooltip: 'Refresh members and requests',
                onPressed: busy ? null : cubit.load,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: cubit.load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.spaceMd),
                children: [
                  if (busy) const LinearProgressIndicator(),
                  if (state.message != null) ...[
                    Text(
                      state.message!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    TextButton(
                      onPressed: busy ? null : cubit.load,
                      child: const Text('Retry'),
                    ),
                  ],
                  if (data != null) ...[
                    MembersSummaryCard(
                      restaurantName: data.restaurantName,
                      totalMembers: data.members.length,
                      viewerCount: data.members
                          .where((member) => member.role == 'viewer')
                          .length,
                    ),
                    if (data.isOwner) ...[
                      const _SectionTitle('Invite viewers'),
                      RestaurantJoinCodeCard(
                        code: data.joinCode,
                        onCopy: busy || data.joinCode == null
                            ? null
                            : () => _copyCode(context, data.joinCode!),
                        onRegenerate: busy
                            ? null
                            : () => _confirm(
                                context,
                                title: 'Regenerate join code?',
                                message:
                                    'The current code will stop working immediately. Existing pending requests will not be affected.',
                                label: 'Regenerate',
                                action: cubit.generateCode,
                              ),
                        onToggle: busy
                            ? null
                            : () {
                                if (data.joinCode == null) {
                                  cubit.generateCode();
                                } else {
                                  _confirm(
                                    context,
                                    title: 'Disable join code?',
                                    message:
                                        'New viewers will not be able to request access with this code. Pending requests will remain.',
                                    label: 'Disable',
                                    action: cubit.disableCode,
                                  );
                                }
                              },
                      ),
                      _SectionTitle(
                        'Pending requests (${data.requests.length})',
                      ),
                      if (data.requests.isEmpty)
                        const Text('No pending access requests'),
                      for (final request in data.requests)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.spaceSm,
                          ),
                          child: PendingAccessRequestCard(
                            key: ValueKey(request.id),
                            name: request.name,
                            email: request.email ?? 'Requesting viewer access',
                            onApprove: busy
                                ? null
                                : () => cubit.approve(request.id),
                            onDecline: busy
                                ? null
                                : () => _confirm(
                                    context,
                                    title: 'Decline request?',
                                    message:
                                        'Decline the access request from ${request.name}?',
                                    label: 'Decline',
                                    action: () => cubit.decline(request.id),
                                  ),
                          ),
                        ),
                    ],
                    _SectionTitle(
                      'Restaurant members (${data.members.length})',
                    ),
                    for (final member in data.members)
                      RestaurantMemberTile(
                        key: ValueKey(member.id),
                        name: member.name,
                        email:
                            member.email ??
                            (member.role == 'owner'
                                ? 'Manages restaurant access'
                                : 'Read-only access'),
                        role: member.role == 'owner' ? 'Owner' : 'Viewer',
                        onRemove:
                            !busy && data.isOwner && member.role == 'viewer'
                            ? () => _confirm(
                                context,
                                title: 'Remove viewer access?',
                                message:
                                    '${member.name} will lose access to this restaurant.',
                                label: 'Remove',
                                destructive: true,
                                action: () => cubit.removeViewer(member.id),
                              )
                            : null,
                      ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _copyCode(BuildContext context, String code) async {
    try {
      await Clipboard.setData(ClipboardData(text: code));
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Join code copied')));
    } on PlatformException {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not copy the code. Please try again.'),
        ),
      );
    }
  }

  Future<void> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String label,
    required Future<void> Function() action,
    bool destructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AppConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: label,
        isDestructive: destructive,
        confirmButtonKey: const ValueKey('confirm-access-action'),
      ),
    );
    if (confirmed == true && context.mounted) await action();
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: AppSpacing.spaceXl,
      bottom: AppSpacing.spaceSm,
    ),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}
