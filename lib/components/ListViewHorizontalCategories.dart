import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Genre/genre.dart';
import '../models/Genre/genres.dart';
import '../provider/genresProvider.dart';

class ListViewHorizontalCategories extends StatefulWidget {
  final Function(int) onTap;

  const ListViewHorizontalCategories({super.key, required this.onTap});

  @override
  State<ListViewHorizontalCategories> createState() => _ListViewHorizontalCategoriesSate();
}

class _ListViewHorizontalCategoriesSate extends State<ListViewHorizontalCategories> {

  @override
  Widget build(BuildContext context) {
    final GenresProvider genresProvider = Provider.of<GenresProvider>(context);

    return FutureBuilder<Genres>(
      future: genresProvider.futureGenres,
      builder: (context, snapshot) {
        List<Genre>? genres = snapshot.data?.genres.take(6).toList();

        if(snapshot.data != null) {
          return SizedBox(
            height: 35,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: const Color(0xFF121212),
                        border: Border.all(
                          color: const Color(0xFF303030),
                          width: 1.1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric( horizontal: 15.0, vertical: 6),
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                          genres![index].name,
                          style: const TextStyle(
                              color: Color(0xFFDBE3E8),
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                          )
                      )
                  );
                }
            ),
          );
        }

        return Container();
      },
    );
  }
}