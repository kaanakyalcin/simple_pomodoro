import 'package:flutter/material.dart';
import 'package:simple_pomodoro/core/db/pomodoro_db.dart';
import 'package:simple_pomodoro/core/utils/theme.dart';
import 'package:simple_pomodoro/models/event.dart';
import 'package:simple_pomodoro/models/event_type.dart';

class ReportUI extends StatefulWidget {
  const ReportUI({super.key});

  @override
  State<ReportUI> createState() => _ReportUIState();
}

class _ReportUIState extends State<ReportUI> {
  List<EventType> types = [];
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    getTypes();
    getEvents();
  }

  Future getEvents() async {
    var _events = await PomodoroDatabase.instance.readAllEvents();
    setState(() {
      events = _events;
    });
  }

  Future getTypes() async {
    var _types = await PomodoroDatabase.instance.readAllTypes();
    setState(() {
      types = _types;
    });
  }

  final Color barBackgroundColor =
      CustomColor.contentColorWhite.withOpacity(0.3);
  final Color barColor = CustomColor.contentColorWhite;
  final Color touchedBarColor = CustomColor.contentColorGreen;

  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [Text('data')],
    ));
  }
}
