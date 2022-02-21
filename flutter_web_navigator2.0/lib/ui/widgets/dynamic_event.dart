import 'dart:collection';

import 'package:es_2022_02_02_1/ui/widgets/events.dart';
import 'package:es_2022_02_02_1/ui/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DynamicEvent extends StatefulWidget {
  @override
  _DynamicEvent createState() => _DynamicEvent();
}

class _DynamicEvent extends State<DynamicEvent> {
  late final PageController _pageController;
  late final ValueNotifier<List<Event>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDays.add(_focusedDay.value);
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  bool get canClearSelection =>
      _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getEventsForDays(days);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }

      _focusedDay.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _focusedDay.value = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDays.clear();
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dataLayout = MediaQuery.of(context);

    bool selected = true;

    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                width: Responsive.isDesktop(context)
                    ? _selectedEvents.value.length != 0
                        ? dataLayout.size.width / 2
                        : 1100
                    : 0,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ValueListenableBuilder<DateTime>(
                        valueListenable: _focusedDay,
                        builder: (context, value, _) {
                          return _CalendarHeader(
                            focusedDay: value,
                            clearButtonVisible: canClearSelection,
                            onTodayButtonTap: () {
                              setState(
                                  () => _focusedDay.value = DateTime.now());
                            },
                            onClearButtonTap: () {
                              setState(() {
                                _rangeStart = null;
                                _rangeEnd = null;
                                _selectedDays.clear();
                                _selectedEvents.value = [];
                              });
                            },
                            onLeftArrowTap: () {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            onRightArrowTap: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    TableCalendar<Event>(
                      rowHeight: 80,
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _focusedDay.value,
                      headerVisible: false,
                      selectedDayPredicate: (day) =>
                          _selectedDays.contains(day),
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      calendarFormat: _calendarFormat,
                      rangeSelectionMode: _rangeSelectionMode,
                      eventLoader: _getEventsForDay,
                      holidayPredicate: (day) {
                        // Every 20th day of the month will be treated as a holiday
                        return day.day == 20;
                      },
                      onDaySelected: _onDaySelected,
                      onRangeSelected: _onRangeSelected,
                      onCalendarCreated: (controller) =>
                          _pageController = controller,
                      onPageChanged: (focusedDay) =>
                          _focusedDay.value = focusedDay,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() => _calendarFormat = format);
                        }
                      },
                      calendarStyle: CalendarStyle(
                        // Weekend dates color (Sat & Sun Column)
                        weekendTextStyle: TextStyle(color: Colors.red),
                        // highlighted color for today
                        todayDecoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          shape: BoxShape.rectangle,
                        ),
                        // highlighted color for selected day
                        selectedDecoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                  width: Responsive.isDesktop(context)
                      ? _selectedEvents.value.length != 0
                          ? dataLayout.size.width
                          : 0
                      : 0,
                  margin: EdgeInsets.all(20),
                  duration: Duration(seconds: 1),
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () => print('${value[index]}'),
                              title: Text('${value[index]}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: TextStyle(fontSize: 26.0),
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          if (clearButtonVisible)
            IconButton(
              icon: Icon(Icons.clear, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
            ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
