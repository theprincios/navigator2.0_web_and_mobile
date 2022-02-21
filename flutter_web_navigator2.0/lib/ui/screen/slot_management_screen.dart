import 'package:calendar_view/calendar_view.dart';
import 'package:es_2022_02_02_1/ui/widgets/custom_dialog.dart';
import 'package:es_2022_02_02_1/ui/widgets/page_bar.dart';
import 'package:flutter/material.dart';

class SlotManagementScreen extends StatelessWidget {
  const SlotManagementScreen({Key? key}) : super(key: key);

  static final LocalKey keyPage = UniqueKey();

  @override
  Widget build(BuildContext context) {
    var dataLayout = MediaQuery.of(context);

    // ignore: prefer_const_constructors
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            PageBar(
              actioName: 'Nuovo Slot',
              pageName: 'Gestione Ticket',
              primaryButtonDidTapHandler: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      title: "Nuovo Sportello",
                      primaryButtonTitle: 'Salva',
                      secondaryButtonTitle: 'Annulla',
                      primaryButtonDidTapHandler: () {},
                      secondaryButtonDidTapHandler: () {},
                      child: Column(children: []),
                    );
                  },
                );
              },
            ),
            const Expanded(
                child: SizedBox(
                    child: Center(
              child: Text('Gestione Ticket'),
            )))
          ],
        ));
  }
}
