import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rx_comrade/res/custom_colors.dart';
import '../constants.dart' as constants;
import '../models/course_card.dart';
import '../placeholders/course_card_placeholder.dart';
import '../utils/authentication.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;

  //MENU ITEMS CLICK HANDLERS
  void _onAvatarMenuIconTap() {
    print('Avatar Menu Clicked');
  }

  //FIRESTORE DATABASE QUERIES
  CollectionReference quotes = FirebaseFirestore.instance.collection('quotes');
  List<Map<String, dynamic>> quotesLoaded = [];
  Random rand = Random();
  int randomInt = 0;

  void addQuotes() {
    Map<String, dynamic> quotesData = {
      "body":
          "Poisons and medicine are often the same substance given with different intents.",
      "author": "Peter Mere Latham"
    };

    quotes.add(quotesData);
  }

  Future getQuote() async {
    if (quotesLoaded.isEmpty) {
      //EasyLoading.showInfo('Loading Quotes');
      await quotes.get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          quotesLoaded.add({"body": doc['body'], "author": doc['author']});
        }
      });
    }
    quotesLoaded.shuffle();
    //EasyLoading.dismiss();
  }

  //courses data
  final List COURSE_LIST = [
    [
      'Antimicrobial Agents',
      'Pharmaceutical Microbiology',
      'Rx Michael',
      45.0,
    ],
    [
      'Computer-Aided Drug Design',
      'Pharmaceutical Chemistry',
      'Nicole Rose',
      0.0,
    ],
    [
      'Introduction to Pharmacokinetics and Pharmacodynamics',
      'Pharmacology',
      'Dr Hercjay',
      389.0,
    ],
    [
      'Milliequivalence, Milliosmoles and Millimoles Calculations',
      'Pharmaceutical Technology',
      'Professor Anokwulu',
      270.0,
    ],
    [
      'African and Traditional Medicines',
      'Pharmacognosy',
      'Dr Kim Liu Kang',
      0.0,
    ],
  ];

  late int numOfCourses = COURSE_LIST.length;

  @override
  void initState() {
    getQuote;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _user = widget._user;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 10, 10, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello, ${_user.displayName!.split(" ")[0]}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: constants.buttonTextFont,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                _user.photoURL != null
                    ? InkWell(
                        onTap: _onAvatarMenuIconTap,
                        child: SizedBox(
                          height: 40,
                          child: ClipOval(
                            child: Material(
                              color: CustomColors.firebaseGrey.withOpacity(0.3),
                              child: Image.network(
                                _user.photoURL!,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: _onAvatarMenuIconTap,
                        child: SizedBox(
                          height: 40,
                          child: ClipOval(
                            child: Material(
                              color: CustomColors.firebaseGrey.withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: CustomColors.firebaseGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            Text(
              quotesLoaded.isNotEmpty
                  ? quotesLoaded[0]['body']!.toString()
                  : '',
            ),
            Text(
              'COURSES',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: constants.buttonTextFont,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('courses').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  // ignore: prefer_const_constructors
                  return CourseCardPlaceholderWithProgress();
                }
                return Container(
                  padding: const EdgeInsets.all(5),
                  height: 250,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CourseCard(
                        courseID: snapshot.data!.docs[index].id,
                        courseTitle: snapshot.data!.docs[index]['courseTitle'],
                        courseCategory: snapshot.data!.docs[index]
                            ['courseCategory'],
                        courseAuthor: snapshot.data!.docs[index]
                            ['courseAuthor'],
                        coursePrice: snapshot.data!.docs[index]['coursePrice'],
                      );
                    },
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await Authentication.signOut(context: context);
              },
              child: const Text('Log out'),
            ),
            ElevatedButton(
              onPressed: () {
                addQuotes();
              },
              child: const Text('Add Quote'),
            ),
            ElevatedButton(
              onPressed: () {
                getQuote();
              },
              child: const Text('Get Quote'),
            ),
          ],
        ),
      ),
    );
  }
}

//
//
//
//
//
//
class CourseCardPlaceholderWithProgress extends StatelessWidget {
  const CourseCardPlaceholderWithProgress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CourseCardPlaceholder(),
        // ignore: prefer_const_constructors
        Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const CircularProgressIndicator(color: constants.primaryColor),
            const SizedBox(height: 5),
            const Text(
              "Loading... Please Wait",
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text("Too slow? Check INTERNET CONNNECTION"),
          ],
        ),
      ],
    );
  }
}
