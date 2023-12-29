import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';

class CountdownTimerComponent extends StatefulWidget {

  final DateTime targetDate;

  const CountdownTimerComponent({super.key, required this.targetDate});

  @override
  _CountdownTimerComponentState createState() {
    return _CountdownTimerComponentState();
  }
}

class _CountdownTimerComponentState extends State<CountdownTimerComponent> {
  late CountdownTimerController controller;

  @override
  void initState() {
    super.initState();

    controller = CountdownTimerController(endTime: widget.targetDate.millisecondsSinceEpoch, onEnd: onEnd);
  }

  void onEnd() {
    print('onEnd');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CountdownTimer(
            textStyle: const TextStyle(
              fontSize: 30,
              color: Colors.red,
            ),
            onEnd: onEnd,
            endTime: widget.targetDate.millisecondsSinceEpoch,
          ),
        ],
      ),
    );
  }

  String calculateYearsRemaining(int milliseconds) {
    DateTime targetDate = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    DateTime now = DateTime.now();
    Duration difference = targetDate.difference(now);

    double averageDaysPerYear = 365;

    int yearsRemaining = (difference.inDays / averageDaysPerYear).floor();

    return '$yearsRemaining années';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}