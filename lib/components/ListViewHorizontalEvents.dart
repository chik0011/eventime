import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../provider/eventsProvider.dart';
import 'package:provider/provider.dart';
import '../screen/eventView.dart';
import 'package:flutter_svg/svg.dart';

class ListViewHorizontalEvents extends StatefulWidget {
  final Function(int) onTap;

  const ListViewHorizontalEvents({super.key, required this.onTap});

  @override
  State<ListViewHorizontalEvents> createState() =>
      _StateListViewHorizontalEvents();
}

class _StateListViewHorizontalEvents extends State<ListViewHorizontalEvents> {
  late File imageFile;
  late Future<Directory> appDir;

  @override
  void initState() {
    super.initState();
    appDir = getApplicationDocumentsDirectory();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventsProvider>(context, listen: false).loadEvents();
    });
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
        if (snapshot.connectionState == ConnectionState.done &&
            eventsProvider.events.isNotEmpty) {
          return SizedBox(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: eventsProvider.events.length,
              itemBuilder: (BuildContext context, int index) {
                var events = eventsProvider.getPreviewEvents();
                var titleEvent = events[index].title;

                if (events[index].typeEvent == "movie") {
                  String posterPath = events[index].posterPath;

                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventView(
                              idEvent: events[index].id,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w600_and_h900_bestv2/$posterPath",
                                height: 200,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              truncateText(titleEvent, 20), // Limit to 20 characters
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: const TextStyle(
                                  color: Color(0xFFD9D9D9),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12
                              ),
                            ),
                          ),
                        ],
                      )
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
                            builder: (context) =>
                                EventView(idEvent: events[index].id),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(
                                  imageFile,
                                  width: 133,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            truncateText(
                                titleEvent, 20), // Limit to 20 characters
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventView(
                              idEvent: events[index].id,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Container(
                              decoration: BoxDecoration (
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0XFF232323),
                              ),
                              height: 200,
                              width: 133,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/picture.svg',
                                  height: 100,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            truncateText(
                                titleEvent, 20), // Limit to 20 characters
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
                  }
                }
              },
            ),
          );
        } else {
          return GestureDetector(
              onTap: () {
                setState(() {
                  widget.onTap(3);
                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width - 16,
                decoration: BoxDecoration (
                  color: const Color(0xFF232323),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromRGBO(33, 37, 42, 1)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Color(0xFFDBE3E8), size: 32),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Créer un événement',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFDBE3E8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
          );
        }
      },
    );
  }
}
