import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:eventime/provider/eventsProvider.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class CreateEventView extends StatefulWidget {
  final Function(int) onTap;

  const CreateEventView({super.key, required this.onTap});

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  final _formKey = GlobalKey<FormState>();
  var selectedDate;
  var selectedTime;
  File? _image;

  DateTime currentDate = DateTime.now();

  final TextEditingController _nameEvent = TextEditingController();
  final TextEditingController _descriptionEvent = TextEditingController();

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    // Use the format 'HH:mm' for 24-hour format
    // or 'hh:mm a' for 12-hour format with AM/PM
    return '${timeOfDay.hour}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Localizations.override(
            context: context,
            locale: const Locale('fr', 'FR'),
            child: child,
          );
        }
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }

    // Format the selected time using the French locale
    final timeFormatted = DateFormat.Hm('fr_FR').format(
      DateTime(currentDate.year, currentDate.month, currentDate.day, selectedTime!.hour, selectedTime!.minute),
    );

    print('Selected Time: $timeFormatted');
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

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);

    return Scaffold(
      body: ListView(children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Display selected image
                    SizedBox(
                      height: 280,
                      child: Stack(children: <Widget>[
                        _image != null
                            ? Image.file(
                                _image!,
                                height: 220,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 220,
                                color: const Color(0XFF303538),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/picture.svg',
                                    height: 150,
                                  ),
                                ),
                              ),
                        Positioned(
                          right: 20,
                          top: 190,
                          child: GestureDetector(
                            onTap: _getImage,
                            child: Container(
                              height: 55,
                              width: 260,
                              decoration: BoxDecoration(
                                color: const Color(0xFF21252A),
                                borderRadius: BorderRadius.circular(37),
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(33, 37, 42, 1)),
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
                                        borderRadius:
                                            BorderRadius.circular(37),
                                        color: const Color(0xFF21252A),
                                        boxShadow: const [
                                          BoxShadow(
                                              offset: Offset(2, 2),
                                              color: Color.fromRGBO(
                                                  166, 166, 166, 0.2),
                                              blurRadius: 10),
                                          BoxShadow(
                                              offset: Offset(-2, -2),
                                              color: Color.fromRGBO(
                                                  5, 5, 5, 0.5),
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
                      ]),
                    ),
                    const SizedBox(height: 5),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 16,
                          child: TextFormField(
                            controller: _nameEvent,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.white),
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey, // Set the focused border color here
                                  ),
                                ),
                                hintText: 'Nom de l’événement',
                                isDense: true,
                                contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                hintStyle: const TextStyle(color:  Color(0xFF696969), fontSize: 13, fontWeight: FontWeight.w400),
                                fillColor:  Colors.transparent ,
                                filled: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 16,
                          child: TextFormField(
                            controller: _descriptionEvent,
                            maxLines: 3,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.white),
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey, // Set the focused border color here
                                  ),
                                ),
                                hintText: 'Déscription de l’événement',
                                isDense: true,
                                contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                hintStyle: const TextStyle(color:  Color(0xFF696969), fontSize: 13, fontWeight: FontWeight.w400),
                                fillColor:  Colors.transparent ,
                                filled: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 16,
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
                                color: const Color(0xFF21252A),
                                borderRadius: BorderRadius.circular(37),
                                border: Border.all(
                                    color:
                                    const Color.fromRGBO(33, 37, 42, 1)),
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
                                        borderRadius:
                                        BorderRadius.circular(37),
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
                              _selectTime(context);
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 220,
                              decoration: BoxDecoration(
                                color: const Color(0xFF21252A),
                                borderRadius: BorderRadius.circular(37),
                                border: Border.all(
                                    color:
                                    const Color.fromRGBO(33, 37, 42, 1)),
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
                                        borderRadius:
                                        BorderRadius.circular(37),
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
                                        ? DateFormat.Hm('fr_FR').format(DateTime(currentDate.year, currentDate.month, currentDate.day, selectedTime!.hour, selectedTime!.minute))
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
                    const SizedBox(height: 60),
                    GestureDetector(
                      onTap: () async {
                        if(selectedDate != null && _nameEvent.text.isNotEmpty) {
                          String nameEvent = _nameEvent.text;
                          String descriptionEvent = _descriptionEvent.text;
                          var dateEvent = selectedDate;
                          var timeEvent = selectedTime;

                          DateTime now = DateTime.now();
                          int timestamp = now.millisecondsSinceEpoch;

                          var savedImage;
                          if(_image != null) {
                            // Save picture in local
                            final appDir = await getApplicationDocumentsDirectory();
                            final fileName = "event_image_$timestamp.jpg";
                            savedImage = await _image!.copy('${appDir.path}/$fileName');
                          }

                          var data = {
                            'id': timestamp,
                            'type_event': 'customize',
                            'title': nameEvent,
                            'posterPath': _image != null ? savedImage.path : '',
                            'overview': descriptionEvent,
                            'releaseDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateEvent),
                            'releaseTime': timeEvent != null ? formatTimeOfDay(timeEvent) : ''
                          };

                          eventsProvider.addEvent(data);

                          widget.onTap(1);
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 16,
                        height: 50,
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
                              color:
                              const Color.fromRGBO(33, 37, 42, 1)),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Créer mon événement', style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
      backgroundColor: Colors.black54,
    );
  }
}
