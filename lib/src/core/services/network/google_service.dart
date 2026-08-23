import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef GoogleAuthTokens = ({String idToken, String accessToken});

final class GoogleService {
  static const _scopes = <String>['email', 'profile'];

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final String _webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;
  final String _iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID']!;
  Future<void>? _initialization;

  Future<GoogleAuthTokens> signIn() async {
    await _initialize();

    if (!_googleSignIn.supportsAuthenticate()) {
      throw const GoogleSignInException(
        code: GoogleSignInExceptionCode.uiUnavailable,
        description:
            'Interactive Google sign-in is not supported on this platform.',
      );
    }

    final googleAccount = await _googleSignIn.authenticate(scopeHint: _scopes);
    final authorizationClient = googleAccount.authorizationClient;
    final googleAuthorization = await authorizationClient
        .authorizationForScopes(_scopes);
    final googleAuthentication = googleAccount.authentication;
    final idToken = googleAuthentication.idToken;

    if (idToken == null) {
      throw const GoogleSignInException(
        code: GoogleSignInExceptionCode.unknownError,
        description: 'Google did not return an ID token.',
      );
    }

    return (idToken: idToken, accessToken: googleAuthorization!.accessToken);
  }

  Future<void> signOut() async {
    await _initialize();
    await _googleSignIn.signOut();
  }

  Future<void> _initialize() {
    return _initialization ??= _googleSignIn.initialize(
      clientId: _iosClientId,
      serverClientId: _webClientId,
    );
  }
}
