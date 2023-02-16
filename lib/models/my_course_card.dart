import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rx_comrade/constants.dart';
import '../constants.dart' as constants;

class MyCourseCard extends StatelessWidget {
  //const Course({Key? key}) : super(key: key);
  final String courseTitle;
  final String courseID;
  final String courseImage;

  MyCourseCard({
    required this.courseID,
    required this.courseTitle,
    required this.courseImage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("clicked Course ID: ${courseID}");
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: setCardColor(context),
          boxShadow: [
            BoxShadow(
              color: setCardShadowColor(context),
              spreadRadius: 0.1,
              blurRadius: 1,
              offset: const Offset(1, 3), // changes position of shadow
            ),
          ],
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.12),
          //     blurStyle: BlurStyle.outer,
          //     spreadRadius: 1,
          //     blurRadius: 50,
          //     offset: const Offset(0, 5), // changes position of shadow
          //   ),
          // ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Image.network(
              //   courseImage,
              //   fit: BoxFit.fitWidth,
              // ),
              AspectRatio(
                aspectRatio:
                    1, // use an aspect ratio of 1:1 to maintain a fixed height
                child: FittedBox(
                  fit: BoxFit
                      .fitHeight, // scale the SVG picture to fit within the aspect ratio
                  child: ClipRect(
                    clipBehavior: Clip.hardEdge,
                    clipper: CustomClipperRect(),
                    child: SvgPicture.asset(
                      'assets/images/$courseImage.svg',
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ),
                ),
              ),
              // SvgPicture.asset(
              //   'assets/images/${courseImage}.svg',
              //   alignment: Alignment.topCenter,
              //   fit: BoxFit.contain,
              //   height: MediaQuery.of(context).size.height * 0.3,
              // ),
              //const SizedBox(height: 5),
              Text(
                courseTitle,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: cardTitleStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomClipperRect extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    final height = size.height;
    final width = size.width;
    final clipWidth = height;
    final clipLeft = (width - clipWidth) / 2;
    final clipRight = clipLeft + clipWidth;
    return Rect.fromLTWH(clipLeft, 0, clipWidth, height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
