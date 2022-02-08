import 'entitys/login_tokens_service.dart';

class SharedPreferencesService {
  final LoginTokenService _loginTokensService = LoginTokenService();
  LoginTokenService get loginTokensService => _loginTokensService;
}
