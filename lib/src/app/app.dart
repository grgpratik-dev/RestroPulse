import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restropulse/src/app/di/dependency_injection.dart';
import 'package:restropulse/src/app/router/app_router.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:restropulse/src/features/onboarding/presentation/screens/onboarding_screen.dart';

import 'bloc/app_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AppBloc stays alive for the whole app and receives session changes.
        BlocProvider(create: (_) => sl<AppBloc>()..add(const AppStarted())),
        BlocProvider(
          create: (_) => sl.get<OnboardingBloc>(),
          child: OnboardingScreen(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Project Setup',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.goRouter,
      ),
    );
  }
}
