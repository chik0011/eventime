import 'package:flutter/material.dart';
import '../provider/moviesProvider.dart';
import 'package:provider/provider.dart';

class SearchFavoriteMoviesComponent extends StatefulWidget {
  const SearchFavoriteMoviesComponent({super.key});

  @override
  _SearchFavoriteMoviesComponentState createState() {
    return _SearchFavoriteMoviesComponentState();
  }
}

class _SearchFavoriteMoviesComponentState extends State<SearchFavoriteMoviesComponent> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 30),
      child:  Column(
        children: [
          SearchBar(
            hintStyle: MaterialStateProperty.all(const TextStyle(
              color: Color(0xFF3F3F3F),
            )),
            textStyle: MaterialStateProperty.all(const TextStyle(
              color: Color(0xFF3F3F3F ),
            )),
            backgroundColor: MaterialStateProperty.all(
              Colors.black38,
            ),
            onSubmitted: (String value) {
              moviesProvider.queryFilter = value;
              moviesProvider.findMovies();
            },
            hintText: 'Rechercher un film',
            controller: textEditingController,
            leading: const Icon(Icons.search, color: Color(0xFF3F3F3F)),
            trailing: [
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF3F3F3F)),
                onPressed: () {
                  moviesProvider.removeFilters();
                  textEditingController.clear();
                },
              ),
            ],
            shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            )),
          ),
        ],
      )
    );
  }
}
