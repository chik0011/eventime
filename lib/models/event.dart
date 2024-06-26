import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Event {
  final int id;
  final String typeEvent;
  final String title;
  final String posterPath;
  final List<String> genres;
  final String overview;
  final DateTime releaseDate;
  final TimeOfDay releaseTime;

  Event({
    required this.id,
    required this.typeEvent,
    required this.title,
    required this.posterPath,
    required this.genres,
    required this.overview,
    required this.releaseDate,
    required this.releaseTime,
  });

  String formatReleaseDate() {
    DateTime dateTime = DateTime.parse(releaseDate.toString());
    final dateFormat = DateFormat('MMM', 'fr');

    return "${dateTime.day} ${dateFormat.format(dateTime)} ${dateTime.year}";
  }

  String formatReleaseDateDay() {
    DateTime dateTime = DateTime.parse(releaseDate.toString());

    return "${dateTime.day}";
  }

  String formatReleaseDateMonth() {
    DateTime dateTime = DateTime.parse(releaseDate.toString());
    final dateFormat = DateFormat('MMM', 'fr');

    return "${dateFormat.format(dateTime)[0].toUpperCase()}${dateFormat.format(dateTime).substring(1)}";
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    String releaseTimeStr = json['releaseTime'] ?? '00:00';
    List<String> timeComponents = releaseTimeStr.split(':');

    return Event(
      id: json['id'] ?? 0,
      typeEvent: json['type_event'] ?? '',
      title: json['title'] ?? '',
      posterPath: json['posterPath'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      overview: json['overview'] ?? '',
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : DateTime.now(),
      releaseTime: TimeOfDay(
        hour: int.parse(timeComponents[0]),
        minute: int.parse(timeComponents[1]),
      ),
    );
  }
}
