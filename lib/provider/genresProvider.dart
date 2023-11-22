import 'package:eventime/api/genres.dart';
import 'package:eventime/models/Genre/genres.dart';
import 'package:flutter/material.dart';

class GenresProvider extends ChangeNotifier {
  late Future<Genres> futureGenres;

  GenresProvider() {
    initGenres();
  }

  Future<void> initGenres() async {
    try {
      futureGenres = fetchGenres();
    } catch (e) {
      print("Error fetching genres: $e");
    }
  }

  Future<Genres> getFutureMovies() {
    return futureGenres;
  }
}
