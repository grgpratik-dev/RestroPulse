import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restropulse/src/app/di/dependency_injection.dart';
import '../cubits/join_restaurant/join_restaurant_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_text_form_field.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/widgets/access_request_pending_view.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/widgets/restaurant_invitation_preview_card.dart';

class JoinRestaurantScreen extends StatelessWidget {
  const JoinRestaurantScreen({this.onJoined, super.key});

  final VoidCallback? onJoined;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<JoinRestaurantCubit>(),
    child: _JoinRestaurantForm(onJoined: onJoined),
  );
}

class _JoinRestaurantForm extends StatefulWidget {
  const _JoinRestaurantForm({this.onJoined});
  final VoidCallback? onJoined;
  @override
  State<_JoinRestaurantForm> createState() => _JoinRestaurantScreenState();
}

class _JoinRestaurantScreenState extends State<_JoinRestaurantForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<JoinRestaurantCubit, JoinRestaurantState>(
      listenWhen: (previous, current) =>
          !previous.requestSent && current.requestSent,
      listener: (context, state) => widget.onJoined?.call(),
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.authBackground,
        appBar: AppBar(),
        body: SafeArea(
          top: false,
          child: state.requestSent
              ? AccessRequestPendingView(onRefresh: widget.onJoined)
              : ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.spaceLg,
                    AppSpacing.spaceMd,
                    AppSpacing.spaceLg,
                    AppSpacing.space2xl,
                  ),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.spaceSm,
                                  vertical: AppSpacing.spaceXs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.infoSurface,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.full,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.visibility_outlined,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.info,
                                        BlendMode.srcIn,
                                      ),
                                      width: 18,
                                      height: 18,
                                    ),
                                    const SizedBox(width: AppSpacing.spaceXs),
                                    const Text(
                                      'Viewer access',
                                      style: TextStyle(
                                        color: AppColors.info,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceMd),
                            Text(
                              'Join a restaurant',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceXs),
                            Text(
                              'Enter the invitation code shared by the restaurant owner.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.neutral700,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceLg),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.spaceMd),
                              decoration: BoxDecoration(
                                color: AppColors.infoSurface.withValues(
                                  alpha: 0.68,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.lock_outline_rounded,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.info,
                                      BlendMode.srcIn,
                                    ),
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: AppSpacing.spaceSm),
                                  Expanded(
                                    child: Text(
                                      'Joining as a viewer gives you read-only access. Restaurant owners control invitations and permissions.',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: AppColors.infoForeground,
                                            height: 1.45,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceLg),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Invitation code',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: AppColors.ink,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.spaceXs),
                                  AppTextFormField(
                                    key: const ValueKey(
                                      'invitation-code-field',
                                    ),
                                    controller: _codeController,
                                    enabled: !state.loading,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    textInputAction: TextInputAction.done,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[a-zA-Z0-9-]'),
                                      ),
                                    ],
                                    onChanged: context
                                        .read<JoinRestaurantCubit>()
                                        .codeChanged,
                                    onFieldSubmitted: (_) => _findRestaurant(),
                                    prefixIcon: SvgPicture.asset(
                                      AppIcons.vpn_key_outlined,
                                      width: 22,
                                      height: 22,
                                    ),
                                    suffixIcon: IconButton(
                                      tooltip: 'Paste invitation code',
                                      onPressed: state.loading
                                          ? null
                                          : _pasteCode,
                                      icon: SvgPicture.asset(
                                        AppIcons.content_paste_rounded,
                                        width: 22,
                                        height: 22,
                                      ),
                                    ),
                                    validator: (value) {
                                      final code = value?.trim() ?? '';
                                      if (code.isEmpty) {
                                        return 'Enter your invitation code';
                                      }
                                      if (code.length < 6) {
                                        return 'Check the invitation code and try again';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: AppSpacing.spaceMd),
                                  SizedBox(
                                    height: 52,
                                    child: OutlinedButton(
                                      key: const ValueKey(
                                        'find-restaurant-button',
                                      ),
                                      onPressed: state.loading
                                          ? null
                                          : _findRestaurant,
                                      child: Text(
                                        state.loading
                                            ? 'Please wait…'
                                            : 'Find restaurant',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceXs),
                            Text(
                              'Ask the restaurant owner to send you an invitation if you do not have a code.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.neutral600,
                                height: 1.4,
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: state.invitation != null
                                  ? Padding(
                                      key: const ValueKey('invitation-found'),
                                      padding: const EdgeInsets.only(
                                        top: AppSpacing.spaceLg,
                                      ),
                                      child: RestaurantInvitationPreviewCard(
                                        restaurantName: state.invitation!.name,
                                        address: state.invitation!.address,
                                        onRequest: state.loading
                                            ? null
                                            : context
                                                  .read<JoinRestaurantCubit>()
                                                  .request,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            if (state.message != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: AppSpacing.spaceMd,
                                ),
                                child: Text(
                                  state.message!,
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _findRestaurant() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final cubit = context.read<JoinRestaurantCubit>();
    if (cubit.state.loading) return;
    cubit.codeChanged(_codeController.text);
    cubit.lookup();
  }

  Future<void> _pasteCode() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final code = clipboardData?.text?.trim();
    if (!mounted || code == null || code.isEmpty) return;
    final cubit = context.read<JoinRestaurantCubit>();
    if (cubit.state.loading) return;
    _codeController.text = code.toUpperCase();
    cubit.codeChanged(code);
  }
}
