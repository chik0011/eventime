import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../provider/eventsProvider.dart';
import 'package:provider/provider.dart';
import '../screen/eventView.dart';

class ListViewHorizontalEvents extends StatefulWidget {
  const ListViewHorizontalEvents({super.key});

  @override
  State<ListViewHorizontalEvents> createState() => _StateListViewHorizontalEvents();
}

class _StateListViewHorizontalEvents extends State<ListViewHorizontalEvents> {
  late File imageFile;
  late Future<Directory> appDir;

  @override
  void initState() {
    super.initState();
    appDir = getApplicationDocumentsDirectory();
  }

  String truncateText(String text, int maxLength) {
    return text.length <= maxLength
        ? text
        : '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);

    return FutureBuilder<Directory>(
      future: appDir,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: eventsProvider.events.length,
            itemBuilder: (BuildContext context, int index) {
              var events = eventsProvider.getPreviewEvents();
              var titleEvent = events[index].title;

              if (events[index].typeEvent == "movie") {
                String posterPath = events[index].posterPath;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventView(idEvent: events[index].id,),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                            child: Image.network(
                              "https://image.tmdb.org/t/p/w200/$posterPath",
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/placeholder_image.png',
                                  height: 200,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      truncateText(titleEvent,
                          20), // Limit to 20 characters
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  ],
                );
              } else if (events[index].typeEvent == "customize") {
                String posterPath = events[index].posterPath;
                String imagePath = posterPath;
                imageFile = File(imagePath);

                if (imageFile.existsSync()) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventView(idEvent: events[index].id,),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: imageFile != null
                              ? Image.file(
                                  imageFile,
                                  width: 140,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 200,
                                  width: 140,
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
                                    borderRadius: BorderRadius.circular(13),
                                    border: Border.all(
                                        color: const Color.fromRGBO(33, 37, 42, 1)),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          truncateText(titleEvent,
                              20), // Limit to 20 characters
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Container(
                          height: 200,
                          width: 140,
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
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                                color: const Color.fromRGBO(33, 37, 42, 1)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        truncateText(titleEvent,
                            20), // Limit to 20 characters
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ],
                  );
                }
              }
            },
          );
        } else {
          // Show a loading indicator or some placeholder while waiting
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
