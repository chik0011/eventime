import 'package:flutter/material.dart';
import 'package:eventime/api/movies.dart';
import 'package:eventime/api/search.dart';
import 'package:eventime/models/movies.dart';
import 'package:eventime/models/movie.dart';

class MoviesProvider extends ChangeNotifier {
  late Future<Movies> futureMovies;
  final List<Movie> _moviesSearch = [];

  late Future<Movies> futureMoviesFilter;
  List<Movie> _moviesFilter = [];

  late String queryFilter;

  int _limitPage = 1;

  int _currentPage = 1;
  int _currentPageFilter = 1;

  MoviesProvider() {
    initMovies();
  }

  Future<void> initMovies() async {
    try {
      futureMovies = fetchMovies(1);

      await futureMovies;
      notifyListeners();
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  void removeFilters() {
    _moviesFilter.clear();
    _currentPageFilter = 1;
    notifyListeners();
  }

  List<Movie> getMoviesFilter () {
    return _moviesFilter;
  }

  Future<void> findMovies() async {
    try {
      _moviesFilter.clear();
      futureMoviesFilter = searchMovies(queryFilter, _currentPageFilter);
      Movies movies = await futureMoviesFilter;

      _limitPage = movies.totalPages;

      _addMoviesIfNotPresent(movies.results, _moviesFilter);

      notifyListeners();
    } catch (e) {
      print("Error search movies: $e");
    }
  }

  void _addMoviesIfNotPresent(List<Movie> newMovies, List<Movie> targetList) {
    for (var movie in newMovies) {
      if (movie.posterPath.isNotEmpty &&
          movie.posterPath != 'none' &&
          !targetList.contains(movie)) {
        targetList.add(movie);
      }
    }
  }

  List<Movie> getMoviesSearch() {
    return _moviesSearch;
  }

  Future<Movies> getFutureMovies() {
    return futureMovies;
  }

  bool permissionShowMore() {
    return _currentPage < _limitPage;
  }

  Future<void> initializedMoviesSearch() async {
    try {
      if(_moviesSearch.isEmpty) {
        Movies movies = await fetchMovies(1);

        _limitPage = movies.totalPages;

        for (var movie in movies.results) {
          _moviesSearch.add(movie);
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  Future<List<Movie>> getMovies() async {
    try {
      Movies movies;
      if (_moviesFilter.isNotEmpty) {
        futureMoviesFilter = searchMovies(queryFilter, _currentPageFilter); // Utiliser _currentPageFilter
        movies = await futureMoviesFilter;
      } else {
        movies = await fetchMovies(_currentPage);
      }

      _limitPage = movies.totalPages;

      if (_currentPage == 1) {
        if (_moviesFilter.isNotEmpty) {
          _moviesFilter.clear();
        } else {
          _moviesSearch.clear();
        }
      }

      if (_moviesFilter.isNotEmpty) {
        _addMoviesIfNotPresent(movies.results, _moviesFilter);
      } else {
        _addMoviesIfNotPresent(movies.results, _moviesSearch);
      }

      notifyListeners();
      return movies.results;
    } catch (e) {
      print('Error fetching movies: $e');
      return [];
    }
  }

  void increaseLimit(int increment) {
    if (_moviesFilter.isNotEmpty) {
      // Utiliser _currentPageFilter pour la recherche
      if (_currentPageFilter + increment <= _limitPage) {
        _currentPageFilter += increment;
      } else {
        _currentPageFilter = _limitPage;
      }
    } else {
      // Utiliser _currentPage pour la liste principale
      if (_currentPage + increment <= _limitPage) {
        _currentPage += increment;
      } else {
        _currentPage = _limitPage;
      }
    }

    getMovies().then((_) {
      notifyListeners();
    });
  }

  Future<List<Movie>> getTopMovies() async {
    try {
      Movies movies = await futureMovies;

      List<Movie> topMovies = await movies.getHomeMovies();

      return topMovies;
    } catch (e) {
      print('Error getting top movies: $e');
      return [];
    }
  }
}