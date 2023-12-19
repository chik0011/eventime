import 'package:flutter/material.dart';
import 'package:eventime/models/movies.dart';
import 'package:eventime/screen/movieView.dart';
import 'package:provider/provider.dart';
import '../provider/moviesProvider.dart';
import '../provider/eventsProvider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({ super.key });

  @override
  State<Home> createState() => _HomeSate();
}

class _HomeSate extends State<Home>  {

  @override
  Widget build(BuildContext context) {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    Future<Movies> futureMovies = moviesProvider.getFutureMovies();

    var currentIndex = 0;

    return Consumer(
        builder: (context, notifier, child) {
          return Scaffold(
            body: FutureBuilder<Movies>(
              future: futureMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                      children: <Widget> [
                        Stack(
                            children: <Widget> [
                              Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: Column (
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        child: const Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Prochainement",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.none
                                                )
                                            ),
                                            SizedBox(width: 10),
                                            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        child: const Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text("toto"),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 20, top: 300),
                                        child: const Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Films Populaires" ,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.none
                                                )
                                            ),
                                            SizedBox(width: 10),
                                            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(top: 20, bottom: 40),
                                          height: 200,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: snapshot.data?.getBestMovies().length ?? 0,
                                            itemBuilder: (BuildContext context, int index) {
                                              var movies = snapshot.data?.getBestMovies();
                                              var movie = movies?[index];
                                              var posterPath = movie?.getPosterPath();

                                              // Check if the posterPath is not null or empty
                                              if (posterPath != null && posterPath.isNotEmpty) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(left: 20.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => MovieView(
                                                              movie: snapshot.data!.getBestMovies()[index]
                                                          ))
                                                      );
                                                    },
                                                    child: Image.network("https://image.tmdb.org/t/p/w200/$posterPath"),
                                                  ),
                                                );
                                              } else {
                                                // Handle the case where the posterPath is null or empty
                                                return const Text("error"); // Or provide a placeholder widget, or handle differently
                                              }
                                            },
                                          )
                                      ),
                                    ],
                                  )
                              ),
                            ]
                        ),
                      ]
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  ) ;
                }
              },
            ),
            backgroundColor: Colors.black54,
            bottomNavigationBar: SalomonBottomBar(
              currentIndex: currentIndex,
              onTap: (i) => setState(() => currentIndex = i),
              items: [
                /// Home
                SalomonBottomBarItem(
                  icon: const Icon(Icons.home, color: Colors.grey,),
                  title: const Text("Accueil"),
                  selectedColor: Colors.white,
                ),

                /// Likes
                SalomonBottomBarItem(
                  icon: const Icon(Icons.favorite_border, color: Colors.grey,),
                  title: const Text("Favorie"),
                  selectedColor: Colors.white,
                ),

                /// Likes
                SalomonBottomBarItem(
                  icon: const Icon(Icons.search, color: Colors.grey,),
                  title: const Text("Découvrir"),
                  selectedColor: Colors.white,
                ),

                /// Search
                SalomonBottomBarItem(
                  icon: const Icon(Icons.add, color: Colors.grey,),
                  title: const Text("Nouveau"),
                  selectedColor: Colors.white,
                )
              ],
            ),
          );
        }
    );
  }
}