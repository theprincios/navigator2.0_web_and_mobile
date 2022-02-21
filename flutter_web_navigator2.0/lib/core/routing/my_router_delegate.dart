import 'package:es_2022_02_02_1/api_models/helpDesk_model.dart';
import 'package:es_2022_02_02_1/core/networking/services/authentication/authentication_provider.dart';
import 'package:es_2022_02_02_1/core/routing/pages.dart';
import 'package:es_2022_02_02_1/ui/screen/authority_selection_screen.dart';
import 'package:es_2022_02_02_1/ui/screen/helpDesk_screen.dart';

import 'package:es_2022_02_02_1/ui/screen/main_screen.dart';
import 'package:es_2022_02_02_1/ui/screen/menagement_screen.dart';
import 'package:es_2022_02_02_1/ui/screen/not_login_screen.dart';
import 'package:es_2022_02_02_1/ui/screen/page404_screen.dart';
import 'package:es_2022_02_02_1/ui/screen/profile_screen.dart';
import 'package:es_2022_02_02_1/ui/screen/slot_management_screen.dart';
import 'package:es_2022_02_02_1/ui/screen/slot_type_screen.dart';
import 'package:es_2022_02_02_1/ui/widgets/my_material_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/page_configuration.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  late GlobalKey<NavigatorState> _navigatorKey;

  MyRouterDelegate() {
    _navigatorKey = GlobalKey<NavigatorState>();
    _routingInformation = _initialRoutingInformation;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  @override
  PageConfiguration get currentConfiguration => routingInformation;

  final PageConfiguration _initialRoutingInformation = PageConfiguration(
      key: UniqueKey().toString(),
      page: Pages.slotManagement,
      path: '/slotManagement');

  late PageConfiguration _routingInformation;

  PageConfiguration get routingInformation => _routingInformation;

  void setRoutingConfigurations(PageConfiguration routingInformation) {
    _routingInformation = routingInformation;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final isLogged = Provider.of<AuthenticationProvider>(context).getIsLogged;
    return Navigator(
      pages: buildPages(isLogged),
      onPopPage: (route, _) {
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) async =>
      setRoutingConfigurations(configuration);

  List<Page> buildPages(i) {
    List<Page> pages = [];

    pages.add(
      MyMaterialPage(
        key: MainScreen.keyPage,
        child: MainScreen(),
      ),
    );
    return pages;
  }

  Widget widgetFromPageConfiguration(PageConfiguration configuration) {
    switch (configuration.page) {
      case Pages.slotManagement:
        return const SlotManagementScreen();
      case Pages.slotType:
        return const SlotTypeScreen();
      case Pages.dors:
        return const HelpDeskScreen();
      case Pages.menagement:
        return const MenagementScreen();
      case Pages.authoritySelection:
        return const AuthoritySelectionScreen();
      case Pages.notLoginScreen:
        return const NotLoginScreen();
      case Pages.profile:
        return const ProfileScreen();
      default:
        return const Page404();
    }
  }
}
