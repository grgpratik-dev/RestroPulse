import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_dialogs.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:restropulse/src/features/auth/presentation/screens/widgets/ambient_glow_widget.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  static const _codeLength = 6;

  final _codeController = TextEditingController();
  final _codeFocusNode = FocusNode();

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.verifyingOtp) {
          AppDialogs.fullLoadingDialog(context: context);
        }
        if (state.status == AuthStatus.otpVerificationFailure) {
          context.pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Could not verify the code.'),
              ),
            );
        }
        if (state.status == AuthStatus.otpVerified) {
          // context.pop();
          // context.goNamed(AppRoute.dashboard.name);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.authBackground,
        body: Stack(
          children: [
            const Positioned(
              top: -120,
              right: -90,
              child: AmbientGlow(size: 300, opacity: 0.8),
            ),
            const Positioned(
              bottom: -170,
              left: -140,
              child: AmbientGlow(size: 360, opacity: 0.5),
            ),
            SafeArea(
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final minimumContentHeight =
                          (constraints.maxHeight -
                                  AppSpacing.space4xl -
                                  AppSpacing.spaceLg)
                              .clamp(0.0, double.infinity)
                              .toDouble();

                      return SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.spaceLg,
                          AppSpacing.space4xl,
                          AppSpacing.spaceLg,
                          AppSpacing.spaceLg,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: minimumContentHeight,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 460),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const _VerificationIcon(),
                                  const SizedBox(height: AppSpacing.spaceLg),
                                  Text(
                                    'Check your inbox',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.headlineLarge,
                                  ),
                                  const SizedBox(height: AppSpacing.spaceXs),
                                  Text(
                                    'Enter the 6-digit verification code we sent to',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.neutral600,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.spaceSm),
                                  Center(
                                    child:
                                        BlocSelector<
                                          AuthCubit,
                                          AuthState,
                                          String?
                                        >(
                                          selector: (state) {
                                            return state.email;
                                          },
                                          builder: (context, state) {
                                            return _EmailChip(
                                              email: state ?? '',
                                            );
                                          },
                                        ),
                                  ),
                                  const SizedBox(height: AppSpacing.spaceXl),
                                  Text(
                                    'Verification code',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: AppColors.neutral800,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.spaceSm),
                                  _OtpCodeField(
                                    controller: _codeController,
                                    focusNode: _codeFocusNode,
                                    codeLength: _codeLength,
                                    onChanged: (_) => setState(() {}),
                                  ),
                                  const SizedBox(height: AppSpacing.spaceLg),
                                  SizedBox(
                                    key: const ValueKey(
                                      'verify-otp-submit-button',
                                    ),
                                    height: 54,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        context.read<AuthCubit>().verifyOtp(
                                          email:
                                              context
                                                  .read<AuthCubit>()
                                                  .state
                                                  .email ??
                                              '',
                                          token: _codeController.text,
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('Verify and continue'),
                                          const SizedBox(
                                            width: AppSpacing.spaceXs,
                                          ),
                                          SvgPicture.asset(
                                            AppIcons.arrow_forward_rounded,
                                            width: 18,
                                            height: 18,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.spaceMd),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Didn’t receive the code?',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: AppColors.neutral600,
                                            ),
                                      ),
                                      TextButton(
                                        key: const ValueKey(
                                          'verify-otp-resend-button',
                                        ),
                                        onPressed: () {},
                                        child: const Text('Resend'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.spaceLg),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 16,

                    left: 16,
                    child: _BackButton(
                      onPressed: () {
                        context.pop();
                      },
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

class _OtpCodeField extends StatelessWidget {
  const _OtpCodeField({
    required this.controller,
    required this.focusNode,
    required this.codeLength,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int codeLength;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final code = controller.text;
    final activeIndex = code.length.clamp(0, codeLength - 1);

    return Semantics(
      label: 'Six digit verification code',
      textField: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: focusNode.requestFocus,
        child: SizedBox(
          key: const ValueKey('verify-otp-code-field'),
          height: 58,
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.01,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(codeLength),
                    ],
                    onChanged: onChanged,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                child: Row(
                  children: List.generate(codeLength, (index) {
                    final hasDigit = index < code.length;
                    final isActive = index == activeIndex;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index == codeLength - 1
                              ? 0
                              : AppSpacing.spaceXs,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: hasDigit
                                ? AppColors.mintSurface
                                : AppColors.neutral50,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.primary
                                  : hasDigit
                                  ? AppColors.mintBright
                                  : AppColors.neutral300,
                              width: isActive ? 2 : 1,
                            ),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 140),
                            child: hasDigit
                                ? Text(
                                    code[index],
                                    key: ValueKey(code[index]),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerificationIcon extends StatelessWidget {
  const _VerificationIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 72,
        height: 72,
        padding: const EdgeInsets.all(AppSpacing.spaceMd),
        decoration: BoxDecoration(
          color: AppColors.kNeutral100,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SvgPicture.asset(
          AppIcons.mark_email_read_outlined,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class _EmailChip extends StatelessWidget {
  const _EmailChip({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceSm,
        vertical: AppSpacing.spaceXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.mintSurface,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.mintSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppIcons.email_outlined,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppSpacing.spaceXs),
          Flexible(
            child: Text(
              email,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        side: const BorderSide(color: AppColors.mintSoft),
      ),
      icon: SvgPicture.asset(
        AppIcons.arrow_back_rounded,
        width: 32,
        height: 32,
        colorFilter: const ColorFilter.mode(
          AppColors.neutral800,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
