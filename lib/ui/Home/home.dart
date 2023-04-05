import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_pomodoro/core/db/pomodoro_db.dart';
import 'package:simple_pomodoro/core/utils/button_widget.dart';
import 'package:simple_pomodoro/core/utils/theme.dart';
import 'package:simple_pomodoro/models/event_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  int focusTime = 1;
  int breakTime = 1;
  int longBreakTime = 1;
  int remainingSeconds = 0;
  Timer? countDownTimer;
  late Duration pomodoroDuration = Duration(minutes: focusTime);

  List<EventType> types = [];

  int? _selectedChip = 0;

  @override
  void initState() {
    super.initState();
    setTimes();
    getTypes();
  }

  @override
  void dispose() {
    if (countDownTimer != null && countDownTimer!.isActive) {
      countDownTimer!.cancel();
    }
    super.dispose();
  }

  Future setTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      focusTime = prefs.getInt("key-focus") ?? 1;
      pomodoroDuration = Duration(minutes: focusTime);

      breakTime = prefs.getInt("key-short-break") ?? 1;
      longBreakTime = prefs.getInt("key-long-break") ?? 1;
    });
  }

  Future getTypes() async {
    var _types = await PomodoroDatabase.instance.readAllTypes();
    setState(() {
      types = _types;
    });
  }

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    countDownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() {
      countDownTimer!.cancel();
    });
  }

  void resetTimer() => setState(() {
        pomodoroDuration = Duration(minutes: focusTime);
      });

  void setCountDown() {
    const reduceSecondBy = 1;
    setState(() {
      final seconds = pomodoroDuration.inSeconds - reduceSecondBy;
      if (seconds < 0) {
        stopTimer(reset: false);
      } else {
        pomodoroDuration = Duration(seconds: seconds);
        if (seconds == 0) {
          HapticFeedback.vibrate();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(pomodoroDuration.inMinutes);
    final seconds = strDigits(pomodoroDuration.inSeconds.remainder(60));
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Choose a type'),
              const SizedBox(
                height: 5,
              ),
              Wrap(
                  spacing: 5,
                  children: List<Widget>.generate(types.length, (int index) {
                    return ChoiceChip(
                      selectedColor: Colors.greenAccent[400],
                      label: Text(types[index].name),
                      selected: _selectedChip == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedChip = selected ? index : 0;
                        });
                      },
                    );
                  }).toList()),
            ]),
      ),
      const SizedBox(height: 100),
      SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: 1 - pomodoroDuration.inSeconds / (focusTime * 60),
              backgroundColor: CustomColor.logoBlue,
              strokeWidth: 24,
              valueColor: const AlwaysStoppedAnimation(Colors.yellow),
            ),
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  minutes,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 80,
                      color: CustomColor.fontBlack),
                ),
                Text(
                  seconds,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: CustomColor.fontBlack),
                ),
              ],
            )),
          ],
        ),
      ),
      const SizedBox(
        height: 50,
      ),
      buildButtons()
    ]);
  }

  Widget buildButtons() {
    final isRunning = countDownTimer == null ? false : countDownTimer!.isActive;
    return isRunning
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ButtonWidget(
                text: 'Pause',
                onClicked: () {
                  stopTimer(reset: false);
                }),
            const SizedBox(
              width: 12,
            ),
            ButtonWidget(
                text: 'Cancel',
                onClicked: () {
                  stopTimer(reset: true);
                })
          ])
        : ButtonWidget(
            text: 'Start Timer!',
            onClicked: () {
              startTimer(reset: false);
            });
  }
}
