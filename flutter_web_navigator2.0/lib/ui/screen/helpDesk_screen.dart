import 'package:es_2022_02_02_1/api_models/helpDesk_model.dart';
import 'package:es_2022_02_02_1/core/networking/services/api/api_service.dart';
import 'package:es_2022_02_02_1/core/routing/models/form_models.dart';
import 'package:es_2022_02_02_1/core/routing/models/page_configuration.dart';
import 'package:es_2022_02_02_1/core/routing/my_router_delegate.dart';
import 'package:es_2022_02_02_1/core/routing/pages.dart';
import 'package:es_2022_02_02_1/ui/widgets/automatic_child.dart';
import 'package:es_2022_02_02_1/ui/widgets/custom_dialog.dart';
import 'package:es_2022_02_02_1/ui/widgets/page_bar.dart';
import 'package:es_2022_02_02_1/ui/widgets/helpdesk_table.dart';
import 'package:es_2022_02_02_1/ui/widgets/research_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HelpDeskScreen extends StatefulWidget {
  const HelpDeskScreen({Key? key}) : super(key: key);
  static final LocalKey keyPage = UniqueKey();

  @override
  State<HelpDeskScreen> createState() => _HelpDeskScreenState();
}

class _HelpDeskScreenState extends State<HelpDeskScreen> {
  @override
  void initState() {
    // TODO: implement initState
    getData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PageBar(
              pageName: 'Sportelli',
              actioName: 'Aggiungi Sportello',
              primaryButtonDidTapHandler: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      title: "Nuovo Sportello",
                      primaryButtonTitle: 'Salva',
                      secondaryButtonTitle: 'Annulla',
                      primaryButtonDidTapHandler: () {},
                      secondaryButtonDidTapHandler: () {},
                      child: AutomaticChild(
                        forms: [
                          FormModel(
                              name: 'denomination',
                              value: '',
                              label: 'Denominazione'),
                          FormModel(
                              name: 'localization',
                              value: '',
                              label: 'Localizzazione'),
                          FormModel(
                              name: 'services',
                              value: '',
                              label: 'Trasporto Pubblico'),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            ResearchBar(
              child: Container(
                child: Row(
                  children: [Text('data')],
                ),
              ),
            ),
            const HelpDeskTable(),
          ],
        ),
      ),
    );
  }
}

Future<HelpDeskList?> getData(BuildContext context) async {
  final responseHelpDesk =
      await Provider.of<ApiService>(context, listen: false).getHelpDesk();
  if (responseHelpDesk.item1 == 401) {
    await Provider.of<MyRouterDelegate>(context, listen: false).setNewRoutePath(
      PageConfiguration(
        key: UniqueKey().toString(),
        page: Pages.notLoginScreen,
        path: '/notloginscreen',
      ),
    );
  }
  return responseHelpDesk.item2;
}
