import 'dart:io';
import 'package:eventime/models/Video/videos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Videos> fetchVideos(idMovie) async {
  final response = await http
      .get(
      Uri.parse('https://api.themoviedb.org/3/movie/$idMovie/videos?language=fr-FR'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYTQ0YjM1ZDE2OGRmZTIyMWQzZWYyMjBjMjZjMGE0ZSIsInN1YiI6IjYyMjIxNzMxZTE2ZTVhMDA0MmUxNTkxMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.hnCvyXL4L1UZtX3VRgD5qoGj1PSW9gavUCwcH_jtYa8'
      }
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return Videos.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load videos');
  }
}