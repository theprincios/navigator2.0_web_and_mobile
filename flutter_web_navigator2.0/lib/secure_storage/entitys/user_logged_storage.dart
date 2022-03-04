import 'dart:convert';
import 'dart:developer';

import 'package:es_2022_02_02_1/api_models/get/get_user_logged.dart';
import 'package:es_2022_02_02_1/secure_storage/secure_storage_configurations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoggedStorage {
  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  Future<UserLogged?> getUserLogged() async {
    try {
      final preferences = await _preferences;
      final String? userLogged =
          preferences.getString(SharedPreferencesKeys.USER_LOGGED_KEY);

      if (userLogged == null) {
        throw Exception('nessun utente loggato trovato');
      } else {
        final userLoggedMap = jsonDecode(userLogged);

        if (userLoggedMap != null) {
          return UserLogged.fromJson(userLoggedMap);
        } else {
          throw Exception('Mappa non convertita userLoggedMap');
        }
      }
    } catch (e) {
      log('getUserLogged : $e');
      return null;
    }
  }

  Future<bool> clearUserLogged() async {
    try {
      final preferences = await _preferences;

      final userLoggedIsDeleted =
          await preferences.remove(SharedPreferencesKeys.USER_LOGGED_KEY);

      return userLoggedIsDeleted;
    } catch (e) {
      log('clearUserLogged : $e');

      return false;
    }
  }

  Future<bool> setUserLogged(UserLogged? userLogged) async {
    try {
      final preferences = await _preferences;

      if (userLogged == null) {
        throw Exception('nessun parametro in ingresso (null)');
      } else {
        final clearResponse = await this.clearUserLogged();

        if (clearResponse) {
          final isUserLoggedSaved = await preferences.setString(
            SharedPreferencesKeys.USER_LOGGED_KEY,
            jsonEncode(userLogged.toJson()),
          );

          return isUserLoggedSaved;
        } else {
          throw Exception(
              'shared_preferences utente non cancellato correttamente');
        }
      }
    } catch (e) {
      log('setUserLogged : $e');

      return false;
    }
  }
}
