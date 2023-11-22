import 'package:flutter/material.dart';
import 'package:eventime/api/movies.dart';
import 'package:eventime/models/movies.dart';

class MoviesProvider extends ChangeNotifier {
  late Future<Movies> futureMovies;

  MoviesProvider() {
    initMovies();
  }

  Future<void> initMovies() async {
    try {
      futureMovies = fetchMovies();
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  Future<Movies> getFutureMovies() {
    return futureMovies;
  }
}