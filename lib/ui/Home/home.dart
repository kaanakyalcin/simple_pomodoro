import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simple_pomodoro/core/db/pomodoro_db.dart';
import 'package:simple_pomodoro/core/utils/button_widget.dart';
import 'package:simple_pomodoro/core/utils/theme.dart';
import 'package:simple_pomodoro/models/event_type.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  static int pomodoroTime = 2;
  int remainingSeconds = 0;
  Timer? countDownTimer;
  Duration pomodoroDuration = Duration(minutes: pomodoroTime);

  List<EventType> types = [];

  @override
  void initState() {
    super.initState();
    getTypes();
  }

  Future getTypes() async {
    types = await PomodoroDatabase.instance.readAllTypes();
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
        pomodoroDuration = Duration(minutes: pomodoroTime);
      });

  void setCountDown() {
    const reduceSecondBy = 1;
    setState(() {
      final seconds = pomodoroDuration.inSeconds - reduceSecondBy;
      if (seconds < 0) {
        stopTimer(reset: false);
      } else {
        pomodoroDuration = Duration(seconds: seconds);
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
        child: GestureDetector(
          onTap: () {
            const snackBar = SnackBar(content: Text('Tap'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Wrap(
            children: [
              for (var item in types)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Text(item.name),
                  ),
                )
            ],
          ),
        ),
      ),
      const SizedBox(height: 100),
      SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: 1 - pomodoroDuration.inSeconds / (pomodoroTime * 60),
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
