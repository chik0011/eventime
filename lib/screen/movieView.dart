import 'dart:convert';
import 'dart:io';
import 'package:eventime/models/Genre/genre.dart';
import 'package:eventime/models/Genre/genres.dart';
import 'package:eventime/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:eventime/provider/eventsProvider.dart';
import '../provider/genresProvider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class MovieView extends StatefulWidget {
  final Movie movie;

  const MovieView({ super.key, required this.movie});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {

  late List<String> genres;
  String keyVideo = '';
  bool movieAdded = false;
  late YoutubePlayerController controller;

  List<String> getCategMovie(List<Genre>? allGenresMovie) {
    final genreNames = widget.movie.genreIds
        .where((mv) => allGenresMovie?.any((categMovie) => categMovie.id == mv) ?? false)
        .map((mv) => allGenresMovie!.firstWhere((categMovie) => categMovie.id == mv).name)
        .take(3) // Limit the result to a maximum of 3 elements
        .toList();

    return genreNames;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventsProvider>(context, listen: false).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {

    final GenresProvider genresProvider =
    Provider.of<GenresProvider>(context);

    final EventsProvider eventsProvider =
    Provider.of<EventsProvider>(context);

    Future<Genres> futureGenres = genresProvider.futureGenres;

    setState(() {
      movieAdded = eventsProvider.isIdContained(widget.movie.id);
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
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Container(
                      height: 515,
                      width: MediaQuery.of(context).size.width,
                      color: const Color(0XFF303538),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/picture.svg',
                          height: 250,
                        ),
                      ),
                    );
                  },
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
                  top: 505,
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
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                    color: const Color(0xFF121212),
                                    border: Border.all(
                                      color: const Color(0xFF303030),
                                      width: 1.1,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.0, vertical: 1.5),
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Text(
                                      categByMovie[index],
                                      style: const TextStyle(
                                        color: Color(0xFF777777),
                                        fontSize: 12
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
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  iconTheme: const IconThemeData(
                      color: Color(0xFFD9D9D9)
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 550.0, left: 8, right: 8),
                child: Divider(
                  color: Color(0xFF191919),
                  thickness: 2,
                ),
              ),
              Positioned(
                  top: 575,
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
                padding: EdgeInsets.only(top: 663.0, left: 8, right: 8),
                child: Divider(
                  color: Color(0xFF191919),
                  thickness: 2,
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 680),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 17.0),
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

                      buildVideo(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10, top: 35, bottom: 30),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: movieAdded
                          ? GestureDetector(
                              onTap: () {
                                // Remove element
                                if(movieAdded) {
                                  eventsProvider.removeEventById(widget.movie.id);
                                  setState(() {
                                    movieAdded = !movieAdded;
                                  });
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
                                    Text('Ajouter aux événements', style: TextStyle(color: Colors.white),),
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


  Widget buildVideo() {
    return FutureBuilder(
      future: widget.movie.getVideo(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          YoutubePlayerController _controller = YoutubePlayerController(
            initialVideoId: snapshot.data ?? '', // ID of a sample video from YouTube.// ID of a sample video from YouTube.
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              disableDragSeek: true,
              loop: false,
              enableCaption: false,
            ),
          );
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 17.0),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              bottomActions: <Widget>[
                const SizedBox(width: 14.0),
                CurrentPosition(),
                const SizedBox(width: 8.0),
                ProgressBar(isExpanded: true),
                RemainingDuration(),
              ],
              aspectRatio: 4 / 3,
              progressIndicatorColor: Colors.white,
              onReady: () {
                print('Player is ready.');
              },
            ),
          );
        } else {
          // Returns an empty container until the data is loaded
          return Container();
        }
      },
    );
  }

}