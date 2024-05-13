import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Genre/genre.dart';
import '../models/Genre/genres.dart';
import '../models/movie.dart';
import 'package:eventime/screen/movieView.dart';
import '../provider/genresProvider.dart';
import '../provider/moviesProvider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HeadBandComponent extends StatefulWidget {
  const HeadBandComponent({Key? key}) : super(key: key);

  @override
  State<HeadBandComponent> createState() => _StateHeadBandComponent();
}

class _StateHeadBandComponent extends State<HeadBandComponent> {

  late List<Movie> imgList = [];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  late List<String> genres;

  getGenreMovie(List<Genre>? allGenresMovie, movie) {
    final genreNames = movie.genreIds
        .where((mv) => allGenresMovie?.any((genreMovie) => genreMovie.id == mv) ?? false)
        .map((mv) => allGenresMovie!.firstWhere((genreMovie) => genreMovie.id == mv).name)
        .take(3) // Limit the result to a maximum of 3 elements
        .toList();
    return genreNames;
  }

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  void loadMovies() async {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    try {
      List<Movie> topMovies = await moviesProvider.getTopMovies();
      setState(() {
        for (var movie in topMovies) {
          imgList.add(
              movie
          );
        }
      });
    } catch (e) {
      print('Error load best movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GenresProvider genresProvider =
    Provider.of<GenresProvider>(context);
    Future<Genres> futureGenres = genresProvider.futureGenres;

    return Container(
      height: 270,
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              items: buildItemList(futureGenres),
              carouselController: _controller,
              options: CarouselOptions(
                  autoPlayInterval: const Duration(seconds: 8),
                  enlargeFactor: 0.18,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 1.70,
                  viewportFraction: 0.90,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(_current == entry.key ? 0.8 : 0.35)),
                ),
              );
            }).toList(),
          ),
        ]
      ),
    );
  }

  List<Widget> buildItemList(futureGenres) {
    return imgList.map((item) => GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieView(
              movie: item,
            ),
          ),
        );
      },
      child: Container(
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Stack(
              children: <Widget>[
                Image.network("https://www.themoviedb.org/t/p/w500_and_h282_face${item.posterPath}", fit: BoxFit.cover, height: 300),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                    child: FutureBuilder<Genres>(
                      future: futureGenres,
                      builder: (context, snapshot) {
                        var genreByMovie = getGenreMovie(snapshot.data?.genres, item);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                              '${item.title}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: 27,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: genreByMovie.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(4)),
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: Colors.white12,
                                            width: 1,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 2),
                                        margin: const EdgeInsets.only(right: 8, top: 5),
                                        child: Text(
                                            genreByMovie[index],
                                            style: const TextStyle(
                                                color: Color(0xFFB5B5B5),
                                                fontSize: 13
                                            )
                                        )
                                    );
                                  }
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            )),
      ),
    )).toList();
  }
}




