import 'package:eventime/models/Genre/genre.dart';

class Genres {
  final List<Genre> genres;

  const Genres({
    required this.genres,
  });

  factory Genres.fromJson(Map<String, dynamic> json) {
    return Genres(
      genres: List<Genre>.from(
          json["genres"]
              .map((x) => Genre.fromJson(x)))
    );
  }

  String getGenre() {
    return genres[0].name == "" ? genres[0].name : "rien";
  }
}