import 'package:flutter/material.dart';
import '../constants.dart' as constants;

class CourseCardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: 220,
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromARGB(148, 63, 63, 63).withOpacity(0.12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.12),
                blurStyle: BlurStyle.outer,
                spreadRadius: 1,
                blurRadius: 50,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
        ),
        const Positioned(
          bottom: -65,
          right: 20,
          child: SizedBox(
            height: 90,
            width: 90,
            child: ClipOval(
              child: Material(
                color: Color.fromARGB(184, 87, 87, 87),
              ),
            ),
          ),
        ),
        const Positioned(
          top: -65,
          left: 10,
          child: SizedBox(
            height: 90,
            width: 90,
            child: ClipOval(
              child: Material(
                color: Color.fromARGB(166, 29, 29, 29),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
