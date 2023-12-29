import 'package:flutter/material.dart';

class ButtonSmoothComponent extends StatelessWidget {
  const ButtonSmoothComponent({
    Key? key,
    required this.onTap,
    required this.title,
    required this.width,
    required this.height,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final double width;
  final double height;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: const Color(0xFF21252A),
            borderRadius: BorderRadius.circular(37),
            border: Border.all(
              color: const Color.fromRGBO(33, 37, 42, 1)
            ),
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
                    color: const Color(0xFF21252A),
                    boxShadow: const [
                      BoxShadow(offset: Offset(2, 2), color: Color.fromRGBO(166, 166, 166, 0.2), blurRadius: 10),
                      BoxShadow(offset: Offset(-2, -2), color: Color.fromRGBO(5, 5, 5, 0.5), blurRadius: 10)
                ]),
                child: icon,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
              ),
              Text(title, style: const TextStyle(color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}
