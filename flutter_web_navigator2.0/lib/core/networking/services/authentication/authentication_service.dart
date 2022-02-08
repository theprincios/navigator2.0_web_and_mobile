import 'dart:developer';

import 'package:asf_auth_web/asf_auth_token_request.dart';
import 'package:asf_auth_web/asf_auth_web.dart';
import 'package:es_2022_02_02_1/core/networking/services/authentication/login_configuration.dart';
import 'package:es_2022_02_02_1/secure_storage/secure_storage_configurations.dart';
import 'package:es_2022_02_02_1/secure_storage/secure_storage_sevice.dart';
import 'package:tuple/tuple.dart';

class AuthenticationService {
  final SharedPreferencesService _secureStorageService =
      SharedPreferencesService();

  final tokenRequest = AsfAuthTokenRequest(
      clientId: LoginConfigurations().getClientId,
      redirectUrl: LoginConfigurations().getRedirectUrl,
      authorizationEndpoint: LoginConfigurations().getAuthorizationEndpoint,
      tokenEndpoint: LoginConfigurations().getTokenEndpoint,
      issuer: LoginConfigurations().getIssuer,
      scopes: LoginConfigurations().getScopes,
      discoveryUrl: LoginConfigurations().getDiscoveryUrl,
      parameter: LoginConfigurations().getParameter);

  Future<Tuple2<bool, String?>> login() async {
    try {
      // final loginConfiguration = LoginConfigurations();
      // final tokenRequest = AsfAuthTokenRequest(
      //     clientId: loginConfiguration.getClientId,
      //     redirectUrl: loginConfiguration.getRedirectUrl,
      //     authorizationEndpoint: loginConfiguration.getAuthorizationEndpoint,
      //     tokenEndpoint: loginConfiguration.getTokenEndpoint,
      //     issuer: loginConfiguration.getIssuer,
      //     scopes: loginConfiguration.getScopes,
      //     discoveryUrl: loginConfiguration.getDiscoveryUrl,
      //     parameter: loginConfiguration.getParameter);

      final requestLogin = await AsfAuthWeb.instance.authenticate(tokenRequest);

      if (requestLogin != null &&
          requestLogin.accessToken != null &&
          requestLogin.refreshToken != null &&
          requestLogin.accessTokenExpirationDateTime != null &&
          requestLogin.idToken != null) {
        await _secureStorageService.loginTokensService.saveTokensIntoDB(
          accessToken: requestLogin.accessToken,
          refreshToken: requestLogin.refreshToken,
          expiryDate: requestLogin.accessTokenExpirationDateTime.toString(),
          idToken: requestLogin.idToken,
        );
      } else {
        throw Exception(
            'Alcuni parametri non sono arrivati dalla richiesta di LOGIN');
      }
      return Tuple2(true, requestLogin.accessToken);
    } catch (e) {
      log('ERRORE LOGIN -  AUTENTICATION SERVICE - $e');
      return const Tuple2(false, null);
    }
  }

  Future<Tuple2<bool, String?>> refreshToken() async {
    try {
      final refreshToken = await _secureStorageService.loginTokensService
          .getTokenByKey((SharedPreferencesKeys.DATABASE_KEY_REFRESHTOKEN));

      if (refreshToken == null || refreshToken == '') {
        throw Exception(
            'Nessun refresh token trovato nel database - secure storage');
      }

      // final loginConfiguration = LoginConfigurations();
      // final tokenRequest = AsfAuthTokenRequest(
      //     clientId: loginConfiguration.getClientId,
      //     redirectUrl: loginConfiguration.getRedirectUrl,
      //     authorizationEndpoint: loginConfiguration.getAuthorizationEndpoint,
      //     tokenEndpoint: loginConfiguration.getTokenEndpoint,
      //     issuer: loginConfiguration.getIssuer,
      //     scopes: loginConfiguration.getScopes,
      //     discoveryUrl: loginConfiguration.getDiscoveryUrl,
      //     parameter: loginConfiguration.getParameter);

      final requestRefreshToken =
          await AsfAuthWeb.instance.refresh(refreshToken, tokenRequest);

      if (requestRefreshToken != null &&
          requestRefreshToken.accessToken != null &&
          requestRefreshToken.refreshToken != null &&
          requestRefreshToken.accessTokenExpirationDateTime != null &&
          requestRefreshToken.idToken != null) {
        await _secureStorageService.loginTokensService.saveTokensIntoDB(
          accessToken: requestRefreshToken.accessToken,
          refreshToken: requestRefreshToken.refreshToken,
          expiryDate:
              requestRefreshToken.accessTokenExpirationDateTime.toString(),
          idToken: requestRefreshToken.idToken,
        );
      } else {
        throw Exception(
            'Alcuni parametri non sono arrivati dalla richiesta di REFRESH_TOKEN');
      }

      return Tuple2(true, requestRefreshToken.accessToken);
    } catch (e) {
      log('ERRORE REFRESH TOKEN -  AUTENTICATION SERVICE - $e');
      return const Tuple2(false, null);
    }
  }

  Future<bool> logout() async {
    try {
      await _secureStorageService.loginTokensService.clearALLtokensIntoDB();

      return true;
    } catch (e) {
      log('ERRORE LOGOUT -  AUTENTICATION SERVICE - $e');
      return false;
    }
  }
}
