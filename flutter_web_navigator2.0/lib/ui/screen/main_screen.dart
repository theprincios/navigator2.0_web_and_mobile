import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:es_2022_02_02_1/api_models/get/get_user.dart';
import 'package:es_2022_02_02_1/api_models/get/get_user_logged.dart';
import 'package:es_2022_02_02_1/core/networking/services/api/api_service.dart';
import 'package:es_2022_02_02_1/core/networking/services/authentication/authentication_provider.dart';
import 'package:es_2022_02_02_1/core/routing/models/page_configuration.dart';
import 'package:es_2022_02_02_1/core/routing/my_router_delegate.dart';
import 'package:es_2022_02_02_1/core/routing/pages.dart';
import 'package:es_2022_02_02_1/secure_storage/entitys/user_logged_service.dart';
import 'package:es_2022_02_02_1/secure_storage/secure_storage_sevice.dart';
import 'package:es_2022_02_02_1/ui/screen/not_login_screen.dart';
import 'package:es_2022_02_02_1/ui/widgets/custom_app_bar.dart';
import 'package:es_2022_02_02_1/ui/widgets/responsive.dart';
import 'package:es_2022_02_02_1/ui/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  String? selectedValue;
  List<String> items = [
    'Profilo',
    'Log-Out',
  ];

  List<int> _getDividersIndexes() {
    List<int> _dividersIndexes = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _dividersIndexes.add(i);
      }
    }
    return _dividersIndexes;
  }

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
  bool selected = true;

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
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    '${user?.firstName[0] ?? ''}${user?.lastName[0] ?? ''} ',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 300,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    hint: Text(
                                      '${user?.firstName ?? ''} ${user?.lastName ?? ''} ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: 'Profilo',
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.user,
                                                color: Colors.grey[700],
                                                size: 18,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Profilo',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        enabled: false,
                                        child: Divider(),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'Esci',
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.logout,
                                                color: Colors.grey[700],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                'Esci',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                    customItemsIndexes: _getDividersIndexes(),
                                    customItemsHeight: 4,
                                    value: selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == 'Profilo') {
                                          Provider.of<MyRouterDelegate>(context,
                                                  listen: false)
                                              .setNewRoutePath(
                                            PageConfiguration(
                                              key: UniqueKey().toString(),
                                              page: Pages.profile,
                                              path: '/profileScreen',
                                            ),
                                          );
                                        } else if (value == 'Log-Out') {
                                          Provider.of<AuthenticationProvider>(
                                                  context,
                                                  listen: false)
                                              .logout();
                                        }
                                      });
                                    },
                                    buttonHeight: 40,
                                    buttonWidth: 180,
                                    itemHeight: 40,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                  ),
                                ),
                              ),
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

    if (responseHelpDesk.item1 == 200 || responseHelpDesk.item1 == 204) {
      final authorityValue = await SharedPreferencesService
          .cacheService.authorityStorage
          .authorityIdHasSaved();

      final userHasSaved =
          await UserLoggedService.service.setUserLogged(responseHelpDesk.item2);

      if (authorityValue != null) {
        ApiService.create.setAuthorityId(authorityValue);
      } else {
        final authority =
            await Provider.of<ApiService>(context, listen: false).authorities();

        if (authority.item1 == 200 || authority.item1 == 204) {
          final authorityValue = await SharedPreferencesService
              .cacheService.authorityStorage
              .setAuthorityId(authority.item2.first.authorityId!);
          ApiService.create.setAuthorityId(authority.item2.first.authorityId!);
        } else {
          Provider.of<AuthenticationProvider>(context, listen: false).setAuth =
              false;
        }
      }
      return responseHelpDesk.item2;
    }

    Provider.of<AuthenticationProvider>(context, listen: false).setAuth = false;
  }
}
