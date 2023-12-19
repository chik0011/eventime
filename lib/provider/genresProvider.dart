import 'package:eventime/api/genres.dart';
import 'package:eventime/models/Genre/genres.dart';
import 'package:flutter/material.dart';

class GenresProvider extends ChangeNotifier {
  late Future<Genres> _futureGenres;

  GenresProvider() {
    // Call initGenres from the constructor and await it
    _initGenres();
  }

  Future<void> _initGenres() async {
    try {
      _futureGenres = fetchGenres();
      // Wait for the future to complete before notifying listeners
      await _futureGenres;
      notifyListeners();
    } catch (e) {
      print("Error fetching genres: $e");
      // Handle error appropriately
    }
  }

  // Provide a getter to access the genres once the future is complete
  Future<Genres> get futureGenres => _futureGenres;
}