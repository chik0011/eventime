import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class HeadBandComponent extends StatelessWidget {
  HeadBandComponent({
    super.key,
  });

  DateTime dateNow = DateTime.now();
  DateFormat dateFormatLong = DateFormat('dd.MM', 'fr');
  DateFormat dateFormatShort = DateFormat('EEEE', 'fr');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
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
      ),
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Row (
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Bonjour !", style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 12.0,
                fontWeight: FontWeight.w300,
              )),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              ),
              Text(dateFormatLong.format(dateNow), style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 36.0,
                fontWeight: FontWeight.w500,
              ),),
              Text(dateFormatShort.format(dateNow), style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 17.0,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w300, // Use FontWeight.w300 directly
              )),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 160,
            child:
              SvgPicture.asset(
                'assets/images/headband_Planet.svg',
                height: 150,
              ),
          )
        ],
      ),
    );
  }
}