import 'dart:async';

import 'package:es_2022_02_02_1/api_models/get/get_appointment_slot_type_model.dart';
import 'package:es_2022_02_02_1/api_models/post/post_appointment_slot_type.dart';
import 'package:es_2022_02_02_1/core/networking/provider/page_refresh.dart';
import 'package:es_2022_02_02_1/core/networking/services/api/api_service.dart';
import 'package:es_2022_02_02_1/ui/widgets/custom_dialog.dart';
import 'package:es_2022_02_02_1/ui/widgets/page_bar.dart';
import 'package:es_2022_02_02_1/ui/widgets/table/appointment_slot_type_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SlotTypeScreen extends StatefulWidget {
  SlotTypeScreen({Key? key}) : super(key: key);

  static final LocalKey keyPage = UniqueKey();

  @override
  State<SlotTypeScreen> createState() => _SlotTypeScreenState();
}

class _SlotTypeScreenState extends State<SlotTypeScreen> {
  List<SlotDurationItem> service = [];
  late FormGroup form;

  // final StreamController<ControlStatus> controller =
  //     StreamController<ControlStatus>();

  @override
  void initState() {
    service = [
      SlotDurationItem(duration: SlotDuration.quarterHour),
      SlotDurationItem(duration: SlotDuration.halfHour),
      SlotDurationItem(duration: SlotDuration.oneHour),
      SlotDurationItem(duration: SlotDuration.twoHours)
    ];
    form = FormGroup({
      'name': FormControl<String>(validators: [Validators.required]),
      'payment': FormControl<bool>(value: false),
      'paymentReason': FormControl<String>(disabled: true),
      'duration': FormControl(value: service),

      // 'address': FormControl<String>(),
    });

    form.control('payment').statusChanged.listen((event) {
      if (form.control('payment').value as bool) {
        form
            .control('paymentReason')
            .setValidators([Validators.required], autoValidate: true);
        form.control('paymentReason').markAsEnabled();
      } else {
        form.control('paymentReason').markAsDisabled();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PageBar(
            pageName: 'Tipo Slot',
            actioName: 'Nuovo tipo slot',
            primaryButtonDidTapHandler: () async {
              form.reset();

              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                      title: "Nuovo Sportello",
                      primaryButtonTitle: 'Salva',
                      secondaryButtonTitle: 'Annulla',
                      contextt: context,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            width: double.infinity,
                            child: ReactiveForm(
                              formGroup: this.form,
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
                                        value: convertEnumDuration(e.duration),
                                        child: Text(
                                            convertEnumDuration(e.duration),
                                            style:
                                                const TextStyle(fontSize: 18)),
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
                                  formGroup: this.form,
                                  child: ReactiveSwitch(
                                    formControlName: 'payment',
                                    activeColor:
                                        Theme.of(context).secondaryHeaderColor,
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
                              formGroup: this.form,
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
                        form.valid
                            ? postAppointmentSlotTypeRefresh(
                                context,
                                PostAppointmentSlotType(
                                  name: form.control('name').value,
                                  duration: convertStringEnum(
                                      form.control('duration').value),
                                  payment: form.control('payment').value,
                                  paymentReason:
                                      form.control('paymentReason').value,
                                ))
                            : form.markAllAsTouched();
                      },
                      secondaryButtonDidTapHandler: () {});
                },
              );
            },
          ),
          AppointmentSlotTypeTable(),
        ],
      ),
    ));
  }

  void postAppointmentSlotTypeRefresh(
    BuildContext context,
    PostAppointmentSlotType data,
  ) async {
    await postAppointmentSlotType(context, data);
    Provider.of<PageRefresh>(context, listen: false).refresh();
    Navigator.of(context).pop();
  }

  Future postAppointmentSlotType(
      BuildContext context, PostAppointmentSlotType data) async {
    final response = await Provider.of<ApiService>(context, listen: false)
        .postAppointmentSlotType(data.toJson());

    if (response.item2 == 400) {
      print(response.item1!);
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
}

class SlotDurationItem {
  SlotDuration duration;
  SlotDurationItem({
    required this.duration,
  });
}
