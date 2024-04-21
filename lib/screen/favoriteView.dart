import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  int typeDisplay = 0;

  bool startAnimation = true;

  @override
  void initState() {
    super.initState();
    appDir = getApplicationDocumentsDirectory();

    if (mounted) {
      Future.delayed(Duration.zero, () {
        Provider.of<EventsProvider>(context, listen: false).getTypeDisplay().then((data) {
          setState(() {
            typeDisplay = data;
            startAnimation = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: Color(0xFFDBE3E8), size: 25),
                  const Text("EVENT'S",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () {
                      typeDisplay = typeDisplay == 1 ? 0 : 1;
                      eventsProvider.toggleTypeDisplay();
                    },
                    child: const Icon(Icons.grid_view_outlined , color: Color(0xFFDBE3E8), size: 25),
                  )
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        backgroundColor: const Color(0xFF121212),
        body: Container(
          margin: const EdgeInsets.only(top: 25),
          child: buildEventsList(eventsProvider)
        )
    );
  }

  Widget buildEventsList(eventsProvider) {
    if(eventsProvider.events.length == 0) {
      return const Center(
        child: Text(
          "Aucun évenement",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return FutureBuilder<Directory>(
      future: appDir,
      builder: (context, snapshot) {
        return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: eventsProvider.events.length,
                    itemBuilder: (BuildContext context, int index) {
                      var events = eventsProvider.getPreviewEvents();

                      if(typeDisplay == 0) { // Display one event per row

                        double paddingBottom = (index == events.length - 1 ? 100 : 12);

                        return AnimatedOpacity(
                            opacity: startAnimation ? 0 : 1,
                            duration: Duration(milliseconds: 100 + (index * 100)),
                            child: Padding(
                                padding: EdgeInsets.only(bottom: paddingBottom, left: 12, right: 12),
                                child: buildEventWidgetSingleInRow(events[index])
                            )
                        );
                      } else { // Display two images per row
                        if (index.isEven) {
                          int nextIndex = index + 1;
                          return AnimatedOpacity(
                              opacity: startAnimation ? 0 : 1,
                              duration: Duration(milliseconds: 100 + (index * 100)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      buildEventWidgetManyInRow(events[index]),
                                      if (nextIndex < events.length)
                                        buildEventWidgetManyInRow(events[nextIndex]),
                                    ],
                                  ),
                                  if(nextIndex >= events.length - 1)
                                    const SizedBox(height: 90),
                                  const SizedBox(height: 12,)
                                ],
                              )
                          );
                        }
                      }

                      return Container();
                    },
                  ),
                ),
              ],
            )
        );
      },
    );
  }

  Widget buildEventWidgetManyInRow(Event event) {
    if (event.typeEvent == "movie") {
      return Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventView(
                    idEvent: event.id,
                  ),
                ),
              );
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 10,
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500/${event.posterPath}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 45,
              padding: const EdgeInsets.only( left: 2, right: 2, top: 7, bottom: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Text(
                      "24",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 13
                      ),
                    ),
                    Text(
                      "Dec",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 9
                      ),
                    ),
                  ],
                )
              ),
            ),
          ),
        ],
      );
    } else if (event.typeEvent == "customize") {
      String imagePath = event.posterPath;
      imageFile = File(imagePath);

      if (imageFile.existsSync()) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventView(
                      idEvent: event.id,
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 10,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 45,
                padding: const EdgeInsets.only( left: 2, right: 2, top: 7, bottom: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                    child: Column(
                      children: [
                        Text(
                          "24",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13
                          ),
                        ),
                        Text(
                          "Dec",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 9
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
          ]
        );
      } else {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventView(
                      idEvent: event.id,
                    ),
                  ),
                );
              },
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width / 2 - 10,
                decoration: BoxDecoration(
                  color: const Color(0XFF303538),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromRGBO(33, 37, 42, 1)),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/picture.svg',
                    height: 100,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 45,
                padding: const EdgeInsets.only( left: 2, right: 2, top: 7, bottom: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                    child: Column(
                      children: [
                        Text(
                          "24",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13
                          ),
                        ),
                        Text(
                          "Dec",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 9
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
          ],
        );
      }
    }

    return Container();
  }

  Widget buildEventWidgetSingleInRow(Event event) {
    if (event.typeEvent == "movie") {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventView(
                idEvent: event.id,
              ),
            ),
          );
        },
        child: SizedBox(
          height: 150,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                "https://www.themoviedb.org/t/p/w500_and_h282_face${event.posterPath}",
                fit: BoxFit.cover,
              )
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
                builder: (context) => EventView(
                  idEvent: event.id,
                ),
              ),
            );
          },
          child: SizedBox(
            height: 150,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                )
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventView(
                  idEvent: event.id,
                ),
              ),
            );
          },
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0XFF303538),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/picture.svg',
                height: 100,
              ),
            ),
          ),
        );
      }
    }

    return Container();
  }
}
