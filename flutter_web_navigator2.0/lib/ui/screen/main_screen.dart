import 'package:dio/dio.dart';
import 'package:es_2022_02_02_1/api_models/user.dart';
import 'package:es_2022_02_02_1/api_models/user_logged.dart';
import 'package:es_2022_02_02_1/core/networking/services/api/api_service.dart';
import 'package:es_2022_02_02_1/core/networking/services/authentication/authentication_provider.dart';
import 'package:es_2022_02_02_1/core/routing/my_router_delegate.dart';
import 'package:es_2022_02_02_1/ui/screen/not_login_screen.dart';
import 'package:es_2022_02_02_1/ui/widgets/custom_app_bar.dart';
import 'package:es_2022_02_02_1/ui/widgets/responsive.dart';
import 'package:es_2022_02_02_1/ui/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MainScreen({Key? key}) : super(key: key);
  static final LocalKey keyPage = UniqueKey();

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  static void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserLogged? user;

  @override
  void initState() {
    super.initState();
    getData(context).then((value) {
      setState(() {
        user = value!;
      });
    });
  }

  GlobalKey<ScaffoldState> get scaffoldKey => MainScreen._scaffoldKey;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Selector<AuthenticationProvider, bool>(selector: (p0, p1) {
      return p1.getIsLogged;
    }, builder: (context, data, _) {
      if (data) {
        return Scaffold(
          extendBody: true,
          key: MainScreen._scaffoldKey,
          drawer: const SideMenu(),
          drawerEnableOpenDragGesture:
              Responsive.isDesktop(context) ? false : true,
          body: Row(
            children: [
              AnimatedContainer(
                  width: Responsive.isDesktop(context)
                      ? selected
                          ? 300.0
                          : 0.0
                      : 0,
                  alignment: selected
                      ? Alignment.center
                      : AlignmentDirectional.topCenter,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.fastOutSlowIn,
                  child: SideMenu()),
              Expanded(
                child: Selector<MyRouterDelegate, Widget>(
                  selector: (context, provider) =>
                      provider.widgetFromPageConfiguration(
                          provider.currentConfiguration),
                  builder: (context, data, _) {
                    return data;
                  },
                ),
              ),
            ],
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomAppBar(
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          selected = !selected;
                        });
                      },
                      icon: Icon(
                        Icons.menu,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    actions: [
                      Container(
                        color: Theme.of(context).backgroundColor,
                        margin: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () async {
                            await Provider.of<AuthenticationProvider>(context,
                                    listen: false)
                                .login();
                          },
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              CircleAvatar(
                                  radius: 40,
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                              // ignore: prefer_const_constructors

                              Text(
                                '${user?.firstName ?? ''} ${user?.lastName ?? ''} ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColor),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    await Provider.of<AuthenticationProvider>(
                                            context,
                                            listen: false)
                                        .logout();
                                  },
                                  child: Text('logout'))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return NotLoginScreen();
    });
  }

  Future<UserLogged?> getData(BuildContext context) async {
    final responseHelpDesk =
        await Provider.of<ApiService>(context, listen: false).profiles();

    if (responseHelpDesk.item1 == 200) {
      final authority =
          await Provider.of<ApiService>(context, listen: false).authorities();
      ApiService.create.authorities().then((value) =>
          ApiService.create.setAuthorityId(authority.item2.first.authorityId!));
    }
    if (responseHelpDesk.item1 == 401) {
      Provider.of<AuthenticationProvider>(context, listen: false).setAuth =
          false;
    }

    return responseHelpDesk.item2;
  }
}
