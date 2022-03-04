import 'dart:developer';

import 'package:es_2022_02_02_1/api_models/get/get_appointment_slot_model.dart';
import 'package:es_2022_02_02_1/api_models/get/get_appointment_slot_type_model.dart';
import 'package:es_2022_02_02_1/api_models/get/get_helpDesk_model.dart';
import 'package:es_2022_02_02_1/api_models/post/post_appointment_slot.dart';
import 'package:es_2022_02_02_1/core/networking/provider/page_refresh.dart';
import 'package:es_2022_02_02_1/core/networking/services/api/api_service.dart';
import 'package:es_2022_02_02_1/core/routing/models/page_configuration.dart';
import 'package:es_2022_02_02_1/core/routing/my_router_delegate.dart';
import 'package:es_2022_02_02_1/core/routing/pages.dart';
import 'package:es_2022_02_02_1/secure_storage/entitys/user_logged_service.dart';
import 'package:es_2022_02_02_1/ui/widgets/calendar_slot.dart';
import 'package:es_2022_02_02_1/ui/widgets/custom_dialog.dart';
import 'package:es_2022_02_02_1/ui/widgets/page_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SlotManagementScreen extends StatefulWidget {
  const SlotManagementScreen({Key? key}) : super(key: key);

  static final LocalKey keyPage = UniqueKey();

  @override
  State<SlotManagementScreen> createState() => _SlotManagementScreenState();
}

class _SlotManagementScreenState extends State<SlotManagementScreen> {
  late FormGroup form;
  List<AppointmentTypeListShort> appointmentSlotType = [];
  List<HelpDeskListShort> helpdesklist = [];
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    getAppointmentTypeListShort().then((value) {
      setState(() {
        appointmentSlotType = value;
      });
    });
    getHelpDeskListShort().then((value) {
      setState(() {
        helpdesklist = value;
      });
    });

    form = FormGroup({
      'appointmentSlotType':
          FormControl<String>(validators: [Validators.required]),
      'helpDesk': FormControl<String>(validators: [Validators.required]),
      'date': FormControl<DateTime>(validators: [Validators.required]),
      'ripetitions': FormControl<int>(),
      'note': FormControl<String>(),
      'onsite': FormControl<bool>(value: true),
      'remote': FormControl<bool>(),
    });

    form.control('onsite').statusChanged.listen((event) {
      if (form.control('onsite').value as bool) {
        form.control('remote').value = false;
      } else if (form.control('onsite').value as bool == false) {
        form.control('remote').value = true;
      }
    });
    form.control('remote').statusChanged.listen((event) {
      if (form.control('remote').value as bool) {
        form.control('onsite').value = false;
      } else if (form.control('remote').value as bool == false) {
        form.control('onsite').value = true;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dataLayout = MediaQuery.of(context);

    // ignore: prefer_const_constructors
    return Builder(builder: (_context) {
      return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                PageBar(
                  actioName: 'Nuovo Slot',
                  pageName: 'Gestione Slot',
                  primaryButtonDidTapHandler: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: "Nuovo Sportello",
                          primaryButtonTitle: 'Salva',
                          secondaryButtonTitle: 'Annulla',
                          secondaryButtonDidTapHandler: () {},
                          child: Column(children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: ReactiveForm(
                                formGroup: form,
                                child: ReactiveDropdownField<dynamic>(
                                  formControlName: 'appointmentSlotType',
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  hint: const Text('Tipo Slot'),
                                  items: appointmentSlotType
                                      .map(
                                        (e) => DropdownMenuItem<String>(
                                          value: e.id.toString(),
                                          child: Text(e.name!,
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                        ),
                                      )
                                      .toList(),
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
                                  formControlName: 'helpDesk',
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  hint: const Text('Sportello'),
                                  items: helpdesklist
                                      .map(
                                        (e) => DropdownMenuItem<String>(
                                          value: e.id.toString(),
                                          child: Text(e.name!,
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                        ),
                                      )
                                      .toList(),
                                  validationMessages: (control) =>
                                      {'required': 'Campo Obbligatorio'},
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 10,
                              ),
                              child: ReactiveForm(
                                formGroup: form,
                                child: ReactiveDateTimePicker(
                                  formControlName: 'date',
                                  type: ReactiveDatePickerFieldType.dateTime,
                                  decoration: const InputDecoration(
                                    labelText: 'Data e ora',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    helperText: '',
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  timePickerEntryMode:
                                      TimePickerEntryMode.input,
                                  cancelText: 'Cancella',
                                  confirmText: 'Seleziona',
                                  locale: Locale('it'),
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
                                child: ReactiveForm(
                                  formGroup: form,
                                  child: ReactiveTextField<int>(
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Numero di ripetizioni da data e ora inizio ',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    formControlName: 'ripetitions',
                                    validationMessages: (control) =>
                                        {'required': 'Campo Obbligatorio'},
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: ReactiveForm(
                                formGroup: form,
                                child: ReactiveForm(
                                  formGroup: this.form,
                                  child: ReactiveTextField(
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      labelText: 'Note',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    formControlName: 'note',
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    'Tipo appuntamento',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[500]),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  ReactiveForm(
                                    formGroup: form,
                                    child: ReactiveCheckbox(
                                      activeColor: Colors.white,
                                      formControlName: 'onsite',
                                      checkColor: Colors.blue,
                                    ),
                                  ),
                                  Text('On-Site')
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              child: Row(
                                children: [
                                  ReactiveForm(
                                    formGroup: form,
                                    child: ReactiveCheckbox(
                                      activeColor: Colors.white,
                                      formControlName: 'remote',
                                      checkColor: Colors.blue,
                                    ),
                                  ),
                                  Text('Remoto')
                                ],
                              ),
                            ),
                          ]),
                          primaryButtonDidTapHandler: () async {
                            final user =
                                await UserLoggedService.service.userLogged;
                            form.valid
                                ? postAppointmentSlotRefresh(
                                    PostAppointmentSlot(
                                        smartPaUserId: user!.id,
                                        startDate: form.control('date').value,
                                        meetingType:
                                            form.control('onsite').value == true
                                                ? 'Onsite'
                                                : 'Remote',
                                        appointmentSlotTypeId: form
                                            .control('appointmentSlotType')
                                            .value as String,
                                        helpDeskId: form
                                            .control('helpDesk')
                                            .value as String,
                                        ripetitions: form
                                            .control('ripetitions')
                                            .value as int,
                                        note: form.control('note').value,
                                        status: Status.free),
                                    _context)
                                : form.markAllAsTouched();
                          },
                        );
                      },
                    );
                    form.reset();
                  },
                ),
                SlotCalendar()
              ],
            ),
          ));
    });
  }

  Future<List<AppointmentTypeListShort>> getAppointmentTypeListShort() async {
    try {
      final List responseAppointment =
          await Provider.of<ApiService>(context, listen: false)
              .getAppointmentTypeListShort();

      final response = responseAppointment
          .map((item) => AppointmentTypeListShort.fromJson(item))
          .toList();

      if (responseAppointment == null) {
        throw new Exception('errore get ');
      }
      return response;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<HelpDeskListShort>> getHelpDeskListShort() async {
    try {
      final List responsehelpDesk =
          await Provider.of<ApiService>(context, listen: false)
              .getHelpDeskListShort();

      final response = responsehelpDesk
          .map((item) => HelpDeskListShort.fromJson(item))
          .toList();

      if (responsehelpDesk == null) {
        throw new Exception('errore get ');
      }
      return response;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  void postAppointmentSlotRefresh(
    PostAppointmentSlot data,
    BuildContext context,
  ) async {
    await postAppointment(data);
    Provider.of<PageRefresh>(context, listen: false).refresh();
    Navigator.of(context).pop();
  }

  Future postAppointment(PostAppointmentSlot data) async {
    final response = await Provider.of<ApiService>(context, listen: false)
        .postAppointment(data.toJson());

    if (response.item2 == 400) {
      print(response.item1!);
    }
  }
}
