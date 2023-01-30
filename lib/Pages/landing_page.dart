import 'package:flutter/material.dart'
    show
        Alignment,
        BuildContext,
        Center,
        Colors,
        Column,
        Container,
        Curves,
        EdgeInsets,
        FontWeight,
        GestureDetector,
        Image,
        Key,
        MainAxisAlignment,
        MaterialPageRoute,
        Navigator,
        Padding,
        PageController,
        PageView,
        PaintingStyle,
        Row,
        Scaffold,
        SizedBox,
        Stack,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        TextAlign,
        TextStyle,
        Widget;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:rx_comrade/Pages/homepage.dart';
import 'package:rx_comrade/Pages/login_page.dart';
import 'package:rx_comrade/Pages/login_screen.dart';
import 'package:rx_comrade/utils/authentication.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constants.dart' as constants;

import 'login_signup_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
//create controller to keep track of pages and also number of pages variable
  int numOfPages = 5;
  bool onLastPage = false;
  final PageController _controller = PageController();
  bool _justLaunched = true;

  @override
  void initState() {
    //call auth to check if user is logged in, and display homepage if so (logic in authentication.dart file)
    Authentication.initializeFirebase(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage =
                    (index == numOfPages - 1); //if on lastpage, set to true
              });
            },
            children: [
              const LandingPageScreen0(),
              const LandingPageScreen1(),
              const LandingPageScreen2(),
              const LandingPageScreen3(),
              const LandingPageScreen4(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.animateToPage(numOfPages - 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SmoothPageIndicator(
                    controller: _controller,
                    count: numOfPages,
                    effect: const SlideEffect(
                        spacing: 8.0,
                        radius: 4.0,
                        dotWidth: 16.0,
                        dotHeight: 16.0,
                        paintStyle: PaintingStyle.stroke,
                        strokeWidth: 1.5,
                        dotColor: Colors.grey,
                        activeDotColor: constants.primaryColor),
                    onDotClicked: (index) {
                      //_controller.jumpToPage(index);
                      _controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    }),
                onLastPage //if onlastpage return widget DONE, else return widget NEXT
                    ? GestureDetector(
                        onTap: () {
                          //Proceed to homepage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginPage();
                                //return HomePage(
                                // user: _googleSignIn.currentUser);
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Container(
            alignment: const Alignment(0, 0.95),
            child: Text(
              'Rx Comrade\nHercjay Studios',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: constants.smallFont,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//SCREEN 0
class LandingPageScreen0 extends StatelessWidget {
  const LandingPageScreen0({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
/*     EasyLoading.showInfo(
      'Loading. Please wait...',
      duration: const Duration(
        milliseconds: 3000,
      ),
    ); */
    //EasyLoading.showProgress;
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Image.asset('assets/images/quiz_custom.png'),
                  Text(
                    'Thank You for installing Rx Comrade',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: constants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: constants.landingFontSize,
                    ),
                  ),
                  Text(
                    'Swipe to Continue...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: constants.landingFontSize2,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//SCREEN 1
class LandingPageScreen1 extends StatelessWidget {
  const LandingPageScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Lottie.asset('assets/lottie/floatingGuy.zip'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'An Rx Knowledge Hub for You!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: constants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: constants.landingFontSize,
                    ),
                  ),
                  Text(
                    'Take courses, read blogs, and share knowledge around the Rx Profession.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: constants.landingFontSize2,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//SCREEN 2
class LandingPageScreen2 extends StatelessWidget {
  const LandingPageScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Lottie.asset('assets/lottie/LabcoatManIconsPopAround.zip'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Take Daily Rx Challenges!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: constants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: constants.landingFontSize,
                    ),
                  ),
                  Text(
                    'like Quick Quizzes and Case Studies to maintain and improve your Rx knowledge!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: constants.landingFontSize2,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//SCREEN 3
class LandingPageScreen3 extends StatelessWidget {
  const LandingPageScreen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Lottie.asset('assets/lottie/challengeHands.zip'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Battle Other Rx Comrades',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: constants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: constants.landingFontSize,
                    ),
                  ),
                  Text(
                    'Interact with other Pharmacists and Pharmacy students. Challenge them to battles, win and sit ontop of the Leaderboard like a boss!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: constants.landingFontSize2,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//SCREEN 4
class LandingPageScreen4 extends StatelessWidget {
  const LandingPageScreen4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Lottie.asset('assets/lottie/appAnimation.zip'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Rx Comrade App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: constants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: constants.landingFontSize,
                    ),
                  ),
                  Text(
                    'Take your Pharmacy Career to the next level through LEARNING, NETWORKING and having FUN!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: constants.landingFontSize2,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
