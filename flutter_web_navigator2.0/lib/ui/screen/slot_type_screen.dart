import 'package:es_2022_02_02_1/core/routing/models/form_models.dart';
import 'package:es_2022_02_02_1/ui/widgets/automatic_child.dart';
import 'package:es_2022_02_02_1/ui/widgets/custom_dialog.dart';
import 'package:es_2022_02_02_1/ui/widgets/page_bar.dart';
import 'package:flutter/material.dart';

import 'package:responsive_table/responsive_table.dart';

class SlotTypeScreen extends StatelessWidget {
  const SlotTypeScreen({Key? key}) : super(key: key);

  static final LocalKey keyPage = UniqueKey();

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: Column(
        children: [
          PageBar(
            pageName: 'Tipo Slot',
            actioName: 'Aggiungi Slot',
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
                    child: Column(
                      children: [
                        AutomaticChild(
                          forms: [
                            FormModel(
                                name: 'denomination',
                                value: '',
                                label: 'Denominazione'),
                            FormModel(
                                name: 'smartPacategory',
                                value: '',
                                label: 'Categoria Smart.PA'),
                            FormModel(
                                name: 'slotDuration',
                                value: '',
                                label: 'Durata Slot'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AutomaticToggle(
                              toggle: [
                                FormModel(
                                    name: 'denomination',
                                    value: '',
                                    label: 'Denominazione'),
                              ],
                            ),
                            const Text(
                              'Pagamento diritti',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        AutomaticChild(
                          forms: [
                            FormModel(
                                name: 'slotDuration',
                                value: '',
                                label: 'Durata Slot'),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
