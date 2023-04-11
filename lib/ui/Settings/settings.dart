import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:simple_pomodoro/core/db/pomodoro_db.dart';
import 'package:simple_pomodoro/core/utils/button_widget.dart';
import 'package:simple_pomodoro/models/event_type.dart';

class SettingsUI extends StatefulWidget {
  const SettingsUI({super.key});

  @override
  State<SettingsUI> createState() => _SettingsUIState();
}

class _SettingsUIState extends State<SettingsUI> {
  static const keyDarkMode = 'key-dark-mode';
  static const keyFocus = 'key-focus';
  static const keyShortBreak = 'key-short-break';
  static const keyLongBreak = 'key-long-break';
  static const keyAlarmType = 'key-alarm-type';
  static const keyVibrationType = 'key-vibration-type';
  List<EventType> types = [];

  TextEditingController _textEditingController = TextEditingController();

  int? _selectedChip = -1;

  @override
  void initState() {
    super.initState();
    getTypes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getTypes() async {
    var _types = await PomodoroDatabase.instance.readAllTypes();
    setState(() {
      types = _types;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        SettingsGroup(title: 'DARK MODE', children: <Widget>[buildDarkMode()]),
        SettingsGroup(title: 'GENERAL', children: <Widget>[
          buildFocusTime(),
          buildShortBreakTime(),
          buildLongBreakTime()
        ]),
        SettingsGroup(
            title: 'Notification',
            children: <Widget>[buildAlarmType(), buildVibrationType()]),
        SettingsGroup(title: 'TYPES', children: <Widget>[buildTypes()]),
      ],
    ));
  }

  Widget buildTypes() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Wrap(
          spacing: 5,
          children: List<Widget>.generate(types.length, (int index) {
            return ChoiceChip(
              selectedColor: Colors.greenAccent[400],
              label: Text(types[index].name),
              selected: _selectedChip == index,
              onSelected: (bool selected) {
                if (types[index].deletable) {
                  _deleteDialogBuilder(context, types[index].id!);
                }
                setState(() {
                  _selectedChip = selected ? index : -1;
                });
              },
            );
          }).toList()),
      const SizedBox(
        height: 10,
      ),
      ButtonWidget(
          text: 'Add Type',
          onClicked: () {
            _insertDialogBuilder(context);
          })
    ]);
  }

  Future<void> _insertDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Type'),
          content: TextFormField(
            controller: _textEditingController,
            maxLength: 10,
            decoration: const InputDecoration(
              suffixIcon: Icon(
                Icons.check_circle,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF642ef3)),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Add'),
              onPressed: () async {
                await PomodoroDatabase.instance
                    .addNewType(_textEditingController.text);
                setState(() {
                  getTypes();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDialogBuilder(BuildContext context, int id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Type'),
          content: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Delete'),
              onPressed: () async {
                await PomodoroDatabase.instance.deleteType(id);
                setState(() {
                  getTypes();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildFocusTime() => DropDownSettingsTile(
        settingKey: keyFocus,
        title: 'Focus Time',
        selected: 20,
        values: const <int, String>{
          1: '1 min',
          10: '10 min',
          20: '20 min',
          30: '30 min',
          40: '40 min',
          50: '50 min',
          60: '60 min'
        },
        onChange: (focus) {},
      );

  Widget buildShortBreakTime() => DropDownSettingsTile(
        settingKey: keyShortBreak,
        title: 'Short Break Time',
        selected: 5,
        values: const <int, String>{
          1: '1 min',
          2: '2 min',
          3: '3 min',
          4: '4 min',
          5: '5 min',
          6: '6 min',
          7: '7 min',
          8: '8 min',
          9: '9 min',
          10: '10 min'
        },
        onChange: (shortBreak) {},
      );

  Widget buildLongBreakTime() => DropDownSettingsTile(
        settingKey: keyLongBreak,
        title: 'Long Break Time',
        selected: 5,
        values: const <int, String>{
          5: '5 min',
          10: '10 min',
          15: '15 min',
          20: '20 min',
          25: '25 min',
          30: '30 min'
        },
        onChange: (longBreak) {},
      );

  Widget buildDarkMode() => SwitchSettingsTile(
        title: 'Dark Mode',
        settingKey: keyDarkMode,
        leading: const Icon(
          Icons.dark_mode,
          color: Color(0xFF642ef3),
        ),
        onChange: (isDarkMode) {},
      );

  Widget buildAlarmType() => DropDownSettingsTile(
        settingKey: keyAlarmType,
        title: 'Alarm Type',
        selected: 1,
        values: const <int, String>{1: 'Off', 2: '2', 3: '3'},
        onChange: (alarmType) {},
      );

  Widget buildVibrationType() => DropDownSettingsTile(
        settingKey: keyVibrationType,
        title: 'Vibration Type',
        selected: 1,
        values: const <int, String>{1: 'Off', 2: '2', 3: '3'},
        onChange: (vibrationType) {},
      );
}
