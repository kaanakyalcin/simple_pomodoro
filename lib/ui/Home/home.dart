import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simple_pomodoro/core/db/pomodoro_db.dart';
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

  late List<EventType> types;

  @override
  void initState() {
    startTimer();
    super.initState();

    getTypes();
  }

  Future getTypes() async {
    types = await PomodoroDatabase.instance.readAllTypes();
    int x = 0;
  }

  void startTimer() {
    countDownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondBy = 1;
    setState(() {
      final seconds = pomodoroDuration.inSeconds - reduceSecondBy;
      if (seconds < 0) {
        countDownTimer!.cancel();
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
      ListView.builder(
        shrinkWrap: true,
        itemCount: types.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.list),
            title: Text(types[index].name),
          );
        },
      ),
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
    ]);
  }

  Widget buildCard() => Container(
        width: 100,
        height: 200,
        color: Colors.red,
      );
}
