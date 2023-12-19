import 'package:eventime/models/dateMovies.dart';
import 'package:eventime/models/movie.dart';

class Movies {
  final DateMovies? dateMovies;
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  const Movies({
    required this.dateMovies,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  get movies => Movies;

  List<Movie> getBestMovies() {
    List<Movie> result = [];

    // Sort the movies based on vote average in descending order
    results.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));

    // Get the top 5 movies with the best vote average
    List<Movie> top5Movies = results.take(5).toList();

    // Print the top 5 movies
    for (var movie in top5Movies) {
      result.add(movie);
    }

    return result;
  }

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      dateMovies: json['dates'] != null ? DateMovies.fromJson(json['dates']) : null,
      page: json['page'],
      results: List<Movie>.from(
        json['results'].map((x) => Movie.fromJson(x)),
      ),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}