import 'package:es_2022_02_02_1/api_models/get/get_appointment_slot_type_model.dart';
import 'package:es_2022_02_02_1/api_models/get/get_helpDesk_model.dart';
import 'package:es_2022_02_02_1/api_models/get/get_place_search.dart';
import 'package:es_2022_02_02_1/api_models/get/get_user.dart';
import 'package:es_2022_02_02_1/api_models/post/post_appointment_slot_type.dart';
import 'package:es_2022_02_02_1/api_models/post/post_helpDesk_model.dart';
import 'package:es_2022_02_02_1/core/networking/provider/page_refresh.dart';
import 'package:es_2022_02_02_1/core/networking/services/api/api_service.dart';
import 'package:es_2022_02_02_1/core/routing/models/form_models.dart';
import 'package:es_2022_02_02_1/core/routing/models/page_configuration.dart';
import 'package:es_2022_02_02_1/core/routing/my_router_delegate.dart';
import 'package:es_2022_02_02_1/core/routing/pages.dart';
import 'package:es_2022_02_02_1/ui/screen/slot_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_raw_autocomplete/reactive_raw_autocomplete.dart';
import 'package:tuple/tuple.dart';
import '../automatic_child.dart';
import '../custom_autocomplete.dart';
import '../custom_delete_dialog.dart';
import '../custom_dialog.dart';

class AppointmentSlotTypeTable extends StatelessWidget {
  const AppointmentSlotTypeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageRefresh>(
      builder: (context, value, child) {
        return BuildAppointmentSlotTypeTable();
      },
    );
  }
}

class BuildAppointmentSlotTypeTable extends StatefulWidget {
  BuildAppointmentSlotTypeTable({Key? key}) : super(key: key);

  @override
  _BuildAppointmentSlotTypeTableState createState() =>
      _BuildAppointmentSlotTypeTableState();
}

class _BuildAppointmentSlotTypeTableState
    extends State<BuildAppointmentSlotTypeTable> {
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
                    return FutureBuilder<AppointmentSlotTypeList?>(
                      future: getAppointmentType(context),
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

  Future<AppointmentSlotTypeList?> getAppointmentType(
      BuildContext context) async {
    try {
      final responseHelpDesk =
          await Provider.of<ApiService>(context, listen: false)
              .getAppointmentSlotType();
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

  AppointmentSlotTypeList? cage;
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
      //DataCell(Text(cage!.items[index].address)),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomDropDown(
            id: cage!.items[index].id,
            name: cage!.items[index].name,
          )
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

  List<SlotDurationItem> service = [];
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
                    return FutureBuilder<AppointmentSlotTypeById?>(
                      future: getAppointmentSlotTypeById(context, widget.id),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final data = snapshot.data;
                          final form = FormGroup({
                            'name': FormControl<String>(
                                value: data!.name,
                                validators: [Validators.required]),
                            'payment': FormControl<bool>(value: data.payment),
                            'paymentReason': FormControl<String>(
                                value: data.paymentReason, disabled: true),
                            'duration': FormControl(
                                value: convertEnumDuration(data.duration)
                                    as String),

                            // 'address': FormControl<String>(),
                          });
                          service = [
                            SlotDurationItem(
                                duration: SlotDuration.quarterHour),
                            SlotDurationItem(duration: SlotDuration.halfHour),
                            SlotDurationItem(duration: SlotDuration.oneHour),
                            SlotDurationItem(duration: SlotDuration.twoHours)
                          ];

                          form.control('payment').statusChanged.listen((event) {
                            if (form.control('payment').value as bool) {
                              form.control('paymentReason').setValidators(
                                  [Validators.required],
                                  autoValidate: true);
                              form.control('paymentReason').markAsEnabled();
                            } else {
                              form.control('paymentReason').markAsDisabled();
                            }
                          });

                          return CustomDialogBox(
                            title: 'Modifica Tipo Slot',
                            primaryButtonTitle: 'Salva',
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  width: double.infinity,
                                  child: ReactiveForm(
                                    formGroup: form,
                                    child: ReactiveTextField(
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        labelText: 'Denominazione',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      formControlName: 'name',
                                      validationMessages: (control) =>
                                          {'required': 'Campo Obbligatorio'},
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: ReactiveForm(
                                    formGroup: form,
                                    child: ReactiveDropdownField<dynamic>(
                                      formControlName: 'duration',
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      hint: const Text('Durata'),
                                      items: service
                                          .map(
                                            (e) => DropdownMenuItem<String>(
                                              value: convertEnumDuration(
                                                  e.duration),
                                              child: Text(
                                                  convertEnumDuration(
                                                      e.duration),
                                                  style: const TextStyle(
                                                      fontSize: 18)),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    children: [
                                      ReactiveForm(
                                        formGroup: form,
                                        child: ReactiveSwitch(
                                          formControlName: 'payment',
                                          activeColor: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                                      ),
                                      Text(
                                        'Pagamento diritti',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  width: double.infinity,
                                  child: ReactiveForm(
                                    formGroup: form,
                                    child: ReactiveTextField(
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        labelText: 'Causale',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      formControlName: 'paymentReason',
                                      validationMessages: (control) =>
                                          {'required': 'Campo Obbligatorio'},
                                    ),
                                  ),
                                )
                              ],
                            ),
                            primaryButtonDidTapHandler: () {
                              putAppointmentSlotTypeRefresh(
                                  PostAppointmentSlotType(
                                    name: form.control('name').value,
                                    duration: convertStringEnum(
                                        form.control('duration').value),
                                    payment: form.control('payment').value,
                                    paymentReason:
                                        form.control('paymentReason').value,
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
                  // ? delete(context, widget.id)
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

  Future<AppointmentSlotTypeById?> getAppointmentSlotTypeById(
      BuildContext context, int id) async {
    final responseAppointmentSlotTypeById =
        await Provider.of<ApiService>(context, listen: false)
            .getAppointmentSlotTypeById(id);

    final AppointmentSlotTypeById item =
        AppointmentSlotTypeById.fromJson(responseAppointmentSlotTypeById);

    return item;
  }

  void delete(BuildContext context, int id) async {
    await deleteAppointmentSlotType(context, id);
    Provider.of<PageRefresh>(context, listen: false).refresh();
    Navigator.of(context).pop();
  }

  Future<AppointmentSlotTypeById> deleteAppointmentSlotType(
      BuildContext context, int id) async {
    final responseDelete = await Provider.of<ApiService>(context, listen: false)
        .deleteAppointmentSlotType(id);
    return responseDelete;
  }

  void putAppointmentSlotTypeRefresh(
      PostAppointmentSlotType data, BuildContext context, int id) async {
    await putAppointmentSlotType(context, data, id);
    Provider.of<PageRefresh>(context, listen: false).refresh();
    Navigator.of(context).pop();
  }

  Future putAppointmentSlotType(
      BuildContext context, PostAppointmentSlotType data, int id) async {
    final response = await Provider.of<ApiService>(context, listen: false)
        .putAppointmentSlotType(id, data.toJson());

    if (response.item2 == 400) {
      print(response.item1!);
    }
  }

  SlotDuration convertStringEnum(String type) {
    switch (type) {
      case '30 Minuti':
        return SlotDuration.halfHour;
      case '60 Minuti':
        return SlotDuration.oneHour;
      case '15 Minuti':
        return SlotDuration.quarterHour;
      case '120 Minuti':
        return SlotDuration.twoHours;
      default:
        return SlotDuration.oneHour;
    }
  }

  String convertEnumDuration(SlotDuration type) {
    switch (type) {
      case SlotDuration.halfHour:
        return '30 Minuti';
      case SlotDuration.oneHour:
        return '60 Minuti';
      case SlotDuration.quarterHour:
        return '15  Minuti';
      case SlotDuration.twoHours:
        return '120 Minuti';
      default:
        return 'Servizi';
    }
  }
}
