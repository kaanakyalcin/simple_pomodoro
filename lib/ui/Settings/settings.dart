import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

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
  static const keyType = 'key-type';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        SettingsGroup(title: 'UI', children: <Widget>[buildDarkMode()]),
        SettingsGroup(title: 'GENERAL', children: <Widget>[
          buildFocusTime(),
          buildShortBreakTime(),
          buildLongBreakTime()
        ])
      ],
    ));
  }

  Widget buildFocusTime() => DropDownSettingsTile(
        settingKey: keyFocus,
        title: 'Focus Time',
        selected: 20,
        values: const <int, String>{
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

  Widget buildType() => TextInputSettingsTile(
        settingKey: keyType,
        title: 'Add Type',
        obscureText: false,
      );
}
