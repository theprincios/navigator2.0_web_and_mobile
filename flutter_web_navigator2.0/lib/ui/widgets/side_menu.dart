import 'package:es_2022_02_02_1/core/routing/models/page_configuration.dart';
import 'package:es_2022_02_02_1/core/routing/my_router_delegate.dart';
import 'package:es_2022_02_02_1/core/routing/pages.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      child: ListView(
        children: [
          // ignore: prefer_const_constructors
          DrawerHeader(
              margin: const EdgeInsets.only(top: 50),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    await Provider.of<MyRouterDelegate>(context, listen: false)
                        .setNewRoutePath(
                      PageConfiguration(
                        key: UniqueKey().toString(),
                        page: Pages.profile,
                        path: '/profileScreen',
                      ),
                    );
                  },
                  child: Icon(
                    Icons.flag,
                    size: 140,
                    color: Colors.white,
                  ),
                ),
              )),
          SizedBox(
            height: 40,
          ),
          const Center(
            child: Text(
              'Comune di vitulano',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ExpansionTile(
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            title: const Text("Configurazioni",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            children: <Widget>[
              DrawerListTile(
                child: const Icon(
                  FontAwesomeIcons.ticketAlt,
                  color: Colors.white,
                  size: 18,
                ),
                title: "Gestione Ticket",
                svgSrc: "assets/icons/menu_dashbord.svg",
                press: () async {
                  await Provider.of<MyRouterDelegate>(context, listen: false)
                      .setNewRoutePath(
                    PageConfiguration(
                      key: UniqueKey().toString(),
                      page: Pages.slotManagement,
                      path: '/slotManagement',
                    ),
                  );
                },
              ),
              DrawerListTile(
                child: const Icon(
                  FontAwesomeIcons.list,
                  color: Colors.white,
                  size: 18,
                ),
                title: "Tipo Slot",
                svgSrc: "assets/icons/menu_tran.svg",
                press: () async {
                  await Provider.of<MyRouterDelegate>(context, listen: false)
                      .setNewRoutePath(
                    PageConfiguration(
                      key: UniqueKey().toString(),
                      page: Pages.slotType,
                      path: '/slotType',
                    ),
                  );
                },
              ),
              DrawerListTile(
                child: const Icon(
                  FontAwesomeIcons.chalkboard,
                  color: Colors.white,
                  size: 18,
                ),
                title: "Sportelli",
                svgSrc: "assets/icons/menu_tran.svg",
                press: () async {
                  await Provider.of<MyRouterDelegate>(context, listen: false)
                      .setNewRoutePath(
                    PageConfiguration(
                      key: UniqueKey().toString(),
                      page: Pages.dors,
                      path: '/dors',
                    ),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              title: const Text("Prenotazioni",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              children: <Widget>[
                DrawerListTile(
                  child: const Icon(
                    FontAwesomeIcons.cog,
                    color: Colors.white,
                    size: 18,
                  ),
                  title: "Gestione",
                  svgSrc: "assets/icons/menu_doc.svg",
                  press: () async {
                    await Provider.of<MyRouterDelegate>(context, listen: false)
                        .setNewRoutePath(
                      PageConfiguration(
                        key: UniqueKey().toString(),
                        page: Pages.menagement,
                        path: '/menagement',
                      ),
                    );
                  },
                ),
              ]),
          /*    DrawerListTile(
            title: "Page 4",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Page 5",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ), */
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key,
      // For selecting those three line once press "Command+D"
      required this.title,
      required this.svgSrc,
      required this.press,
      this.child})
      : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return
        // ListTile(
        //   onTap: press,
        //   horizontalTitleGap: 0.0,
        //   title:
        Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: press,
          child: Container(
            margin: EdgeInsets.all(8),
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: child ?? Container(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
            // ),
          ),
        ),
      ],
    );
  }
}
