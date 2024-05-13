import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:eventime/provider/eventsProvider.dart';
import '../models/event.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class UpdateView extends StatefulWidget {
  final int idEvent;

  const UpdateView({super.key, required this.idEvent});

  @override
  State<UpdateView> createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  final _formKey = GlobalKey<FormState>();
  late File imageFile;
  File? _image;
  var selectedTime;
  var selectedDate;

  final TextEditingController nameEvent = TextEditingController();
  final TextEditingController descriptionEvent = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    Event? event = eventsProvider.fetch(widget.idEvent);

    if (nameEvent.text.isEmpty && eventsProvider.events.isNotEmpty) {
      try {
        var title = event!.title;
        nameEvent.text = title;
      } catch (e) {
        print('Error title : $e');
      }
    }

    if (descriptionEvent.text.isEmpty && eventsProvider.events.isNotEmpty) {
      try {
        var title = event!.overview;
        descriptionEvent.text = title;
      } catch (e) {
        print('Error title : $e');
      }
    }

    if (selectedDate == null) {
      DateTime releaseDate = event!.releaseDate;
      setState(() {
        selectedDate = releaseDate;
      });
    }

    if (selectedTime == null) {
      TimeOfDay releaseTime = event!.releaseTime;
      setState(() {
        selectedTime = releaseTime;
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        height: 310,
                        child: Stack(
                          children: <Widget>[
                            _image != null
                                ? Image.file(
                                    _image!,
                                    height: 280,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  )
                                : buildEventWidget(event!),
                            Positioned(
                              right: 20,
                              top: 250,
                              child: GestureDetector(
                                onTap: _getImage,
                                child: Container(
                                  height: 55,
                                  width: 260,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF232323),
                                    borderRadius: BorderRadius.circular(37),
                                    border: Border.all(
                                        color: const Color.fromRGBO(33, 37, 42, 1)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        height: 38,
                                        width: 38,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(37),
                                            color: const Color(0xFF232323),
                                            boxShadow: const [
                                              BoxShadow(
                                                  offset: Offset(2, 2),
                                                  color: Color.fromRGBO(
                                                      166, 166, 166, 0.2),
                                                  blurRadius: 10),
                                              BoxShadow(
                                                  offset: Offset(-2, -2),
                                                  color:
                                                      Color.fromRGBO(5, 5, 5, 0.5),
                                                  blurRadius: 10)
                                            ]),
                                        child: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                                      ),
                                      const Text(
                                        "Sélectionner une image",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 16,
                          child: TextFormField(
                            controller: nameEvent,
                            style: const TextStyle(
                                fontSize: 15.0, color: Colors.white),
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors
                                        .grey, // Set the focused border color here
                                  ),
                                ),
                                hintText: 'Nom de l’événement',
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                hintStyle: const TextStyle(
                                    color: Color(0xFF696969),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                                fillColor: Colors.transparent,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(color: Color(0xFF232323)),
                                ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width-20,
                          child: TextFormField(
                            controller: descriptionEvent,
                            maxLines: 7,
                            style: const TextStyle(
                                fontSize: 14.0, color: Color(0xFFD9D9D9)),
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors
                                        .grey, // Set the focused border color here
                                  ),
                                ),
                                hintText: descriptionEvent.text.isEmpty
                                    ? event?.overview
                                    : descriptionEvent.text,
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                hintStyle: const TextStyle(
                                    color: Color(0xFF696969),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                                fillColor: Colors.transparent,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(color: Color(0xFF232323)),
                                ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width-20,
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 220,
                              decoration: BoxDecoration(
                                color: const Color(0xFF232323),
                                borderRadius: BorderRadius.circular(37),
                                border: Border.all(
                                    color: const Color.fromRGBO(33, 37, 42, 1)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(37),
                                      color: const Color(0xFF15171A),
                                    ),
                                    child: const Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                                  ),
                                  Text(
                                    selectedDate != null
                                        ? DateFormat('dd-MM-yyyy').format(selectedDate)
                                        : 'Date',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _selectTime(context, event!.releaseTime);
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 220,
                              decoration: BoxDecoration(
                                color: const Color(0xFF232323),
                                borderRadius: BorderRadius.circular(37),
                                border: Border.all(
                                    color: const Color.fromRGBO(33, 37, 42, 1)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(37),
                                      color: const Color(0xFF15171A),
                                    ),
                                    child: const Icon(
                                      Icons.access_time,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                                  ),
                                  Text(
                                    selectedTime != null
                                        ? DateFormat.Hm('fr_FR').format(DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day,
                                            selectedTime.hour,
                                            selectedTime.minute))
                                        : 'Heure',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                        onTap: () async {
                          if (selectedDate != null && nameEvent.text.isNotEmpty) {
                            String name = nameEvent.text.isNotEmpty ? nameEvent.text : event!.title;
                            String description = descriptionEvent.text.isNotEmpty ? descriptionEvent.text : event!.overview;
                            var dateEvent = selectedDate;
                            var timeEvent = selectedTime;

                            // var savedImage;
                            // if(_image != null) {
                            //   // Save picture in local
                            //   final appDir = await getApplicationDocumentsDirectory();
                            //   final fileName = "event_image_$timestamp.jpg";
                            //   savedImage = await _image!.copy('${appDir.path}/$fileName');
                            // }

                            var data = {
                              'id': event?.id,
                              'type_event': event!.typeEvent == "movie" ? "movie" : "customize",
                              'genres': event.typeEvent == "movie" ? event.genres : [],
                              'title': name,
                              'posterPath': event.posterPath, //_image != null ? savedImage.path : '',
                              'overview': description,
                              'releaseDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateEvent),
                              'releaseTime': timeEvent != null
                                           ? formatTimeOfDay(timeEvent)
                                           : formatTimeOfDay(const TimeOfDay(hour: 0, minute: 0))
                            };

                            eventsProvider.updateEvent(event.id, data).then((_) {
                              setState(() {
                                Navigator.of(context, rootNavigator: true).pop("Discard");
                              });
                            });
                          } else {
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: SvgPicture.asset(
                                    'assets/images/error.svg',
                                    height: 150,
                                  ),
                                  content: const Text(
                                    'Pour créer un événement il est nécessaire de lui donner un nom est une date',
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        // Close the dialog and navigate back
                                        Navigator.of(context, rootNavigator: true)
                                            .pop("Discard");
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width-20,
                          margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(-1, -1),
                              end: Alignment(1, 1),
                              colors: [
                                Color(0xFFFF6321),
                                Color(0xFFD63341),
                                Color(0xFF8E3F80),
                                Color(0xFF007789),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                                color: const Color.fromRGBO(33, 37, 42, 1)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Modifier',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                  ]),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: AppBar(
              iconTheme: const IconThemeData(
                  color: Color(0xFFD9D9D9)
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF121212),
    );
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2169),
      locale: const Locale('fr', 'FR'), // Set the locale to French
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:
                Colors.blue, // Set the primary color for the date picker header
            colorScheme: const ColorScheme.light(primary: Colors.blue),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay? preselectedTime) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: preselectedTime != null && preselectedTime != const TimeOfDay(hour: 0, minute: 0) ? preselectedTime : TimeOfDay.now(),
        builder: (context, child) {
          return Localizations.override(
            context: context,
            locale: const Locale('fr', 'FR'),
            child: child,
          );
        });

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Widget buildEventWidget(Event event) {
    if (event.typeEvent == "movie") {
      return Image.network(
        "https://image.tmdb.org/t/p/w500/${event.posterPath}",
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        height: 280,
      );
    } else if (event.typeEvent == "customize") {
      String imagePath = event.posterPath;
      imageFile = File(imagePath);

      if (imageFile.existsSync()) {
        return Image.file(
          imageFile,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: 280,
        );
      } else {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 280,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-1, -1),
              end: Alignment(1, 1),
              colors: [
                Color(0xFFFF6321),
                Color(0xFFD63341),
                Color(0xFF8E3F80),
                Color(0xFF007789),
              ],
            ),
            border: Border.all(color: const Color.fromRGBO(33, 37, 42, 1)),
          ),
        );
      }
    }

    return Container();
  }
}
