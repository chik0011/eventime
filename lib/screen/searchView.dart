import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:eventime/screen/movieView.dart';
import 'package:shimmer/shimmer.dart';
import '../provider/moviesProvider.dart';
import 'package:eventime/components/SearchFavoriteMoviesComponent.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MoviesProvider>(context, listen: false).initializedMoviesSearch();
      Future.delayed(const Duration(milliseconds: 250), () {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(
              child: SearchFavoriteMoviesComponent(),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              sliver: isLoading
                  ? buildShimmerEffect() // Show shimmer when loading
                  : SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio:
                  ((MediaQuery.of(context).size.width / 2) / 300),
                ),
                delegate: buildListMovies(moviesProvider),
              ),
            ),
            showMore(moviesProvider),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 80),
            )
          ],
        ),
      ),
    );
  }


  Widget buildShimmerEffect() {
    return SliverToBoxAdapter(
      child: Shimmer.fromColors(
        baseColor: const Color(0xFF20201F),
        highlightColor: const Color(0xFF252525),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: ((MediaQuery.of(context).size.width / 2) / 300),
          ),
          itemCount: 6, // Number of shimmer items you want to show
          itemBuilder: (_, __) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            // Additional styling if needed
          ),
        ),
      ),
    );
  }

  SliverChildBuilderDelegate buildListMovies(MoviesProvider moviesProvider) {

    if(moviesProvider.getMoviesFilter().length > 0) {
      return SliverChildBuilderDelegate( (BuildContext context, int index) {
        var movie = moviesProvider.getMoviesFilter()[index];
        var posterPath = movie.getPosterPath();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieView(movie: movie),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              "https://image.tmdb.org/t/p/w600_and_h900_bestv2/$posterPath",
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Container(
                  color: const Color(0XFF232323),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/picture.svg',
                      height: 100,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
        childCount: moviesProvider.getMoviesFilter().length,
      );
    }
    else {
      return SliverChildBuilderDelegate( (BuildContext context, int index) {
        var movie = moviesProvider.getMoviesSearch()[index];
        var posterPath = movie.getPosterPath();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieView(movie: movie),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              "https://image.tmdb.org/t/p/w600_and_h900_bestv2/$posterPath",
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Container(
                  color: const Color(0XFF232323),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/picture.svg',
                      height: 100,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      childCount: moviesProvider.getMoviesSearch().length,
    );
    }
  }

  Widget showMore(moviesProvider) {
    if (moviesProvider.permissionShowMore()) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, top: 20),
          child: Center(
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF232323),
                ),
                onPressed: () {
                  moviesProvider.increaseLimit(1);
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Afficher plus',
                      style: TextStyle(
                          color: Color(0xFFDBE3E8),
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFFDBE3E8), size: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return const SliverToBoxAdapter();
  }
}
