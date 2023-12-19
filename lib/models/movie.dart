import 'package:intl/intl.dart';

class Movie {
  final int id;
  final bool adult;
  final String backdropPath;
  final List genreIds;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final num? popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  const Movie({
    required this.id,
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      adult: json['adult'] is bool ? json['adult'] : false,
      backdropPath: json['backdrop_path'] ?? "none",
      genreIds: json['genre_ids'],
      originalLanguage: json['original_language'] ?? "none",
      originalTitle: json['original_title'] ?? "none",
      overview: json['overview'] ?? "none",
      popularity: json['popularity'],
      posterPath: json['poster_path'] ?? "none",
      releaseDate: json['release_date'] ?? "none",
      title: json['title'] ?? "none",
      video: json['video'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
    );
  }

  String getTitle() {
    return title;
  }

  String getPosterPath() {
    return posterPath;
  }

  String getReleaseDate() {
    return releaseDate.substring(0,4);
  }

  String formatReleaseDate() {
    DateTime dateTime = DateTime.parse(releaseDate);
    final dateFormat = DateFormat.MMM();

    return "${dateTime.day} ${dateFormat.format(dateTime)} ${dateTime.year}";
  }

  String getVoteAverage() {
    return voteAverage.toStringAsFixed(1) ?? 'N/A';
  }
}