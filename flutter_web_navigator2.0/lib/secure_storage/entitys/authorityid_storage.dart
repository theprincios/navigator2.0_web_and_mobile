import 'dart:convert';
import 'dart:developer';
import 'package:es_2022_02_02_1/secure_storage/secure_storage_configurations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class AuthorityStorage {
  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  Future<int?> authorityIdHasSaved() async {
    try {
      final preferences = await _preferences;
      final String? storageValue =
          preferences.getString(SharedPreferencesKeys.DATABASE_KEY_AUTHORITYID);

      if (storageValue == null) {
        throw Exception('nessun elemento nello storage trovato');
      } else {
        final value = int.parse(jsonDecode(storageValue).toString());

        return value;
      }
    } catch (e) {
      print('authorityIdHasSaved : $e');
      return null;
    }
  }

  Future<bool> clear() async {
    try {
      final preferences = await _preferences;

      final clearValue = await preferences
          .remove(SharedPreferencesKeys.DATABASE_KEY_AUTHORITYID);

      return clearValue;
    } catch (e) {
      log('clear : $e');

      return false;
    }
  }

  Future<bool> setAuthorityId(int authorityId) async {
    try {
      final preferences = await _preferences;

      final clearResponse = await clear();

      if (clearResponse) {
        final savedResult = await preferences.setString(
          SharedPreferencesKeys.DATABASE_KEY_AUTHORITYID,
          jsonEncode(authorityId),
        );

        return savedResult;
      } else {
        throw Exception('errore salvataggio in memoria');
      }
    } catch (e) {
      log('setAuthorityId : $e');

      return false;
    }
  }
}
