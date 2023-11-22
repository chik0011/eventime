import 'package:flutter/material.dart';
import 'package:eventime/models/movies.dart';
import 'package:eventime/screen/movieView.dart';
import 'package:provider/provider.dart';
import '../provider/moviesProvider.dart';

class Home extends StatefulWidget {
  const Home({ super.key });

  @override
  State<Home> createState() => _HomeSate();
}

class _HomeSate extends State<Home>  {
  @override
  Widget build(BuildContext context) {

    final MoviesProvider moviesProvider =
    Provider.of<MoviesProvider>(context);

    Future<Movies> futureMovies = moviesProvider.futureMovies;

    return Consumer(
        builder: (context, notifier, child) {
          return FutureBuilder<Movies>(
            future: futureMovies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                    children: <Widget> [
                      Stack(
                        children: <Widget> [
                          Positioned(
                            top: -200,
                            width: MediaQuery.of(context).size.width,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MovieView(
                                        movie: snapshot.data!.results[1],
                                        )
                                      )
                                  );
                                },
                                child: ShaderMask(
                                  shaderCallback: (rect) {
                                    return const LinearGradient(
                                      begin: Alignment(0, 0.2),
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.black, Colors.transparent],
                                    ).createShader(Rect.fromLTRB(0, 0, rect.width, 400));
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w500/${snapshot.data?.results[1].getPosterPath()}",
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 150.0,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Text(
                                  snapshot.data!.results[1].title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none
                                  )
                              ),
                            )
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 230),
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
                                  margin: const EdgeInsets.only(top: 20),
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder: (BuildContext context, index) => Padding(
                                      padding: const EdgeInsets.only(left: 20.0),
                                      child: SingleChildScrollView (
                                          physics: const NeverScrollableScrollPhysics(),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => MovieView(
                                                    movie: snapshot.data!.getBestMovies()[index]
                                                  ))
                                              );
                                            },
                                            child: Image.network("https://image.tmdb.org/t/p/w200/${snapshot.data!.getBestMovies()[index].getPosterPath()}"),
                                          ),
                                      ),
                                    ),
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
          );
        }
    );
  }
}