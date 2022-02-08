import 'dart:developer';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../secure_storage_configurations.dart';

class LoginTokenService {
  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  Future<String?> getTokenByKey(String secureStorageKey) async {
    final preferences = await _preferences;
    try {
      switch (secureStorageKey) {
        case SharedPreferencesKeys.DATABASE_KEY_ACCESSTOKEN:
          return preferences.getString(secureStorageKey);

        case SharedPreferencesKeys.DATABASE_KEY_IDTOKEN:
          return preferences.getString(secureStorageKey);

        case SharedPreferencesKeys.DATABASE_KEY_REFRESHTOKEN:
          return preferences.getString(secureStorageKey);

        case SharedPreferencesKeys.DATABASE_KEY_EXPIRYDATE:
          return preferences.getString(secureStorageKey);
        default:
          throw Exception(' (getTokenById) KEY database non valida');
      }
    } catch (e) {
      log('(getTokenById) Errore Lettura dal Database - $e');
      return null;
    }
  }

  Future<void> saveTokensIntoDB(
      {required String accessToken,
      required String refreshToken,
      required String expiryDate,
      required String idToken}) async {
    final preferences = await _preferences;

    await clearALLtokensIntoDB();
    await preferences.setString(
      SharedPreferencesKeys.DATABASE_KEY_ACCESSTOKEN,
      accessToken,
    );
    await preferences.setString(
      SharedPreferencesKeys.DATABASE_KEY_REFRESHTOKEN,
      refreshToken,
    );
    await preferences.setString(
      SharedPreferencesKeys.DATABASE_KEY_IDTOKEN,
      idToken,
    );
    await preferences.setString(
      SharedPreferencesKeys.DATABASE_KEY_EXPIRYDATE,
      expiryDate,
    );
  }

  Future<void> clearALLtokensIntoDB() async {
    final preferences = await _preferences;

    await preferences.remove(SharedPreferencesKeys.DATABASE_KEY_ACCESSTOKEN);
    await preferences.remove(SharedPreferencesKeys.DATABASE_KEY_EXPIRYDATE);
    await preferences.remove(SharedPreferencesKeys.DATABASE_KEY_IDTOKEN);
    await preferences.remove(SharedPreferencesKeys.DATABASE_KEY_REFRESHTOKEN);
  }
}
