import 'package:eventime/provider/genresProvider.dart';
import 'package:eventime/provider/moviesProvider.dart';
import 'package:flutter/material.dart';
import 'package:eventime/api/movies.dart';
import 'package:eventime/models/movies.dart';
import 'package:eventime/screen/homeView.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => InitApp();
}

class InitApp extends State<MyApp> {
  late Future<Movies> futureMovies;

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const Home(),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    futureMovies = fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider()),
        ChangeNotifierProvider(create: (_) => GenresProvider()),
      ],
      child: MaterialApp.router(
        title: 'Eventime',
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
      ),
    );
  }
}


