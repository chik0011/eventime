import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer';

class EventsProvider extends ChangeNotifier {

  late SharedPreferences _prefs;
  List<String> events = [];

  EventsProvider() {
    loadEvents();
  }

  Future<void> printAllSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> allPrefs = prefs.getKeys().fold({}, (Map<String, dynamic> acc, String key) {
      acc[key] = prefs.get(key);
      return acc;
    });

    print('All SharedPreferences:');
    allPrefs.forEach((key, value) {
      print('$key: $value');
    });
  }

  // Load events from SharedPreferences
  Future<void> loadEvents() async {
    _prefs = await SharedPreferences.getInstance();
    var i = 1;

    events = [];

    do {
      var eventKey = "event$i";
      var value = _prefs.getString(eventKey) ?? "";

      if (value.isNotEmpty) {
        events.add(value);
      }

      i++;
    } while (_prefs.containsKey("event$i"));
  }

  // Add an event to SharedPreferences and the events list
  Future<void> addEvent(Object eventData) async {
    var jsonString = json.encode(eventData);
    Map<String, dynamic> decodedEvent = json.decode(jsonString);

    var eventId = decodedEvent['id'];

    // Check if eventData is already in the events list
    if (!events.any((event) => json.decode(event) == json.decode(jsonString)) && isIdContained(eventId) == false) {
      var eventKey = "event${events.length + 1}";

      // Save to SharedPreferences
      await _prefs.setString(eventKey, jsonString);
      // Update the events list
      events.add(jsonString);
      notifyListeners();
    } else {
      print('Event already exists in the list');
    }
  }

  // Remove an event from SharedPreferences and the events list
  Future<void> removeEvent(int index) async {
    if (events.isNotEmpty && index >= 0 && index <= events.length) {
      var eventKey = "event$index";
      await _prefs.remove(eventKey);

      index--;
      events.removeAt(index);
      notifyListeners();
    } else {
      print('Invalid index: $index or empty list');
    }
  }

  // Print events
  // void printEvents() {
  //   for (var i = 0; i < events.length; i++) {
  //     print("Event ${i + 1}: ${inspect(events[i])}");
  //   }
  // }

  void printEvents() {
    for (var i = 0; i < events.length; i++) {
      try {
        var decodedEvent = json.decode(events[i]);
        var title = decodedEvent['title'];
        var id = decodedEvent['id'];
        print("Event ${i + 1} - Title: $title, ID: $id");
      } catch (e) {
        print("Event ${i + 1}: Error decoding JSON");
      }
    }
  }

  // Test if an id is contained in the events list
  bool isIdContained(int id) {
    return events.any((event) {
      try {
        var decodedEvent = json.decode(event);
        var eventId = decodedEvent['id'];
        if (eventId is String) {
          return int.tryParse(eventId) == id;
        } else if (eventId is int) {
          return eventId == id;
        }
        return false;
      } catch (e) {
        // Handle JSON decoding errors, if any
        return false;
      }
    });
  }

  // Get the index of the event with a specific id
  int indexOfEventById(int id) {
    for (int i = 0; i < events.length; i++) {
      try {
        var decodedEvent = json.decode(events[i]);
        var eventId = decodedEvent['id'];
        if (eventId is String) {
          if (int.tryParse(eventId) == id) {
            return i + 1;
          }
        } else if (eventId is int && eventId == id) {
          return i + 1;
        }
      } catch (e) {
        // Handle JSON decoding errors, if any
      }
    }
    return -1; // Return -1 if the id is not found
  }
}
