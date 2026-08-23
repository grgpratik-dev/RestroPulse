import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/di/dependency_injection.dart';
import 'package:restropulse/src/app/router/app_router.dart';
import 'package:restropulse/src/app/session/app_session_controller.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:restropulse/src/features/onboarding/presentation/bloc/onboarding_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppSessionController _appSessionController;
  late final GoRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appSessionController = sl<AppSessionController>();

    _appRouter = createAppRouter(_appSessionController);

    Future.delayed(Duration(seconds: 2)).then((value) {
      _appSessionController.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<OnboardingBloc>()),
        BlocProvider(create: (_) => sl<AuthCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Project Setup',
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        routerConfig: _appRouter,
      ),
    );
  }
}
