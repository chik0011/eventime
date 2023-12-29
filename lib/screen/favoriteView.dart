import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../provider/eventsProvider.dart';
import '../models/event.dart';
import '../screen/eventView.dart';
import 'package:provider/provider.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  late File imageFile;
  late Future<Directory> appDir;

  @override
  void initState() {
    super.initState();
    appDir = getApplicationDocumentsDirectory();
  }

  Widget buildEventWidget(Event event) {
    if (event.typeEvent == "movie") {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventView(idEvent: event.id,),
            ),
          );
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 8,
          height: 250,
          child: Image.network(
            "https://image.tmdb.org/t/p/w200/${event.posterPath}",
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (event.typeEvent == "customize") {
      String imagePath = event.posterPath;
      imageFile = File(imagePath);

      if (imageFile.existsSync()) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventView(idEvent: event.id,),
              ),
            );
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 8,
            height: 250,
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventView(idEvent: event.id,),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 8,
            height: 250,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment(-1, -1),
                end: Alignment(1, 1),
                colors: [
                  Color(0xFFF69F64),
                  Color.fromRGBO(237, 105, 127, 0.98),
                  Color(0xFFC963C7),
                  Color(0xFFB25FF5),
                  Color(0xFF5882DC),
                ],
              ),
              border: Border.all(
                  color: const Color.fromRGBO(33, 37, 42, 1)),
            ),
          ),
        );
      }
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final EventsProvider eventsProvider =
    Provider.of<EventsProvider>(context);

    return FutureBuilder<Directory>(
      future: appDir,
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF121212), Color(0xFF121212)],
            ),
          ),
          child: ListView.builder(
            itemCount: eventsProvider.events.length,
            itemBuilder: (BuildContext context, int index) {
              var events = eventsProvider.getPreviewEvents();

              // Display two images per row
              if (index.isEven) {
                // The current index is even, so display the images
                int nextIndex = index + 1;
                return Row(
                  children: [
                    buildEventWidget(events[index]),
                    if (nextIndex < events.length)
                      buildEventWidget(events[nextIndex]),
                  ],
                );
              }

              // The current index is odd, so return an empty container
              return Container();
            },
          ),
        );
      },
    );
  }
}
