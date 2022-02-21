import 'package:es_2022_02_02_1/core/routing/models/page_configuration.dart';
import 'package:es_2022_02_02_1/core/routing/my_router_delegate.dart';
import 'package:es_2022_02_02_1/core/routing/pages.dart';
import 'package:es_2022_02_02_1/ui/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drawer_button.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({this.title, this.actions, this.leading, Key? key})
      : super(key: key);

  Text? title;
  List<Widget>? actions;

  Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leading: Responsive.isDesktop(context)
            ? leading ?? Container()
            : DrawerButton(),
        title: title ?? Text(''),
        elevation: 0,
        actions: actions);
  }
}
