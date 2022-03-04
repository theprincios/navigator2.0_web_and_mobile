import 'package:es_2022_02_02_1/api_models/get/get_user_logged.dart';

import 'user_logged_storage.dart';

class UserLoggedService {
  static final UserLoggedService service = UserLoggedService();

  final UserLoggedStorage _userLoggedStorage = UserLoggedStorage();

  UserLogged? _userLogged;

  Future<UserLogged?> get userLogged async {
    if (_userLogged == null) {
      return _userLogged = await _userLoggedStorage.getUserLogged();
    }
    return _userLogged;
  }

  Future<bool> setUserLogged(UserLogged? userLogged) async {
    final responseSetUserLogged =
        await _userLoggedStorage.setUserLogged(userLogged);
    if (responseSetUserLogged) {
      _userLogged = userLogged;
    }
    return responseSetUserLogged;
  }

  Future<bool> resetUserLogged() async {
    _userLogged = null;
    return await _userLoggedStorage.clearUserLogged();
  }
}
