import 'package:es_2022_02_02_1/core/networking/services/authentication/authentication_service.dart';
import 'package:es_2022_02_02_1/secure_storage/secure_storage_configurations.dart';
import 'package:es_2022_02_02_1/secure_storage/secure_storage_sevice.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticationService _authService = AuthenticationService();

  static final AuthenticationProvider authenticationProvider =
      AuthenticationProvider();

  bool _isLogged = true;
  bool get getIsLogged => _isLogged;

  set setAuth(bool isLogged) {
    _isLogged = isLogged;
    notifyListeners();
  }

  String? _accessToken;

  Future<String?> get getAccessToken async {
    if (_accessToken == null) {
      _accessToken = await SharedPreferencesService()
          .loginTokensService
          .getTokenByKey((SharedPreferencesKeys.DATABASE_KEY_ACCESSTOKEN));
      return _accessToken;
    }
    return _accessToken;
  }

  set setAccessToken(String? accessToken) => _accessToken = accessToken;

  Future<void> login() async {
    final loginResponse = await _authService.login();
    if (loginResponse.item1) {
      setAccessToken = loginResponse.item2;

      _isLogged = true;

      notifyListeners();
    }
  }

  Future<void> logout() async {
    final bool isNotLogged = await _authService.logout();
    if (isNotLogged) {
      setAccessToken = null;

      _isLogged = false;
      notifyListeners();
    }
  }

  Future<bool> refreshToken() async {
    final refreshResponse = await _authService.refreshToken();
    if (refreshResponse.item2 != null) {
      setAccessToken = refreshResponse.item2;
    }

    return refreshResponse.item1;
  }
}
