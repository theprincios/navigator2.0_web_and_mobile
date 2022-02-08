import 'package:es_2022_02_02_1/core/networking/services/authentication/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'config/environment/env_manager.dart';
import 'core/routing/my_back_button_dispatcher.dart';
import 'core/routing/my_router_delegate.dart';
import 'core/routing/my_router_information_parser.dart';

void main() async {
  await dotenv.load(fileName: EnvManager.environmentFile);

  print(await AuthenticationProvider.authenticationProvider.getAccessToken);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final myRouterDelegate = MyRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<MyRouterDelegate>(
          create: (context) => myRouterDelegate,
          dispose: (context, myRouterDelegate) => myRouterDelegate.dispose(),
        ),
        ListenableProvider<AuthenticationProvider>(
          create: (context) => AuthenticationProvider.authenticationProvider,
          dispose: (context, provider) => provider.dispose(),
        ),
      ],
      child: MaterialApp.router(
        key: UniqueKey(),
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        routerDelegate: myRouterDelegate,
        routeInformationParser: MyRouteInformationParser(),
        backButtonDispatcher: MyBackButtonDispatcher(),
      ),
    );
  }
}
