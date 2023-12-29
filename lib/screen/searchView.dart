import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({ super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Search", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.black54,
    );
  }
}