import 'package:flutter/material.dart';
import 'models/page_configuration.dart';
import 'pages.dart';

class MyRouteInformationParser
    extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '/');
    if (uri.pathSegments.isEmpty) {
      return PageConfiguration(
          key: UniqueKey().toString(),
          page: Pages.slotManagement,
          path: '/slotManagement');
    } else if (uri.pathSegments.length == 1) {
      final first = uri.pathSegments[0].toLowerCase();
      if (first == 'slotManagement') {
        return PageConfiguration(
            key: UniqueKey().toString(),
            page: Pages.slotManagement,
            path: '/slotManagement');
      } else if (first == 'slotType') {
        return PageConfiguration(
            key: UniqueKey().toString(),
            page: Pages.slotType,
            path: '/slotType');
      } else if (first == 'dors') {
        return PageConfiguration(
            key: UniqueKey().toString(), page: Pages.dors, path: '/dors');
      } else if (first == 'management') {
        return PageConfiguration(
            key: UniqueKey().toString(),
            page: Pages.menagement,
            path: '/management');
      } else if (first == 'authorityselection') {
        return PageConfiguration(
            key: UniqueKey().toString(),
            page: Pages.authoritySelection,
            path: '/authoritySelection');
      } else if (first == 'notloginscreen') {
        return PageConfiguration(
            key: UniqueKey().toString(),
            page: Pages.notLoginScreen,
            path: '/notloginscreen');
      } else if (first == 'profilescreen') {
        return PageConfiguration(
            key: UniqueKey().toString(),
            page: Pages.notLoginScreen,
            path: '/profileScreen');
      } else {
        return PageConfiguration(
            key: UniqueKey().toString(), page: Pages.error404, path: '/404');
      }
    }
    return PageConfiguration(
        key: UniqueKey().toString(), page: Pages.error404, path: '/404');
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    if (configuration.page == Pages.slotManagement) {
      return const RouteInformation(location: '/slotManagement');
    } else if (configuration.page == Pages.slotType) {
      return const RouteInformation(location: '/slotType');
    } else if (configuration.page == Pages.dors) {
      return const RouteInformation(location: '/dors');
    } else if (configuration.page == Pages.menagement) {
      return const RouteInformation(location: '/management');
    } else if (configuration.page == Pages.authoritySelection) {
      return const RouteInformation(location: '/authoritySelection');
    } else if (configuration.page == Pages.notLoginScreen) {
      return const RouteInformation(location: '/notloginscreen');
    } else if (configuration.page == Pages.profile) {
      return const RouteInformation(location: '/profileScreen');
    } else {
      return const RouteInformation(location: '/404');
    }
  }
}
