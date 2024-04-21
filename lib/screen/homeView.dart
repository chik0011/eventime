import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/HeadbandComponent.dart';
import 'package:eventime/components/ListViewHorizontalEvents.dart';
import 'package:eventime/components/ListViewHorizontalBestMovies.dart';
import 'package:eventime/components/ListViewHorizontalCategories.dart';
import '../provider/eventsProvider.dart';
import 'package:flutter_svg/svg.dart';

class Home extends StatefulWidget {
  final Function(int) onTap;

  const Home({super.key, required this.onTap});

  @override
  State<Home> createState() => _HomeSate();
}

class _HomeSate extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventsProvider>(context, listen: false).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, notifier, child) {
      return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: ListView(children: <Widget>[
            Stack(children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: const Center(
                  child: Image(
                    image: AssetImage('assets/images/logo_extend.png'),
                    height: 35,
                  )
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 80),
                child: const HeadBandComponent(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 400),
                child: ListViewHorizontalCategories(onTap: widget.onTap,),
              ),
              Container(
                margin: const EdgeInsets.only(top: 470, left: 10, right: 10),
                child: const Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Vos Event’s",
                            style: TextStyle(
                                color: Color(0xFFDBE3E8),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none)),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 15),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 510),
                height: 235,
                child: ListViewHorizontalEvents(onTap: widget.onTap),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 770, left: 10, right: 10),
                  child: const Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Films Populaires",
                              style: TextStyle(
                                  color: Color(0xFFDBE3E8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none)),
                          Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 15),
                        ],
                      ),
                    ],
                  )
              ),
              Container(
                margin: const EdgeInsets.only(top: 790, bottom: 80),
                child: const ListViewHorizontalBestMovies(),
              ),
            ]),
          ]));
    });
  }
}
