part of '../screen/profile_screen.dart';

class _MembersAccessSettingsTile extends StatelessWidget {
  const _MembersAccessSettingsTile();

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<MembersAccessCubit, MembersAccessState>(
    builder: (context, state) {
      final data = state.data;
      final String subtitle;
      if (state.loading) {
        subtitle = 'Loading members…';
      } else if (state.message != null || data == null) {
        subtitle = 'Counts unavailable · Tap to view access';
      } else {
        final members = data.members.length;
        final requests = data.requests.length;
        final memberLabel = '$members ${members == 1 ? 'member' : 'members'}';
        subtitle = data.isOwner
            ? '$memberLabel · $requests pending ${requests == 1 ? 'request' : 'requests'}'
            : memberLabel;
      }
      return SettingsTile(
        icon: AppIcons.group_outlined,
        title: 'Members & Access',
        subtitle: subtitle,
        onTap: () async {
          final cubit = context.read<MembersAccessCubit>();
          await context.pushNamed(AppRoute.membersAccess.name);
          if (!context.mounted) return;
          await cubit.load();
        },
      );
    },
  );
}
