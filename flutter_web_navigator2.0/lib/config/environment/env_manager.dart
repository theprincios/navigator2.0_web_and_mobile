import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvManager {
  static String get environmentFile =>
      kReleaseMode ? "assets/envs/.env.prod" : "assets/envs/.env.dev";
  static String get environment => kReleaseMode ? "production" : "development";
  static _AuthConfig get authConfig => _AuthConfig();
}

class _AuthConfig {
  static final _AuthConfig shared = _AuthConfig._privateConstructor();

  _AuthConfig._privateConstructor();

  String get baseUrl => dotenv.get('API_BASE_URL', fallback: '');
  String get clientId => dotenv.get("CLIENT_ID", fallback: '');
  String get redirectUrl => dotenv.get('REDIRECT_URL', fallback: '');
  String get issuer => dotenv.get('ISSUER', fallback: '');
  String get authorityId => dotenv.get('AUTHORITY_ID', fallback: '');
  List<String> get scopes {
    final scopesString = dotenv.get('API_SCOPES', fallback: '');
    final scopesList = scopesString.split(',');
    return scopesList;
  }

  String get discoveryUrl => dotenv.get('DISCOVERY_URL', fallback: '');
  String get postLogoutRedirectUrl =>
      dotenv.get('POST_LOGOUT_REDIRECT_URL', fallback: '');
  String get authorizationEndpoint =>
      dotenv.get('AUTHORIZATION_ENDPOINT', fallback: '');
  String get tokenEndpoint => dotenv.get('TOKEN_ENDPOINT', fallback: '');
  String get endSessionEndpoint =>
      dotenv.get('END_SESSION_ENDPOINT', fallback: '');

  factory _AuthConfig() {
    return shared;
  }
}
