import 'package:es_2022_02_02_1/core/routing/my_router_delegate.dart';
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
  GlobalKey<ScaffoldState> get scaffoldKey => MainScreen._scaffoldKey;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: MainScreen._scaffoldKey,
      drawer: const SideMenu(),
      drawerEnableOpenDragGesture: Responsive.isDesktop(context) ? false : true,
      body: Row(
        children: [
          AnimatedContainer(
            width: Responsive.isDesktop(context)
                ? selected
                    ? 200.0
                    : 0.0
                : 0,
            alignment:
                selected ? Alignment.center : AlignmentDirectional.topCenter,
            duration: const Duration(microseconds: 100),
            curve: Curves.fastOutSlowIn,
            child: const SideMenu(),
          ),
          Expanded(
            child: Selector<MyRouterDelegate, Widget>(
              selector: (context, provider) => provider
                  .widgetFromPageConfiguration(provider.currentConfiguration),
              builder: (context, data, _) => data,
            ),
          ),
        ],
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          color: Theme.of(context).primaryColor,
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
                  icon: const Icon(Icons.menu),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const CircleAvatar(
                          radius: 40,
                        ),
                        // ignore: prefer_const_constructors
                        Text(
                          'Gennarino esposito',
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: Responsive.isDesktop(context)
          ? [
              const SizedBox(
                height: 30,
              )
            ]
          : null,
    );
  }
}
