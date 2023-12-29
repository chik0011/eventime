import 'dart:convert';
import 'package:eventime/models/Genre/genre.dart';
import 'package:eventime/models/Genre/genres.dart';
import 'package:eventime/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventime/provider/eventsProvider.dart';
import '../provider/genresProvider.dart';

class MovieView extends StatefulWidget {
  final Movie movie;

  const MovieView({ super.key, required this.movie});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {

  late List<String> genres;
  bool movieAdded = false;

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

    final EventsProvider eventsProvider =
    Provider.of<EventsProvider>(context);

    Future<Genres> futureGenres = genresProvider.futureGenres;

    setState(() {
      eventsProvider.loadEvents();
      movieAdded = eventsProvider.isIdContained(widget.movie.id);
      eventsProvider.printEvents();
    });

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: ListView(
        children: [
          Stack(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment(0, 0.2),
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF121212), Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, 520));
                },
                blendMode: BlendMode.dstIn,
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500/${widget.movie.getPosterPath()}",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 460,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.title,
                        style: const TextStyle(
                            color: Color(0xFFD9D9D9),
                            fontSize: 21,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Text(
                        widget.movie.formatReleaseDateYear(),
                        style: const TextStyle(
                            color: Color(0xFFD9D9D9),
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 500,
                  width: 320,
                  child: FutureBuilder<Genres>(
                    future: futureGenres,
                    builder: (context, snapshot) {
                      List<String> categByMovie = getCategMovie(snapshot.data?.genres);
                      genres = categByMovie;

                      return SizedBox(
                        height: 25,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categByMovie.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    color: const Color(0xFF121212),
                                    border: Border.all(
                                      color: const Color(0xFF303030),
                                      width: 1.1
                                    )
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.5),
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Text(
                                      categByMovie[index],
                                      style: const TextStyle(
                                        color: Color(0xFFD9D9D9),
                                        fontSize: 13
                                      )
                                  )
                              );
                            }
                        ),
                      );
                      },
                  ),
              ),
              Positioned(
                  top: 15,
                  left: MediaQuery.of(context).size.width - 70,
                  width:  MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                          primary: Colors.transparent,
                          onPrimary: Colors.black,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      )
                    ],
                  )
              ),
              const Padding(
                padding: EdgeInsets.only(top: 541.0, left: 8, right: 8),
                child: Divider(
                  color: Color(0xFF191919),
                  thickness: 2,
                ),
              ),
              Positioned(
                  top: 565,
                  width:  MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: Color(0xFF303030),
                              size: 21,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              widget.movie.formatReleaseDate(),
                              style: const TextStyle(
                                  color: Color(0xFFD9D9D9),
                                  fontSize: 14
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text(
                              "Date sortie",
                              style: TextStyle(
                                  color: Color(0xFF797979),
                                  fontSize: 10
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Icon(
                            Icons.star_border_purple500_outlined,
                            color: Color(0xFF303030),
                            size: 22,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          RichText(
                            text: TextSpan(
                              text:
                              widget.movie.getVoteAverage(),
                              style: const TextStyle(fontSize: 18, color: Color(0xFFD9D9D9)),
                              children: const <TextSpan>[
                                TextSpan(
                                    text: ' /10',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF888888))),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          const Text(
                            "Note",
                            style: TextStyle(
                                color: Color(0xFF797979),
                                fontSize: 10
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Column(
                          children: [
                            Text(
                              widget.movie.getVoteCount(),
                              style: const TextStyle(
                                color: Color(0xFF797979),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              "Popularité",
                              style: TextStyle(
                                  color: Color(0xFFD9D9D9),
                                  fontSize: 14
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text(
                              "Nombre de vote",
                              style: TextStyle(
                                  color: Color(0xFF797979),
                                  fontSize: 10
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
              const Padding(
                padding: EdgeInsets.only(top: 655.0, left: 8, right: 8),
                child: Divider(
                  color: Color(0xFF191919),
                  thickness: 2,
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 670),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                        child: Text(
                          style: TextStyle(
                            color: Color(0xFFD9D9D9),
                            fontSize: 21,
                          ),
                          "Synopsis",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            text: widget.movie.overview,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10, top: 35, bottom: 20),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: movieAdded
                          ? GestureDetector(
                              onTap: () {
                                // Remove element
                                if(movieAdded) {
                                  var indexMovie = eventsProvider.indexOfEventById(widget.movie.id);

                                  if(indexMovie > 0) {
                                    eventsProvider.removeEvent(indexMovie);

                                    setState(() {
                                      movieAdded = !movieAdded;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 16,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(-1, -1),
                                    end: Alignment(1, 1),
                                    colors: [
                                      Color(0xFFF69F64),
                                      Color.fromRGBO(237, 105, 127, 0.98),
                                      Color(0xFFC963C7),
                                      Color(0xFFB25FF5),
                                      Color(0xFF5882DC),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                      color:
                                      const Color.fromRGBO(33, 37, 42, 1)),
                                ),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Retirer des événements', style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                              )
                          )
                          : GestureDetector(
                              onTap: () {
                                var data = {
                                  'id': widget.movie.id,
                                  'type_event': 'movie',
                                  'title': widget.movie.title,
                                  'posterPath': widget.movie.posterPath,
                                  'genres': genres,
                                  'overview': widget.movie.overview,
                                  'releaseDate': widget.movie.releaseDate
                                };

                                if (!eventsProvider.events.any((event) => json.decode(event) == data)) {
                                  eventsProvider.addEvent(data);
                                }

                                setState(() {
                                  movieAdded = !movieAdded;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 16,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(-1, -1),
                                    end: Alignment(1, 1),
                                    colors: [
                                      Color(0xFFF69F64),
                                      Color.fromRGBO(237, 105, 127, 0.98),
                                      Color(0xFFC963C7),
                                      Color(0xFFB25FF5),
                                      Color(0xFF5882DC),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                      color:
                                      const Color.fromRGBO(33, 37, 42, 1)),
                                ),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Ajouter un événement', style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                              )
                          )
                        ),
                      ),
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