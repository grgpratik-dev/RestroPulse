import 'package:restropulse/bootstrap.dart';
import 'package:restropulse/src/app/app.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
