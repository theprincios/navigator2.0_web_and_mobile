import 'package:es_2022_02_02_1/api_models/get/get_helpDesk_model.dart';
import 'package:es_2022_02_02_1/api_models/get/get_place_search.dart';
import 'package:es_2022_02_02_1/api_models/post/post_helpDesk_model.dart';
import 'package:es_2022_02_02_1/core/networking/provider/page_refresh.dart';
import 'package:es_2022_02_02_1/core/networking/services/api/api_service.dart';
import 'package:es_2022_02_02_1/core/routing/models/page_configuration.dart';
import 'package:es_2022_02_02_1/core/routing/my_router_delegate.dart';
import 'package:es_2022_02_02_1/core/routing/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../custom_autocomplete.dart';
import '../custom_delete_dialog.dart';
import '../custom_dialog.dart';

class HelpDeskTable extends StatelessWidget {
  const HelpDeskTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageRefresh>(
      builder: (context, value, child) {
        return BuildHelpDeskTable();
      },
    );
  }
}

class BuildHelpDeskTable extends StatefulWidget {
  BuildHelpDeskTable({Key? key}) : super(key: key);

  @override
  _HelpDeskTableState createState() => _HelpDeskTableState();
}

class _HelpDeskTableState extends State<BuildHelpDeskTable> {
  HelpDeskList? helpdesk;

  @override
  void initState() {
    super.initState();
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
                  child:
                      Consumer<PageRefresh>(builder: (context, value, child) {
                    return FutureBuilder<HelpDeskList?>(
                      future: getData(context),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          final helpDeskItem = snapshot.data;

                          return PaginatedDataTable(
                            columnSpacing: 8,
                            // ignore: prefer_const_literals_to_create_immutables
                            columns: const [
                              DataColumn(
                                label: Text(
                                  "Denominazione",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Localizzazione",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Azioni',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                            rowsPerPage: 10,
                            source: DataTable(cage: helpDeskItem),
                          );
                        } else if (snapshot.hasError)
                          Center(
                            child: Text('gennarino'),
                          );
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  }))),
        )
      ],
    );
  }

  Future<HelpDeskList?> getData(BuildContext context) async {
    try {
      final responseHelpDesk =
          await Provider.of<ApiService>(context, listen: false).getHelpDesk();
      if (responseHelpDesk.item1 == 401) {
        await Provider.of<MyRouterDelegate>(context, listen: false)
            .setNewRoutePath(
          PageConfiguration(
            key: UniqueKey().toString(),
            page: Pages.notLoginScreen,
            path: '/notloginscreen',
          ),
        );
      } else {
        return responseHelpDesk.item2;
      }
    } catch (e) {
      return Future.error('');
    }
  }
}

class DataTable extends DataTableSource {
  DataTable({required this.cage});

  HelpDeskList? cage;
  // Generate some made-up data

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => cage!.items.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(cage!.items[index].name)),
      DataCell(Text(cage!.items[index].address)),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomDropDown(
              id: cage!.items[index].id, name: cage!.items[index].name)
        ],
      )),
    ]);
  }
}

class CustomDropDown extends StatefulWidget {
  CustomDropDown({Key? key, required this.id, this.name}) : super(key: key);

  final int id;
  final String? name;

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  double? latitude;
  double? longitude;

  late List<String> service = [];
  @override
  Widget build(BuildContext _context) {
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
                    return FutureBuilder<HelpDeskById?>(
                      future: gethelpDeskById(context, widget.id),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final data = snapshot.data;
                          final form = FormGroup({
                            'name': FormControl<String>(value: data!.name),
                            'address': FormControl<String>(value: data.address),
                            'addressNote': FormControl<String>(
                                value: data.addressNote as String),
                            'publicTransportNote': FormControl<String>(
                                value: data.publicTransportNote as String),
                            'FreeParking': FormControl<bool>(
                                value: data.services!.contains('FreeParking')
                                    ? true
                                    : false),
                            'PaidParking': FormControl<bool>(
                                value: data.services!.contains('PaidParking')
                                    ? true
                                    : false),
                            'DisabledParking': FormControl<bool>(
                                value:
                                    data.services!.contains('DisabledParking')
                                        ? true
                                        : false),
                            'Elevator': FormControl<bool>(
                                value: data.services!.contains('Elevator')
                                    ? true
                                    : false),
                            'WaitingRoom': FormControl<bool>(
                                value: data.services!.contains('WaitingRoom')
                                    ? true
                                    : false),
                          });
                          return CustomDialogBox(
                            title: 'Modifica Sportello',
                            primaryButtonTitle: 'Salva',
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  height: 50,
                                  width: double.infinity,
                                  child: ReactiveForm(
                                    formGroup: form,
                                    child: ReactiveTextField(
                                        maxLines: 2,
                                        decoration: const InputDecoration(
                                          labelText: 'Denominazione',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        formControlName: 'name'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  // height: 150,
                                  width: double.infinity,
                                  child: CustomAutocomplete<PlaceSearch>(
                                    displayStringForOption:
                                        (PlaceSearch option) =>
                                            option.addressName,
                                    initialValue: TextEditingValue(
                                        text: form.value['address'] as String),
                                    optionsBuilder: (TextEditingValue
                                        textEditingValue) async {
                                      if (textEditingValue.text.length < 3) {
                                        return const Iterable<
                                            PlaceSearch>.empty();
                                      }

                                      List listObject =
                                          await Provider.of<ApiService>(context,
                                                  listen: false)
                                              .getAddressAutocomplete(
                                                  search:
                                                      textEditingValue.text);

                                      List<PlaceSearch> listAddress = listObject
                                          .map((object) =>
                                              PlaceSearch.fromJson(object))
                                          .toList();

                                      return listAddress;
                                    },
                                    onSelected: (PlaceSearch selection) {
                                      setState(() {
                                        form.control('address').value =
                                            selection.addressName;
                                        latitude = selection.point.latitude;
                                        longitude = selection.point.longitude;
                                      });
                                    },
                                  ),
                                ),
                                // Container(
                                //   margin: EdgeInsets.symmetric(
                                //       horizontal: 20, vertical: 10),
                                //   child: ReactiveForm(
                                //     formGroup: form,
                                //     child: ReactiveRawAutocomplete<String,
                                //         PlaceSearch>(
                                //       decoration: const InputDecoration(
                                //         labelText: 'Indirizzo',
                                //         border: OutlineInputBorder(
                                //           borderRadius: BorderRadius.all(
                                //             Radius.circular(10.0),
                                //           ),
                                //         ),
                                //       ),
                                //       formControlName: 'address',
                                //       validationMessages: (control) =>
                                //           {'required': 'Campo Obbligatorio'},
                                //       // options: _options,
                                //       optionsBuilder: (TextEditingValue
                                //           textEditingValue) async {
                                //         if (textEditingValue.text.length < 3) {
                                //           return [];
                                //         }

                                //         List listObject =
                                //             await Provider.of<ApiService>(
                                //                     context,
                                //                     listen: false)
                                //                 .getAddressAutocomplete(
                                //                     search:
                                //                         textEditingValue.text);

                                //         List<PlaceSearch> listAddress =
                                //             listObject
                                //                 .map((object) =>
                                //                     PlaceSearch.fromJson(
                                //                         object))
                                //                 .toList();

                                //         return listAddress;
                                //       },

                                //       optionsViewBuilder: (BuildContext context,
                                //           AutocompleteOnSelected<PlaceSearch>
                                //               onSelected,
                                //           Iterable<PlaceSearch> options) {
                                //         final List<PlaceSearch> option = options
                                //             .map((e) => PlaceSearch(
                                //                 city: e.city,
                                //                 addressName: e.addressName,
                                //                 point: e.point))
                                //             .toList();
                                //         return Align(
                                //           alignment: Alignment.topLeft,
                                //           child: Material(
                                //             elevation: 4.0,
                                //             child: SizedBox(
                                //               width: 400,
                                //               height: 100.0,
                                //               child: SingleChildScrollView(
                                //                 child: Column(
                                //                     children: option
                                //                         .map(
                                //                             (e) =>
                                //                                 GestureDetector(
                                //                                   onTap: () {
                                //                                     onSelected(PlaceSearch(
                                //                                         city: e
                                //                                             .city,
                                //                                         addressName: e
                                //                                             .addressName,
                                //                                         point: e
                                //                                             .point));
                                //                                     print(e
                                //                                         .point
                                //                                         .latitude);
                                //                                   },
                                //                                   child: ListTile(
                                //                                       title: Text(
                                //                                           e.addressName)),
                                //                                 ))
                                //                         .toList()),
                                //               ),
                                //             ),
                                //             // child: ListView.builder(
                                //             //   padding:
                                //             //       const EdgeInsets.all(8.0),
                                //             //   itemCount: options.length,
                                //             //   itemBuilder:
                                //             //       (BuildContext context,
                                //             //           int index) {

                                //             //     return GestureDetector(
                                //             //       // onTap: () {
                                //             //       //   onSelected(option);
                                //             //       //   print(option);
                                //             //       // },
                                //             //       child: ListTile(
                                //             //         title: Text(''),
                                //             //       ),
                                //             //     );
                                //             //   },
                                //             // ),
                                //           ),
                                //         );
                                //       },
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  height: 50,
                                  width: double.infinity,
                                  child: ReactiveForm(
                                    formGroup: form,
                                    child: ReactiveTextField(
                                        maxLines: 2,
                                        decoration: const InputDecoration(
                                          labelText: 'Note indirizzo',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        formControlName: 'addressNote'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  height: 50,
                                  width: double.infinity,
                                  child: ReactiveForm(
                                    formGroup: form,
                                    child: ReactiveTextField(
                                        maxLines: 2,
                                        decoration: const InputDecoration(
                                          labelText: 'Trasporto pubblico',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        formControlName: 'publicTransportNote'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ReactiveForm(
                                            formGroup: form,
                                            child: ReactiveCheckbox(
                                              activeColor: Colors.white,
                                              formControlName: 'FreeParking',
                                              checkColor: Colors.blue,
                                            ),
                                          ),
                                          Text('Parcheggio gratuito')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ReactiveForm(
                                            formGroup: form,
                                            child: ReactiveCheckbox(
                                              formControlName: 'PaidParking',
                                              activeColor: Colors.white,
                                              checkColor: Colors.blue,
                                            ),
                                          ),
                                          Text('Parcheggio a pagamento')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ReactiveForm(
                                            formGroup: form,
                                            child: ReactiveCheckbox(
                                              formControlName:
                                                  'DisabledParking',
                                              activeColor: Colors.white,
                                              checkColor: Colors.blue,
                                            ),
                                          ),
                                          Text('Parcheggio per disabili')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ReactiveForm(
                                            formGroup: form,
                                            child: ReactiveCheckbox(
                                              formControlName: 'Elevator',
                                              activeColor: Colors.white,
                                              checkColor: Colors.blue,
                                            ),
                                          ),
                                          Text('Ascensore')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ReactiveForm(
                                            formGroup: form,
                                            child: ReactiveCheckbox(
                                              formControlName: 'WaitingRoom',
                                              activeColor: Colors.white,
                                              checkColor: Colors.blue,
                                            ),
                                          ),
                                          Text('Sala interna')
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            primaryButtonDidTapHandler: () {
                              form.control('FreeParking').value == true
                                  ? service.add('FreeParking')
                                  : null;
                              form.control('PaidParking').value == true
                                  ? service.add('PaidParking')
                                  : null;
                              form.control('DisabledParking').value == true
                                  ? service.add('DisabledParking')
                                  : null;
                              form.control('Elevator').value == true
                                  ? service.add('Elevator')
                                  : null;
                              form.control('WaitingRoom').value == true
                                  ? service.add('WaitingRoom')
                                  : null;
                              putHelpDeskRefresh(
                                  PostHelpDesk(
                                    address: form.control('address').value,
                                    name: form.control('name').value,
                                    addressNote: form.control('name').value,
                                    publicTransportNote: form
                                        .control('publicTransportNote')
                                        .value,
                                    services: service,
                                    addressPoint: AddressPoint(
                                        latitude: latitude,
                                        longitude: longitude),
                                  ),
                                  _context,
                                  widget.id);
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  })
              : newValue == '1'
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDeleteDialogBox(
                          primaryButtonDidTapHandler: () {
                            delete(context, widget.id);
                          },
                          primaryButtonTitle: 'Conferma',
                          secondaryButtonTitle: 'Annulla',
                          title: 'Cancellazione slot',
                          child: Container(
                            margin: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Text(
                                  'Vuoi Eliminare il tipo Slot ${widget.name}?',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  : null;
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

  Future<HelpDeskById> deleteHelpdesk(BuildContext context, int id) async {
    final responseDelete = await Provider.of<ApiService>(context, listen: false)
        .deleteHelpDeskById(id);
    return responseDelete;
  }

  Future<HelpDeskById?> gethelpDeskById(BuildContext context, int id) async {
    final responseHelpDesk =
        await Provider.of<ApiService>(context, listen: false)
            .getHelpDeskById(id);

    final HelpDeskById item = HelpDeskById.fromJson(responseHelpDesk);

    return item;
  }

  Future putHelpDesk(BuildContext context, PostHelpDesk data, int id) async {
    final response = await Provider.of<ApiService>(context, listen: false)
        .putHelpDesk(id, data.toJson());

    if (response.item2 == 400) {
      print(response.item1!);
    }
  }

  void delete(BuildContext context, int id) async {
    await deleteHelpdesk(context, id);
    Provider.of<PageRefresh>(context, listen: false).refresh();
  }

  void putHelpDeskRefresh(
      PostHelpDesk data, BuildContext context, int id) async {
    await putHelpDesk(context, data, id);
    Provider.of<PageRefresh>(context, listen: false).refresh();
    Navigator.of(context).pop();
  }
}
