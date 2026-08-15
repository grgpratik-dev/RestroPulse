/// Routes available in the application.
///
/// The enum value's [name] is used as the GoRouter route name, while [path]
/// defines its URL location.
enum AppRoute {
  onboarding('/onboarding'),
  splash('/splash'),
  login('/login'),
  register('/register'),
  main('/main'),
  screen1('/screen1'),
  screen2('/screen2'),
  screen3('/screen3'),
  dashboard('/dashboard'),
  profile('/profile'),
  expenses('/expenses'),
  menu('/menu'),
  reports('/reports'),
  sales('/sales');

  const AppRoute(this.path);

  final String path;
}
