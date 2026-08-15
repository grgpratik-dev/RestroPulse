import 'dart:async';

import 'package:flutter/widgets.dart';

import 'src/app/di/dependency_injection.dart';

/// Performs startup work before the root widget is mounted.
///
/// Firebase initialization can be added here later without coupling it to the
/// independent REST network service.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  initGetIt();

  final app = await builder();

  runApp(app);
}
