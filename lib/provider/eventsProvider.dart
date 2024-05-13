import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:eventime/models/event.dart';

class EventsProvider extends ChangeNotifier {

  late SharedPreferences _prefs;
  List<String> events = [];
  int typeDisplay = 0;

  EventsProvider() {
    loadEvents();
  }

  Future<int> getTypeDisplay() async {

    String? searchTypeDisplay = _prefs.getString("type_display");

    if (searchTypeDisplay == null) {
      await _prefs.setString("type_display", '0');

      return 0;
    } else {
      typeDisplay = int.parse(searchTypeDisplay);
    }

    return typeDisplay;
  }

  void toggleTypeDisplay() async {
    int newValue = typeDisplay == 1 ? 0 : 1;

    await _prefs.setString("type_display", newValue.toString());
    typeDisplay = newValue;

    notifyListeners();
  }

  // Load events from SharedPreferences
  Future<void> loadEvents() async {
    _prefs = await SharedPreferences.getInstance();

    Set<String> allKeys = _prefs.getKeys();

    // Assuming you store an integer under 'type_display' key
    String? searchTypeDisplay = _prefs.getString("type_display");

    if (searchTypeDisplay == null) {
      await _prefs.setString("type_display", '0');
    } else {
      typeDisplay = int.parse(searchTypeDisplay);
    }

    // Filter keys begin by "event"
    Set<String> eventKeys = allKeys.where((key) => key.startsWith('event')).toSet();

    List<int> uniqueEventIds = [];

    for (var eventKey in eventKeys) {
      var value = _prefs.getString(eventKey) ?? "";

      var decodedEvent = json.decode(value);
      var eventId = decodedEvent['id'];

      if (!uniqueEventIds.contains(eventId) && !isIdContained(eventId)) {
        uniqueEventIds.add(eventId);
        if (value.isNotEmpty) {
          events.add(value);
        }
      }
    }
  }

  Event? fetch(int idEvent) {
    loadEvents();

    for (var eventString in events) {
      try {
        var decodedEvent = json.decode(eventString);
        var eventId = decodedEvent['id'];

        if (eventId is String) {
          if (int.tryParse(eventId) == idEvent) {
            return Event.fromJson(decodedEvent);
          }
        } else if (eventId is int && eventId == idEvent) {
          return Event.fromJson(decodedEvent);
        }
      } catch (e) {
        print('Error decoding event: $e');
      }
    }

    return null;
  }

  List<Event> getPreviewEvents() {
    // If events are already loaded, parse and sort them immediately
    List<Event> eventObjects = events.map((eventString) {
      try {
        return Event.fromJson(json.decode(eventString));
      } catch (e) {
        print('Error decoding event: $e');
        return null;
      }
    }).whereType<Event>().toList();

    // Sort the events by releaseDate in ascending order
    eventObjects.sort((a, b) {
      return a.releaseDate.compareTo(b.releaseDate);
    });

    // Return the sorted events
    return eventObjects;
  }

  // Add an event to SharedPreferences and the events list
  Future<void> addEvent(Object eventData) async {
    var jsonString = json.encode(eventData);
    Map<String, dynamic> decodedEvent = json.decode(jsonString);

    var typeEvent = decodedEvent['type_event'];
    var eventId = decodedEvent['id'];

    if (typeEvent == "movie") {
      // Check if the event ID is already registered
      bool isRegistered = await isIdRegister(eventId);
      bool isContained = isIdContained(eventId);

      // Add new event if it's not already registered
      if (!isRegistered && !isContained) {
        var eventKey = "event_$eventId";

        // Save to SharedPreferences
        await _prefs.setString(eventKey, jsonString);
        // Update the events list
        events.add(jsonString);
        notifyListeners();
      }
    } else if (typeEvent == "customize") {
      var eventKey = "event_$eventId";

      // Save to SharedPreferences
      await _prefs.setString(eventKey, jsonString);
      // Update the events list
      events.add(jsonString);
      notifyListeners();
    }
  }

  Future<void> updateEvent(int eventId, Object updatedEventData) async {
    loadEvents();

    int index = events.indexWhere((event) {
      try {
        var decodedEvent = json.decode(event);
        var currentEventId = decodedEvent['id'];

        if (currentEventId is String) {
          return int.tryParse(currentEventId) == eventId;
        } else if (currentEventId is int) {
          return currentEventId == eventId;
        }
        return false;
      } catch (e) {
        return false;
      }
    });

    if (index != -1) {
      var eventKey = "event_$eventId";
      var updatedEventJsonString = json.encode(updatedEventData);

      // Update in SharedPreferences
      await _prefs.setString(eventKey, updatedEventJsonString);

      // Update list in events
      events[index] = updatedEventJsonString;

      notifyListeners();
    }
  }

  // Remove an event from SharedPreferences and the events list by ID
  Future<void> removeEventById(int id) async {
    // Find the index of the event with the specified ID
    int index = events.indexWhere((event) {
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

    try {
      await deleteEventImage(id);

      if (index != -1) {
        // If the event with the specified ID is found, remove it
        var eventKey = "event_$id";
        await _prefs.remove(eventKey);

        // Remove the event from the events list
        events.removeAt(index);
        notifyListeners();
      }
    } catch (e) {
      print("Erreur lors de la suppression de l'événement : $e");
    }
  }

  Future<void> deleteEventImage(int id) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagePath = "${appDir.path}/event_image_$id.jpg";

      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        print("Image of id event  $id is delete.");
      } else {
        print("Image id $id  doesn't exist");
      }
    } catch (e) {
      print("Error delete id image: $e");
    }
  }

  void printAllSharedPreferencesKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      print(key);
    }
  }

  // Test if an id is contained in the events list
  bool isIdContained(int id) {
    var find = false;
    for (var event in events) {
      var decodedEvent = json.decode(event);
      var eventId = decodedEvent['id'];

      if (eventId is String) {
        if (int.tryParse(eventId) == id) {
          // Match found
          find = true;
        }
      } else if (eventId is int) {
        if (eventId == id) {
          // Match found
          find =  true;
        }
      }
    }

    return find;
  }

  Future<bool> isIdRegister(int id) async {
    _prefs = await SharedPreferences.getInstance();
    Set<String> keys = _prefs.getKeys();

    for (var key in keys) {
      if(key == "event_$id") {
        return true;
      }
    }

    return false;
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
