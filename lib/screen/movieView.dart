import 'package:eventime/models/Genre/genre.dart';
import 'package:eventime/models/Genre/genres.dart';
import 'package:eventime/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/genresProvider.dart';


class MovieView extends StatefulWidget {
  // MovieView({ super.key, required Movie this.movie, required Future<Genres> this.futureGenres });
  const MovieView({ super.key, required Movie this.movie});

  final Movie movie;
  // final Future<Genres> futureGenres;

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {

  List<String> getCategMovie(List<Genre>? allGenresMovie) {
    final genreNames = widget.movie.genreIds
        .where((mv) => allGenresMovie?.any((categMovie) => categMovie.id == mv) ?? false)
        .map((mv) => allGenresMovie!.firstWhere((categMovie) => categMovie.id == mv).name)
        .take(3) // Limit the result to a maximum of 3 elements
        .toList();

    return genreNames;
  }

  @override
  Widget build(BuildContext context) {

    final GenresProvider genresProvider =
    Provider.of<GenresProvider>(context);

    Future<Genres> futureGenres = genresProvider.futureGenres;

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: ListView(
        children: [
          Stack(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment(0, 0.2),
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, 470));
                },
                blendMode: BlendMode.dstIn,
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500/${widget.movie.getPosterPath()}",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                  top: 480,
                  width: 300,
                  child: FutureBuilder<Genres>(
                    future: futureGenres,
                    builder: (context, snapshot) {
                      List<String> categByMovie =  getCategMovie(snapshot.data?.genres);

                      if(categByMovie != null) {
                        return SizedBox(
                          height: 25,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categByMovie.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(13)),
                                      color: const Color(0xFF1E1E1E),
                                      border: Border.all(
                                        color: const Color(0xFF434343),
                                        width: 1.1
                                      )
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
                                    margin: const EdgeInsets.only(right: 5.0, left: 10),
                                    child: Text(
                                        categByMovie[index],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13
                                        )
                                    )
                                );
                              }
                          ),
                        );
                      } else {
                        return const Text('');
                      }
                    },
                  ),
              ),
              Positioned(
                  top: 480,
                  left: MediaQuery.of(context).size.width - 60,
                  width:  MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Text(
                        widget.movie.getVoteAverage(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15
                        ),
                      ),
                      const Icon(
                        Icons.star,
                        color: Color(0xFFBB86FC),
                        size: 16,
                      )
                    ],
                  )
              ),
              Container(
                  margin: const EdgeInsets.only(top: 530),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0,),
                        child: Text(
                          widget.movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 15.0),
                        child: Text(
                          widget.movie.formatReleaseDate(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 15.0),
                        child: Text(
                          widget.movie.overview,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10, top: 25, bottom: 25),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                              child: const Text('Ajouter un événement'),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5B5B5B),
                                side: const BorderSide(
                                  width: 1.1,
                                  color: Color(0xFFBB86FC),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                                minimumSize: const Size.fromHeight(50),
                              )
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ],
          )
        ],
      )
    );
  }
}