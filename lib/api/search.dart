import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:eventime/models/movies.dart';
import 'dart:convert';
import 'package:eventime/config/env.dart';

Future<Movies> searchMovies(String query, int page) async {
  var encodedQuery = Uri.encodeComponent(query); // Encode le query pour l'URL
  var tmdbApiKey1 = Env.tmdbApiKey1;

  final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/search/movie?query=$encodedQuery&language=fr-FR&region=FR&page=$page'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $tmdbApiKey1'
      }
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return Movies.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load movies');
  }
}
