import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../constants.dart' as constants;

class CourseCard extends StatelessWidget {
  //const Course({Key? key}) : super(key: key);
  final String courseTitle;
  final String courseCategory;
  final String courseAuthor;
  final int coursePrice;
  final String courseID;

  CourseCard({
    required this.courseID,
    required this.courseTitle,
    required this.courseCategory,
    required this.courseAuthor,
    required this.coursePrice,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("clicked Course ID: ${courseID}");
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: constants.textFieldBg.withOpacity(0.12),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  //if string is longer. display with ..
                  courseTitle.toString().length < 100
                      ? courseTitle.toString()
                      : '${courseTitle.toString().substring(0, 100)}..',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: constants.courseCardTitle,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/book.png',
                      height: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      //if string is longer. display with ..
                      courseCategory.toString().length < 28
                          ? courseCategory.toString()
                          : '${courseCategory.toString().substring(0, 28)}..',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/brain.png',
                      height: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      //if string is longer. display with ..
                      courseAuthor.toString().length < 28
                          ? courseAuthor.toString()
                          : '${courseAuthor.toString().substring(0, 28)}..',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cost:  ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    Image.asset(
                      'assets/icons/gem.png',
                      height: 15,
                    ),
                    const SizedBox(width: 4),
                    //IF COST is 0, print FREE, else show cost

                    coursePrice <= 0
                        ? const Text(
                            'FREE!',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: constants.primaryColor,
                              fontSize: 15,
                            ),
                          )
                        : Text(
                            //if string is longer. display with ..
                            coursePrice.toString().length < 20
                                ? coursePrice.toString()
                                : '${coursePrice.toString().substring(0, 20)}..',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                  ],
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
                  color: Color.fromARGB(185, 177, 0, 0),
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
                  color: Color.fromARGB(166, 20, 99, 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
