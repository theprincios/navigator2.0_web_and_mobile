import 'dart:collection';
import 'dart:html';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:es_2022_02_02_1/api_models/get/get_appointment_slot_model.dart';
import 'package:es_2022_02_02_1/api_models/get/get_appointment_slot_type_model.dart';
import 'package:es_2022_02_02_1/api_models/get/get_helpDesk_model.dart';
import 'package:es_2022_02_02_1/api_models/post/post_appointment_slot.dart';
import 'package:es_2022_02_02_1/core/networking/provider/page_refresh.dart';
import 'package:es_2022_02_02_1/core/networking/services/api/api_service.dart';
import 'package:es_2022_02_02_1/ui/widgets/custom_dialog.dart';
import 'package:es_2022_02_02_1/ui/widgets/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:table_calendar/table_calendar.dart';

import 'custom_delete_dialog.dart';

class SlotCalendar extends StatelessWidget {
  const SlotCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageRefresh>(
      builder: (context, value, child) {
        return BuildSlotCalendar();
      },
    );
  }
}

class BuildSlotCalendar extends StatefulWidget {
  const BuildSlotCalendar({Key? key}) : super(key: key);

  @override
  _BuildSlotCalendarState createState() => _BuildSlotCalendarState();
}

class _BuildSlotCalendarState extends State<BuildSlotCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  PageController? _pageController;
  DateTime? _selectedDay;
  bool timeIsAfter = true;
  late ValueNotifier<List<Card>> _selectedEvents = ValueNotifier([]);
  late LinkedHashMap<DateTime, List<Event>> kEvents;
  AppointmentSlotList? appointmentList;
  List<AppointmentTypeListShort> appointmentSlotType = [];
  List<HelpDeskListShort> helpdesklist = [];
  // List<Event> list = [];
  Map<DateTime, List<Event>> kEventSource = {
    // DateTime(2022, 03, 1): [Event('title')],
    // DateTime(2022, 03, 2): [Event('title')]
  };
  DateTime? daytime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    getAppointment().then((value) {
      setState(() {
        appointmentList = value;
      });
      _initialize();
    });
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

    super.initState();
  }

  void convertToevent(AppointmentSlotList data) {
    var raggruppamento = groupBy(
        data.items,
        (AppointmentSlot obj) => DateTime(
            obj.startDate.year, obj.startDate.month, obj.startDate.day));
    for (var element in raggruppamento.keys) {
      final pippo = raggruppamento[element]!
          .map((e) => Event(
              id: e.id,
              title: e.name,
              description: e.startDate.toString(),
              status: e.status))
          .toList();
      kEventSource.addAll({element: pippo});
    }
  }

  @override
  Widget build(BuildContext context) {
    var dataLayout = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 1),
            height: 500,
            width: dataLayout.size.width / 3,
            margin: EdgeInsets.all(20),
            child: FutureBuilder<AppointmentSlotList?>(
              future: getAppointment(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final events = snapshot.data;

                  convertToevent(events!);
                  //convertToevent(e)).toList();

                  List<Event> getEventsForDay(DateTime day) {
                    // Implementation example
                    return kEvents[day] ?? [];
                  }

                  kEvents = LinkedHashMap<DateTime, List<Event>>(
                    equals: isSameDay,
                    hashCode: getHashCode,
                  )..addAll(kEventSource);

                  kEventSource.forEach((e, value) {
                    if (DateTime(e.year, e.month, e.day).compareTo(DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day)) ==
                        0) {
                      // list.addAll(value);
                    }
                  });

                  return TableCalendar(
                    rowHeight: 60,
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                      todayBuilder: (context, date, events) => Container(
                          height: 500,
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).secondaryHeaderColor,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Settimana',
                      CalendarFormat.twoWeeks: 'Mese',
                      CalendarFormat.week: 'Due settimane',
                    },
                    eventLoader: getEventsForDay,
                    locale: 'it',
                    calendarFormat: _calendarFormat,
                    firstDay: DateTime(2021, 01, 01),
                    focusedDay: _focusedDay,
                    lastDay: DateTime(2022, 12, 31),
                    onCalendarCreated: (controller) =>
                        _pageController = controller,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onDaySelected: (date, focusedDay) {
                      setState(() {
                        //  list.clear();

                        daytime = focusedDay;
                      });

                      // kEventSource.forEach(
                      //   (e, value) {
                      //     if (DateTime(e.year, e.month, e.day).compareTo(
                      //             DateTime(date.year, date.month, date.day)) ==
                      //         0) {
                      //       // list.addAll(value);
                      //     }
                      //   },
                      // );
                      _selectedDay = date;
                      _focusedDay = focusedDay;
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;

                      print(focusedDay);
                    },
                    calendarStyle: CalendarStyle(
                        canMarkersOverflow: true,
                        todayDecoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        todayTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white),
                        markerSize: 10),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Container(
              //color: Colors.red,
              height: 500,
              width: dataLayout.size.width / 3,
              child: Container(
                  height: 500,
                  width: dataLayout.size.width / 3,
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Text(
                              'Slot del Giorno ${formatDate((daytime!), [
                                    dd,
                                    '-',
                                    mm,
                                    '-',
                                    yyyy
                                  ])}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[500]),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: FutureBuilder<AppointmentSlotList?>(
                            future: getAppointmentDate(
                                dateStart: daytime,
                                dateEnd: daytime!.add(Duration(days: 1))),
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasData) {
                                final date = snapshot.data;
                                return date!.items.length > 0
                                    ? ListView.builder(
                                        itemCount: date.items.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ListTile(
                                                  leading: date.items[index]
                                                              .status ==
                                                          Status.free
                                                      ? const Icon(
                                                          Icons.album,
                                                          color: Colors.green,
                                                        )
                                                      : const Icon(
                                                          Icons.album,
                                                          color: Colors.red,
                                                        ),
                                                  title: Text(
                                                      date.items[index].name),
                                                  subtitle: Text(date
                                                      .items[index].startDate
                                                      .toString()),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    TextButton(
                                                      child: const Text(
                                                          'Modifica'),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return FutureBuilder<
                                                                  AppointmentSlotById?>(
                                                                future: getAppointmentById(
                                                                    context,
                                                                    date
                                                                        .items[
                                                                            index]
                                                                        .id),
                                                                builder: (BuildContext
                                                                        context,
                                                                    snapshot) {
                                                                  final appointment =
                                                                      snapshot
                                                                          .data;

                                                                  if (snapshot.connectionState ==
                                                                          ConnectionState
                                                                              .done &&
                                                                      snapshot
                                                                          .hasData) {
                                                                    final form =
                                                                        FormGroup({
                                                                      'appointmentSlotType': FormControl<
                                                                              String>(
                                                                          value: appointment!
                                                                              .appointmentSlotTypeId
                                                                              .toString(),
                                                                          validators: [
                                                                            Validators.required
                                                                          ]),
                                                                      'helpDesk': FormControl<
                                                                              String>(
                                                                          value: appointment
                                                                              .helpDeskId
                                                                              .toString(),
                                                                          validators: [
                                                                            Validators.required
                                                                          ]),
                                                                      'date': FormControl<
                                                                              DateTime>(
                                                                          value:
                                                                              appointment.startDate,
                                                                          validators: [
                                                                            Validators.required
                                                                          ]),
                                                                      'ripetitions': FormControl<
                                                                              int>(
                                                                          value:
                                                                              appointment.ripetitions),
                                                                      'note': FormControl<
                                                                              String>(
                                                                          value:
                                                                              appointment.note),
                                                                      'onsite': FormControl<
                                                                              bool>(
                                                                          value: appointment.meetingType == 'Onsite'
                                                                              ? true
                                                                              : false),
                                                                      'remote': FormControl<
                                                                              bool>(
                                                                          value: appointment.meetingType == 'Remote'
                                                                              ? true
                                                                              : false),
                                                                    });

                                                                    form
                                                                        .control(
                                                                            'onsite')
                                                                        .statusChanged
                                                                        .listen(
                                                                            (event) {
                                                                      if (form
                                                                          .control(
                                                                              'onsite')
                                                                          .value as bool) {
                                                                        form.control('remote').value =
                                                                            false;
                                                                      } else if (form
                                                                              .control('onsite')
                                                                              .value as bool ==
                                                                          false) {
                                                                        form.control('remote').value =
                                                                            true;
                                                                      }
                                                                    });

                                                                    form
                                                                        .control(
                                                                            'remote')
                                                                        .statusChanged
                                                                        .listen(
                                                                            (event) {
                                                                      if (form
                                                                          .control(
                                                                              'remote')
                                                                          .value as bool) {
                                                                        form.control('onsite').value =
                                                                            false;
                                                                      } else if (form
                                                                              .control('remote')
                                                                              .value as bool ==
                                                                          false) {
                                                                        form.control('onsite').value =
                                                                            true;
                                                                      }
                                                                    });

                                                                    return CustomDialogBox(
                                                                      title:
                                                                          'Modifica Slot',
                                                                      primaryButtonTitle:
                                                                          'Salva',
                                                                      child: Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                                                                          child: Text(e.name!, style: const TextStyle(fontSize: 18)),
                                                                                        ),
                                                                                      )
                                                                                      .toList(),
                                                                                  validationMessages: (control) => {
                                                                                    'required': 'Campo Obbligatorio'
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                                                                          child: Text(e.name!, style: const TextStyle(fontSize: 18)),
                                                                                        ),
                                                                                      )
                                                                                      .toList(),
                                                                                  validationMessages: (control) => {
                                                                                    'required': 'Campo Obbligatorio'
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: const EdgeInsets.only(
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
                                                                                  timePickerEntryMode: TimePickerEntryMode.input,
                                                                                  cancelText: 'Cancella',
                                                                                  confirmText: 'Seleziona',
                                                                                  locale: Locale('it'),
                                                                                  validationMessages: (control) => {
                                                                                    'required': 'Campo Obbligatorio'
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                              child: ReactiveForm(
                                                                                formGroup: form,
                                                                                child: ReactiveForm(
                                                                                  formGroup: form,
                                                                                  child: ReactiveTextField<int>(
                                                                                    maxLines: 1,
                                                                                    decoration: const InputDecoration(
                                                                                      labelText: 'Numero di ripetizioni da data e ora inizio ',
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.all(
                                                                                          Radius.circular(10.0),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    formControlName: 'ripetitions',
                                                                                    validationMessages: (control) => {
                                                                                      'required': 'Campo Obbligatorio'
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                              child: ReactiveForm(
                                                                                formGroup: form,
                                                                                child: ReactiveForm(
                                                                                  formGroup: form,
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
                                                                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                                  child: Text(
                                                                                    'Tipo appuntamento',
                                                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Container(
                                                                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                                                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                                                                      primaryButtonDidTapHandler:
                                                                          () {
                                                                        print(form
                                                                            .control('appointmentSlotType')
                                                                            .value);
                                                                        form.valid
                                                                            ? putAppointmentSlotRefresh(
                                                                                date.items[index].id,
                                                                                PostAppointmentSlot(smartPaUserId: appointment.smartPaUserId, startDate: form.control('date').value, meetingType: form.control('onsite').value == true ? 'Onsite' : 'Remote', appointmentSlotTypeId: form.control('appointmentSlotType').value as String, helpDeskId: form.control('helpDesk').value as String, ripetitions: form.control('ripetitions').value as int, note: form.control('note').value, status: Status.free),
                                                                                context)
                                                                            : form.markAllAsTouched();
                                                                      },
                                                                    );
                                                                  }
                                                                  return const Center(
                                                                      child:
                                                                          CircularProgressIndicator());
                                                                },
                                                              );
                                                            });
                                                      },
                                                    ),
                                                    const SizedBox(width: 8),
                                                    TextButton(
                                                      child:
                                                          const Text('Elimina'),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return CustomDeleteDialogBox(
                                                                primaryButtonDidTapHandler:
                                                                    () {
                                                                  delete(
                                                                      context,
                                                                      date
                                                                          .items[
                                                                              index]
                                                                          .id);
                                                                },
                                                                primaryButtonTitle:
                                                                    'Conferma',
                                                                secondaryButtonTitle:
                                                                    'Annulla',
                                                                title:
                                                                    'Cancellazione slot',
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(20),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        'Vuoi Eliminare lo slot ${date.items[index].name}?',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                18),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                    ),
                                                    const SizedBox(width: 8),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        child: Center(
                                          child:
                                              Text('Non hai slot programmati'),
                                        ),
                                      );
                              }

                              return Center(child: CircularProgressIndicator());
                            }),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

  void _initialize() {
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<AppointmentSlotList?> getAppointment({DateTime? dateStart}) async {
    final responseHelpDesk =
        await Provider.of<ApiService>(context, listen: false)
            .getAppointment(queryParameters: {
      'StartDateFrom': dateStart,
    });

    return responseHelpDesk.item2;
  }

  Future<AppointmentSlotList?> getAppointmentDate(
      {DateTime? dateStart, DateTime? dateEnd}) async {
    final responseHelpDesk =
        await Provider.of<ApiService>(context, listen: false).getAppointment(
            queryParameters: {
          'StartDateFrom': dateStart,
          'StartDateTo': dateEnd
        });

    return responseHelpDesk.item2;
  }

  Future<AppointmentSlotById?> getAppointmentById(
      BuildContext context, int id) async {
    try {
      final responseAppointmentSlotById =
          await Provider.of<ApiService>(context, listen: false)
              .getAppointmentById(id);

      final AppointmentSlotById item =
          AppointmentSlotById.fromJson(responseAppointmentSlotById);

      return item;
    } catch (e) {
      print(e);
    }
  }

  Future<AppointmentSlot> deleteAppointment(
      BuildContext context, int id) async {
    final responseDelete = await Provider.of<ApiService>(context, listen: false)
        .deleteAppointment(id);
    return responseDelete;
  }

  void delete(BuildContext context, int id) async {
    await deleteAppointment(context, id);
    Provider.of<PageRefresh>(context, listen: false).refresh();
  }

  void putAppointmentSlotRefresh(
    int id,
    PostAppointmentSlot data,
    BuildContext context,
  ) async {
    await putAppointment(id, data);
    //list.clear;
    Provider.of<PageRefresh>(context, listen: false).refresh();
    Navigator.of(context).pop();
  }

  Future putAppointment(int id, PostAppointmentSlot data) async {
    final response = await Provider.of<ApiService>(context, listen: false)
        .putAppointment(id, data.toJson());

    if (response.item2 == 400) {
      print(response.item1!);
    }
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
      return [];
    }
  }
}
