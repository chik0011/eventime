import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/HeadbandComponent.dart';
import '../components/ButtonSmoothComponent.dart';
import 'package:eventime/components/ListViewHorizontalEvents.dart';
import 'package:eventime/components/ListViewHorizontalBestMovies.dart';
import '../provider/eventsProvider.dart';

class Home extends StatefulWidget {
  final Function(int) onTap;

  const Home({super.key, required this.onTap});

  @override
  State<Home> createState() => _HomeSate();
}

class _HomeSate extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    eventsProvider.loadEvents();

    return Consumer(builder: (context, notifier, child) {
      return Scaffold(
          body: Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF121212), Color(0xFF121212)],
                ),
              ),
              child: ListView(children: <Widget>[
                Stack(children: <Widget>[
                  HeadBandComponent(),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 225.0),
                      child: Row(
                        children: <Widget>[
                          ButtonSmoothComponent(
                            onTap: () {
                              setState(() {
                                widget.onTap(3);
                              });
                            },
                            title: "Ajouter",
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 55,
                            icon: const Icon(Icons.add, color: Colors.white),
                          ),
                          const Spacer(),
                          ButtonSmoothComponent(
                            onTap: () {
                              setState(() {
                                widget.onTap(2);
                              });
                            },
                            title: "Découvrir",
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 55,
                            icon: const Icon(Icons.arrow_forward,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 310.0),
                    child: Divider(
                      color: Color(0xFF191919),
                      thickness: 2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 340),
                    child: Column(
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 4),
                            Text("Vos Event’s",
                                style: TextStyle(
                                    color: Color(0xFFDBE3E8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none)),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 12),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: const TextSpan(
                                  text:
                                      'Transformez chaque instant en un événement ',
                                  style: TextStyle(fontSize: 11),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'unique',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE36482))),
                                    TextSpan(text: ' avec notre appli.'),
                                  ],
                                ),
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 25),
                          height: 240,
                          child: ListViewHorizontalEvents(),
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 690),
                      child: const Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 4),
                              Text("Films Populaires",
                                  style: TextStyle(
                                      color: Color(0xFFDBE3E8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none)),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 12),
                            ],
                          ),
                          ListViewHorizontalBestMovies(),
                        ],
                      )),
                ]),
              ])));
    });
  }
}
