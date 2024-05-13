import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../components/CountdownTimerComponent.dart';
import '../models/event.dart';
import 'package:provider/provider.dart';
import '../provider/eventsProvider.dart';
import 'package:eventime/screen/updateView.dart';

class EventView extends StatefulWidget {
  final int idEvent;

  const EventView({super.key, required this.idEvent});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  DateTime targetDate = DateTime.now();
  late File imageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventsProvider>(context, listen: false).loadEvents();
    });
  }

  void popBackTwoScreens(BuildContext context) {
    int count = 0;
    Navigator.popUntil(context, (_) => count++ >= 2);
  }

  @override
  Widget build(BuildContext context) {
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    Event? event = eventsProvider.fetch(widget.idEvent);

    if (event != null) {
      targetDate = DateTime(
        event.releaseDate.year,
        event.releaseDate.month,
        event.releaseDate.day,
        event.releaseTime.hour,
        event.releaseTime.minute,
      );
    }

    if(event == null) {
      return Container();
    } else {
      return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: ListView(children: [
            Stack(
              children: <Widget>[
                buildEventWidget(event),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    iconTheme: const IconThemeData(
                        color: Color(0xFFD9D9D9)
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [
                      PopupMenuButton(
                          onSelected: (value) {
                            if(value == "delete") {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      content:
                                      SizedBox(
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Voulez-vous supprimer cet événement ?',
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.center,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => {
                                                    Navigator.of(context).pop(false)
                                                  },
                                                  child: const Text(
                                                    "Non",
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => {
                                                    popBackTwoScreens(context),
                                                    eventsProvider.removeEventById(event.id),
                                                  },
                                                  child: const Text(
                                                      "Oui",
                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                                value: "delete",
                                child: Text('Supprimer')
                            )
                          ]
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 440,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                              color: Color(0xFFD9D9D9),
                              fontSize: 21,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          event.formatReleaseDate().toString(),
                          style: const TextStyle(
                              color: Color(0xFFD9D9D9),
                              fontSize: 11,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                genresEvent(event),
                Padding(
                    padding: const EdgeInsets.only(top: 560.0, left: 8, right: 8),
                    child: CountdownTimerComponent(targetDate: targetDate)
                ),
                Container(
                    margin: const EdgeInsets.only(top: 620),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                          child: Text(
                            style: const TextStyle(
                              color: Color(0xFFD9D9D9),
                              fontSize: 21,
                            ),
                            event.typeEvent == "movie" ? "Synopsis" : "Description",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                height: 1.5
                              ),
                              text: event.overview.isNotEmpty ? event.overview : "Aucune",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10, top: 35, bottom: 30),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateView(
                                          idEvent: event.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width - 16,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment(-1, -1.5),
                                        end: Alignment(1.15, 3),
                                        colors: [
                                          Color(0xFFFF6321),
                                          Color(0xFFD63341),
                                          Color(0xFF8E3F80),
                                          Color(0xFF007789),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(
                                          color:
                                          const Color.fromRGBO(33, 37, 42, 1)),
                                    ),
                                    child: const Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Modifier mon événement', style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                  )
                              )
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ]));
    }

  }

  Widget buildEventWidget(Event event) {
    if (event.typeEvent == "movie") {
      return ShaderMask(
        shaderCallback: (rect) {
          return const LinearGradient(
            begin: Alignment(0, 0.2),
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Colors.transparent],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, 520));
        },
        blendMode: BlendMode.dstIn,
        child: Image.network(
          "https://image.tmdb.org/t/p/w500/${event.posterPath}",
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      );
    } else if (event.typeEvent == "customize") {
      String imagePath = event.posterPath;
      imageFile = File(imagePath);

      if (imageFile.existsSync()) {
        return ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment(0, 0.2),
              end: Alignment.bottomCenter,
              colors: [Color(0xFF121212), Colors.transparent],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, 520));
          },
          blendMode: BlendMode.dstIn,
          child: Image.file(
            width: MediaQuery.of(context).size.width,
            height: 515,
            imageFile,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment(0, 0.2),
              end: Alignment.bottomCenter,
              colors: [Color(0xFF121212), Colors.transparent],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, 520));
          },
          blendMode: BlendMode.dstIn,
          child: Container(
            height: 515,
            width: MediaQuery.of(context).size.width,
            color: const Color(0XFF232323),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/picture.svg',
                height: 250,
              ),
            ),
          ),
        );
      }
    }

    return Container();
  }

  Widget genresEvent(Event event) {
    if(event.genres.isNotEmpty) {
      return Positioned(
        top: 505,
        width: 320,
        child: SizedBox(
          height: 25,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: event.genres.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.all(Radius.circular(4)),
                  color: const Color(0xFF121212),
                  border: Border.all(
                    color: const Color(0xFF303030),
                    width: 1.1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 3),
                margin: const EdgeInsets.only(left: 8, top: 2),
                child: Text(
                  event.genres[index], // Use 'Unknown Genre' if the value is null
                  style: const TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return
      Positioned(
          top: 505,
          width: 94,
          child: SizedBox(
              height: 23,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.all(Radius.circular(4)),
                  color: const Color(0xFF121212),
                  border: Border.all(
                    color: const Color(0xFF303030),
                    width: 1.1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 7.0, vertical: 2.8),
                margin: const EdgeInsets.only(left: 8),
                child: const Text(
                  "Personnalisé",
                  style: TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 12,
                  ),
                ),
              )
          ));
  }
}