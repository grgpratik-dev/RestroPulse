/// Settings used when the app connects to Firebase.
///
/// Firebase project credentials will later come from the generated
/// `firebase_options.dart` file.
class FirebaseConfig {
  const FirebaseConfig({
    this.useEmulators = false,
    this.emulatorHost = 'localhost',
    this.authEmulatorPort = 9099,
    this.firestoreEmulatorPort = 8080,
    this.storageEmulatorPort = 9199,
  });

  final bool useEmulators;
  final String emulatorHost;
  final int authEmulatorPort;
  final int firestoreEmulatorPort;
  final int storageEmulatorPort;
}
