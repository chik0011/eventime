import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';

class CountdownTimerComponent extends StatefulWidget {

  final DateTime targetDate;

  CountdownTimerComponent({super.key, required this.targetDate});

  @override
  _CountdownTimerComponentState createState() {
    return _CountdownTimerComponentState();
  }
}

class _CountdownTimerComponentState extends State<CountdownTimerComponent> {
  late CountdownTimerController controller;

  late int latestYear;
  late int latestEventTime;

  bool isControllerDisposed = false;

  @override
  void initState() {
    super.initState();

    int latestYearMilliseconds = calculateYearsRemaining(widget.targetDate.millisecondsSinceEpoch);
    latestEventTime = widget.targetDate.millisecondsSinceEpoch - latestYearMilliseconds;

    controller = CountdownTimerController(endTime: latestEventTime, onEnd: onEnd);
  }

  @override
  void didUpdateWidget(covariant CountdownTimerComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Create new controller with date updated
    int latestYearMilliseconds = calculateYearsRemaining(widget.targetDate.millisecondsSinceEpoch);
    latestEventTime = widget.targetDate.millisecondsSinceEpoch - latestYearMilliseconds;

    controller = CountdownTimerController(endTime: latestEventTime, onEnd: onEnd);
  }

  void onEnd() {
    print('onEnd');
  }

  @override
  Widget build(BuildContext context) {

    TextStyle styleTime = const TextStyle(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 21,
      fontWeight: FontWeight.w500
    );

    TextStyle styleSpan = const TextStyle(
      color: Color(0xFF888888),
      decoration: TextDecoration.none,
      fontSize: 8,
      fontWeight: FontWeight.w300
    );

    return CountdownTimer(
      controller: controller,
      widgetBuilder: (BuildContext context, CurrentRemainingTime? time) {
        if (time == null) {
          return const Text('Terminé', style: TextStyle(color: Colors.white),);
        }
        List<Widget> list = [];

        if (latestYear > 0) {
          list.add(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(latestYear.toString(), style: styleTime),
              const SizedBox(height: 5),
              Text("ANS".toString(), style: styleSpan),
            ],
          ));
        }

        if (latestYear > 0) {
          list.add(const SizedBox(
            height: 40,
            child: VerticalDivider(
              color: Color(0xFF191919),
              thickness: 1,
            ),
          ));
        }

        if (time.days != null) {
          list.add(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(time.days.toString(), style: styleTime),
              const SizedBox(height: 5),
              Text("JOURS".toString(), style: styleSpan),
            ],
          ));
        }

        if (time.days != null) {
          list.add(const SizedBox(
            height: 40,
            child: VerticalDivider(
              color: Color(0xFF191919),
              thickness: 1,
            ),
          ));
        }

        if (time.hours != null) {
          list.add(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(time.hours.toString(), style: styleTime),
              const SizedBox(height: 5),
              Text("HEURES".toString(), style: styleSpan),
            ],
          ));
        }

        if (time.hours != null) {
          list.add(const SizedBox(
            height: 40,
            child: VerticalDivider(
              color: Color(0xFF191919),
              thickness: 1,
            ),
          ));
        }

        if (time.min != null) {
          list.add(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(time.min.toString(), style: styleTime),
              const SizedBox(height: 5),
              Text("MINUTES".toString(), style: styleSpan),
            ],
          ));
        }

        if (time.min != null) {
          list.add(const SizedBox(
            height: 40,
            child: VerticalDivider(
              color: Color(0xFF191919),
              thickness: 1,
            ),
          ));
        }

        if (time.sec != null) {
          list.add(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(time.sec.toString(), style: styleTime),
              const SizedBox(height: 5),
              Text("SECONDES".toString(), style: styleSpan),
            ],
          ));
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: list,
        );
      },
    );
  }

  int calculateYearsRemaining(int milliseconds) {
    DateTime targetDate = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    Duration oneYear = const Duration(days: 365);

    DateTime now = DateTime.now();
    Duration difference = targetDate.difference(now);

    double averageDaysPerYear = 365;

    int yearsRemaining = (difference.inDays / averageDaysPerYear).floor();

    latestYear = yearsRemaining;

    return yearsRemaining * oneYear.inMilliseconds;
  }
}