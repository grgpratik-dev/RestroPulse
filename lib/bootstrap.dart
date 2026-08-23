import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app/di/dependency_injection.dart';

/// Performs startup work before the root widget is mounted.
///
///
bool isForDevelopment = true;

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env[isForDevelopment ? 'SUPABASE_DEV_URL' : 'SUPABASE_URL']!,
    publishableKey:
        dotenv.env[isForDevelopment
            ? 'SUPABASE_DEV_PUBLISHABLE_KEY'
            : 'SUPABASE_PUBLISHABLE_KEY']!,
    debug: kDebugMode,
  );

  initGetIt();

  final app = await builder();

  runApp(app);
}
