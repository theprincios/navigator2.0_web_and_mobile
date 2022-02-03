import 'package:es_2022_02_02_1/core/routing/models/page_configuration.dart';
import 'package:es_2022_02_02_1/core/routing/my_router_delegate.dart';
import 'package:es_2022_02_02_1/core/routing/pages.dart';
import 'package:es_2022_02_02_1/ui/widgets/custom_app_bar.dart';
import 'package:es_2022_02_02_1/ui/widgets/drawer_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static final LocalKey keyPage = UniqueKey();

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}
