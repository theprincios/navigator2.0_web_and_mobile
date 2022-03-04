import 'package:es_2022_02_02_1/core/networking/services/authentication/authentication_provider.dart';
import 'package:es_2022_02_02_1/ui/widgets/card_xl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotLoginScreen extends StatelessWidget {
  const NotLoginScreen({Key? key}) : super(key: key);
  static final LocalKey keyPage = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CardXL(
              subtitle: 'Effettua il login per accedere al servizio',
              buttomText: 'Login',
              buttonDidTapHandler: () async {
                await Provider.of<AuthenticationProvider>(context,
                        listen: false)
                    .login();
              },
            ),
          )
        ],
      ),
    );
  }
}
