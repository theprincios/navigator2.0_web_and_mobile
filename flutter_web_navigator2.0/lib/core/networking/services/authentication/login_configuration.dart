import 'package:es_2022_02_02_1/config/environment/env_manager.dart';

class LoginConfigurations {
  final String _clientId = EnvManager.authConfig.clientId;
  final String _redirectUrl = EnvManager.authConfig.redirectUrl;
  final String _issuer = EnvManager.authConfig.issuer;
  final List<String> _scopes = EnvManager.authConfig.scopes;
  final String _authorizationEndpoint =
      EnvManager.authConfig.authorizationEndpoint;

  final String _discoveryUrl = EnvManager.authConfig.discoveryUrl;
  final String _postLogoutRedirectUrl =
      EnvManager.authConfig.postLogoutRedirectUrl;
  final String _tokenEndpoint = EnvManager.authConfig.tokenEndpoint;
  final String _endSessionEndpoint = EnvManager.authConfig.endSessionEndpoint;

  final Map<String, String> _parameter = {
    'authorityId': EnvManager.authConfig.authorityId
  };

  final List<String> _promptValues = ['login'];

  String get getClientId => _clientId;
  String get getRedirectUrl => _redirectUrl;
  String get getIssuer => _issuer;
  List<String> get getScopes => _scopes;
  String get getDiscoveryUrl => _discoveryUrl;
  String get getPostLogoutRedirectUrl => _postLogoutRedirectUrl;
  Map<String, String> get getParameter => _parameter;
  List<String> get gePromptValues => _promptValues;
  String get getAuthorizationEndpoint => _authorizationEndpoint;
  String get getTokenEndpoint => _tokenEndpoint;
  String get getEndSessionEndpoint => _endSessionEndpoint;
}
