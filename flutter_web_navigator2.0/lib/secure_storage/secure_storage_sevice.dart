import 'package:es_2022_02_02_1/secure_storage/entitys/authorityid_storage.dart';

import 'entitys/login_tokens_service.dart';

class SharedPreferencesService {
  static SharedPreferencesService cacheService = SharedPreferencesService();

  final LoginTokenService _loginTokensService = LoginTokenService();
  LoginTokenService get loginTokensService => _loginTokensService;

  final AuthorityStorage _authorityStorage = AuthorityStorage();
  AuthorityStorage get authorityStorage => _authorityStorage;
}
