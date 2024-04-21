import 'package:eventime/models/dateMovies.dart';
import 'package:eventime/models/movie.dart';
import 'package:eventime/api/movies.dart';

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

  Future<List<Movie>> getHomeMovies() async {
    List<Movie> result = [];

    // Sort the movies based on vote average in descending order
    // results.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));

    // Get the top 5 movies with the best vote average
    List<Movie> top5Movies = results.take(4).toList();

    // Print the top 5 movies
    for (var movie in top5Movies) {
      result.add(movie);
    }

    return result;
  }

  Future<List<Movie>> getBestMovies() async {
    List<Movie> bestMovies = [];

    try {
      Movies movies = await fetchMovies(1); // Assuming you start fetching from page 1
      int currentPage = 1;

      while (bestMovies.length < 5 && currentPage <= movies.totalPages) {
        // Fetch movies using the current page
        movies = await fetchMovies(currentPage);

        // Filter movies based on releaseDate being greater than or equal to today
        List<Movie> validMovies = movies.results
            .where((movie) {
          DateTime releaseDateTime = DateTime.parse(movie.releaseDate);

          return releaseDateTime.isAfter(DateTime.now()) ||
              releaseDateTime.isAtSameMomentAs(DateTime.now());
        }).toList();

        // Add valid movies to the result list
        bestMovies.addAll(validMovies);

        // Move to the next page for the next iteration
        currentPage++;
      }

      // Sort the movies based on vote average in descending order
      bestMovies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));

      // Get the top 5 movies with the best vote average
      return bestMovies.take(5).toList();
    } catch (e) {
      print('Error fetching best movies: $e');
      return []; // Return an empty list in case of an error
    }
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