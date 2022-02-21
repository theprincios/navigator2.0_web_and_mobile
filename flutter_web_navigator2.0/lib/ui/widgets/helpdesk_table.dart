import 'package:es_2022_02_02_1/api_models/helpDesk_model.dart';
import 'package:es_2022_02_02_1/api_models/user.dart';
import 'package:es_2022_02_02_1/core/routing/models/form_models.dart';
import 'package:flutter/material.dart';

import 'automatic_child.dart';
import 'custom_dialog.dart';

class HelpDeskTable extends StatefulWidget {
  const HelpDeskTable({Key? key}) : super(key: key);

  @override
  _HelpDeskTableState createState() => _HelpDeskTableState();
}

class _HelpDeskTableState extends State<HelpDeskTable> {
  late List<HelpDesk> cages;
  late DataTableSource _data;

  @override
  void initState() {
    super.initState();
    cages = [
      HelpDesk(address: 'via municipio 4 ', id: '001', name: 'carte identita'),
    ];
    _data = DataTable(cage: cages);
    // WidgetsBinding.instance?.addPostFrameCallback((_) async {
    //   Provider.of<Repository>(context, listen: false).fetchUsers();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(20),
          width: double.infinity,
          child: Card(
            elevation: 2,
            color: Colors.white,
            child: Container(
              width: double.infinity,
              child: PaginatedDataTable(
                  columnSpacing: 8,
                  // ignore: prefer_const_literals_to_create_immutables
                  columns: const [
                    DataColumn(
                      label: Text(
                        "Denominazione",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Localizzazione",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      'Azioni',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ))),
                  ],
                  rowsPerPage: cages.length < 10 ? cages.length : 10,
                  source: _data),
            ),
          ),
        ),
      ],
    );
  }
}

class DataTable extends DataTableSource {
  DataTable({required this.cage});

  List<HelpDesk> cage;
  // Generate some made-up data

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => cage.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(cage[index].name)),
      DataCell(Text(cage[index].address)),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [CustomDropDown(id: cage[index].name)],
      )),
    ]);
  }
}

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        dropdownColor: Colors.white,
        icon: const Icon(Icons.more_vert),
        iconSize: 20,
        style: const TextStyle(
          fontSize: 18.0,
          color: Colors.black,
        ),
        onChanged: (newValue) {
          newValue == '0'
              ? showDialog(
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
                              value: widget.id,
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
                )
              : newValue == '1'
                  ? print('Elimina ${widget.id}')
                  : print('object');
        },
        items: [
          DropdownMenuItem(
            value: '0',
            child: Row(
              children: [
                Icon(
                  Icons.mode,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Modifica',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
          DropdownMenuItem(
            value: '1',
            child: Row(
              children: [
                Icon(Icons.delete, color: Theme.of(context).primaryColor),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Elimina',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ],
            ),
          )
        ]);
  }
}
