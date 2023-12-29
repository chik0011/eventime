import 'package:eventime/provider/genresProvider.dart';
import 'package:eventime/provider/moviesProvider.dart';
import 'package:eventime/provider/eventsProvider.dart';
import 'package:flutter/material.dart';
import 'package:eventime/screen/homeView.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:eventime/screen/createEventView.dart';
import 'package:eventime/screen/favoriteView.dart';
import 'package:eventime/screen/searchView.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => InitApp();
}

class InitApp extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventsProvider()),
        ChangeNotifierProvider(create: (_) => MoviesProvider()),
        ChangeNotifierProvider(create: (_) => GenresProvider()),
      ],
      child: MaterialApp(
        title: 'Eventime',
        home: ManageApp(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('fr', 'FR'), // French
        ],
      ),
    );
  }
}

class ManageApp extends StatefulWidget {
  const ManageApp({ super.key });

  @override
  State<ManageApp> createState() => ManageAppState();
}

class ManageAppState extends State<ManageApp> {
  var _currentIndex = 0;

  void bottomNavigate(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      Home(onTap: bottomNavigate),
      const FavoriteView(),
      const SearchView(),
      CreateEventView(onTap: bottomNavigate),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      backgroundColor: _currentIndex == 3 ? Colors.black : Colors.transparent, // Set black color when _currentIndex is not 3
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: _currentIndex == 3 ? null : const LinearGradient(
            colors: [Color(0xFF202020), Color(0xFF202020)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(15),
        ),

        child: SalomonBottomBar(
          onTap: (i) => setState(() {
            _currentIndex = i;
          }),
          currentIndex: _currentIndex,
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

            /// Search
            SalomonBottomBarItem(
              icon: const Icon(Icons.search, color: Colors.grey,),
              title: const Text("Découvrir"),
              selectedColor: Colors.white,
            ),

            /// New
            SalomonBottomBarItem(
              icon: const Icon(Icons.add, color: Colors.grey,),
              title: const Text("Nouveau"),
              selectedColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}


