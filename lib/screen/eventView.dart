import 'package:flutter/material.dart';
import '../components/CountdownTimerComponent.dart';
import '../models/event.dart';
import 'package:provider/provider.dart';
import '../provider/eventsProvider.dart';


class EventView extends StatefulWidget {
  final int idEvent;

  EventView({super.key, required this.idEvent});

  @override
  _EventViewState createState() {
    return _EventViewState();
  }
}

class _EventViewState extends State<EventView> {
  DateTime targetDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);

    Event? event = eventsProvider.fetch(widget.idEvent);

    print(event?.releaseDate);

    if (event != null) {
      // Combinez releaseDate et releaseTime pour former une seule DateTime
      targetDate = DateTime(
        event.releaseDate.year,
        event.releaseDate.month,
        event.releaseDate.day,
        event.releaseTime.hour,
        event.releaseTime.minute,
      );
    }

    return Container(
      child: CountdownTimerComponent(targetDate: targetDate),
    );
  }
}
