import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import 'package:eventime/screen/movieView.dart';
import '../provider/moviesProvider.dart';
import 'package:eventime/models/movies.dart';

class ListViewHorizontalBestMovies extends StatefulWidget  {
  const ListViewHorizontalBestMovies({super.key});

  @override
  State<ListViewHorizontalBestMovies> createState() => _StateListViewHorizontalBestMovies();
}

class _StateListViewHorizontalBestMovies extends State<ListViewHorizontalBestMovies> {

  String truncateText(String text, int maxLength) {
    return text.length <= maxLength
        ? text
        : '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    Future<Movies> futureMovies = moviesProvider.getFutureMovies();

    return FutureBuilder<Movies>(
      future: futureMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 40),
                height: 240,
                child: FutureBuilder<List<Movie>>(
                  future: snapshot.data?.getBestMovies(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      List<Movie> movies = snapshot.data ?? [];
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (BuildContext context, int index) {
                          var movie = movies[index];
                          var posterPath = movie.getPosterPath();

                          // Customize your UI elements here based on the movie data
                          return Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieView(movie: movie),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center, // Align children to the start (left)
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                                        child: Image.network("https://image.tmdb.org/t/p/w200/$posterPath", height: 200)
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0), // Add some top padding for separation
                                      child: Text(
                                        truncateText(movie.title,
                                            20), // Limit to 20 characters
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: const TextStyle(
                                            color: Color(0xFFD9D9D9),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}