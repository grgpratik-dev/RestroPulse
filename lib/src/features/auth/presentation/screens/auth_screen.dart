import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/gen/assets.gen.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_dialogs.dart';
import 'package:restropulse/src/core/widgets/app_divider.dart';
import 'package:restropulse/src/core/widgets/app_footer.dart';
import 'package:restropulse/src/core/widgets/app_text_form_field.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:restropulse/src/features/auth/presentation/screens/widgets/brand_header.dart';
import 'package:restropulse/src/features/auth/presentation/screens/widgets/fields_label_widget.dart';

part 'widgets/section_divider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.requestingOtp) {
          AppDialogs.fullLoadingDialog(context: context);
        }
        if (state.status == AuthStatus.otpRequestFailure) {
          context.pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Could not send the code.'),
              ),
            );
        }
        if (state.status == AuthStatus.otpSent) {
          context.pop();
          final email = state.email;
          if (email != null) {
            context.pushNamed(AppRoute.verifyOTP.name, extra: email);
          }
        }
        if (state.status == AuthStatus.googleSignInFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.message ?? 'Could not sign in with Google.',
                ),
              ),
            );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minimumContentHeight =
                  (constraints.maxHeight - (AppSpacing.spaceLg * 2))
                      .clamp(0.0, double.infinity)
                      .toDouble();

              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(AppSpacing.spaceLg),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minimumContentHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: AutofillGroup(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BrandHeader(),
                            const SizedBox(height: AppSpacing.space2xl),
                            Text(
                              'Welcome 👋',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall,
                            ),
                            const SizedBox(height: AppSpacing.spaceXs),
                            Text(
                              'Get started and track your restaurant\'s health.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.spaceXl),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const FieldLabel('Email'),
                                const SizedBox(height: AppSpacing.spaceXs),
                                AppTextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.email],
                                  autocorrect: false,
                                  hintText: "Email address",
                                  prefixIcon: SvgPicture.asset(
                                    AppIcons.email_outlined,
                                    width: 10,
                                    height: 10,
                                  ),
                                ),

                                const SizedBox(height: AppSpacing.spaceLg),
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<AuthCubit>().requestOtp(
                                        _emailController.text.trim(),
                                      );
                                    },
                                    child: Text('Continue with Email'),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.spaceLg),
                                const SectionDivider(),
                                const SizedBox(height: AppSpacing.spaceLg),
                                BlocSelector<AuthCubit, AuthState, bool>(
                                  selector: (state) =>
                                      state.status ==
                                      AuthStatus.googleSignInInProgress,
                                  builder: (context, isLoading) {
                                    return SizedBox(
                                      height: 52,
                                      child: OutlinedButton(
                                        onPressed: isLoading
                                            ? null
                                            : () => context
                                                  .read<AuthCubit>()
                                                  .signInWithGoogle(),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (isLoading)
                                              const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            else
                                              Container(
                                                width: 28,
                                                height: 28,
                                                padding: const EdgeInsets.all(
                                                  3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        999,
                                                      ),
                                                ),
                                                child: Image.asset(
                                                  Assets.images.googleLogo.path,
                                                  fit: BoxFit.contain,
                                                  filterQuality:
                                                      FilterQuality.high,
                                                ),
                                              ),
                                            const SizedBox(
                                              width: AppSpacing.spaceSm,
                                            ),
                                            Flexible(
                                              child: Text(
                                                isLoading
                                                    ? 'Connecting...'
                                                    : 'Continue with Google',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.space3xl),
                            Center(child: AppFooter()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
