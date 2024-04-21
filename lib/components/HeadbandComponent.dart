import 'package:flutter/material.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import 'package:eventime/screen/movieView.dart';
import '../provider/moviesProvider.dart';

class HeadBandComponent extends StatefulWidget {
  const HeadBandComponent({Key? key}) : super(key: key);

  @override
  State<HeadBandComponent> createState() => _StateHeadBandComponent();
}

class _StateHeadBandComponent extends State<HeadBandComponent> {
  late List<BannerModel> listBanners;
  late List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    listBanners = [];
    loadMovies();
  }

  void loadMovies() async {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    if (moviesProvider.futureMovies != null) {
      try {
        List<Movie> topMovies = await moviesProvider.getTopMovies();
        setState(() {
          for (var movie in topMovies) {
            listBanners.add(
              BannerModel(
                imagePath: "https://www.themoviedb.org/t/p/w500_and_h282_face${movie.posterPath}",
                id: movie.id.toString(),
              ),
            );
            movies.add(movie);
          }
        });
      } catch (e) {
        print('Erreur lors du chargement des meilleurs films: $e');
      }
    }
  }

  void onBannerTap(String id) {
    Movie? movieLink = movies.firstWhere(
            (movie) => movie.id.toString() == id
    );

    if (movieLink != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieView(movie: movieLink),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (listBanners.isNotEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: BannerCarousel.fullScreen(
          banners: listBanners,
          customizedIndicators: const IndicatorModel.animation(
            width: 5,
            height: 5,
            spaceBetween: 4,
            widthAnimation: 40,
          ),
          height: 270,
          activeColor: const Color(0xFFD9D9D9),
          disableColor: const Color(0xFFD9D9D9),
          animation: true,
          borderRadius: 7,
          onTap: onBannerTap,
          indicatorBottom: true,
        ),
      );
    }

    return Container();
  }
}
