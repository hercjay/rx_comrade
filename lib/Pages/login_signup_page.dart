import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rx_comrade/Pages/homepage.dart';
import '../constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import 'landing_page.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({Key? key}) : super(key: key);

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool isSwitched = constants.isDarkMode;
  bool _loginSuccessful = false;

//Implementing this again because somehow, the constants.isDarkMode value may not work?
  void setSwitchValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //check if preferred theme already exists (null if it does not, create one)
    if (prefs.getBool('isUserDarkMode') == null) {
      await prefs.setBool('isUserDarkMode', false);
      isSwitched = false;
    } else {
      bool? isUserDarkMode = prefs.getBool('isUserDarkMode');

      /// set theme mode according to preferred value
      if (isUserDarkMode == true) {
        isSwitched = true;
      } else {
        isSwitched = false;
      }
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future signInWithGoogle() async {
    print('calling google signin now1');
    try {
      print('calling google signin now');
      await _googleSignIn.signIn();
      setState(() {
        _loginSuccessful = true;
      });
    } catch (error) {
      print(error);
    }
  }

//
//
//
//
//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isSwitched
                  ? // check if darkmode, color white, else color black
                  const Text(
                      'Dark Mode',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Dark Mode',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      MyApp.of(context).changeTheme(ThemeMode.dark);
                    } else {
                      MyApp.of(context).changeTheme(ThemeMode.light);
                    }
                    isSwitched = value;
                  });
                },
                activeTrackColor: constants.primaryColorLight,
                activeColor: constants.primaryColor,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/images/festivity.svg',
                width: MediaQuery.of(context).size.width * 0.8,
                //height: MediaQuery.of(context).size.height * 0.25,
                //fit: BoxFit.scaleDown
              ),
              //
              const SizedBox(height: 5),
              Text(
                'Hello Rx Comrade,',
                style: TextStyle(
                  fontSize: constants.largeFont3,
                  fontFamily: 'TitilliumWeb',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Welcome back to the Pharma World,',
                style: TextStyle(
                  fontSize: constants.landingFontSize2,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              Text(
                'Are you for Peace or Vawulence?',
                style: TextStyle(
                  fontSize: constants.landingFontSize2,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  signInWithGoogle;
                  if (_loginSuccessful) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomePage(user: _googleSignIn.currentUser),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(5),
                  elevation: 10,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/google.svg',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Sign In with Google',
                        style: TextStyle(
                          color: constants.textDarkMode,
                          fontSize: constants.buttonTextFont,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
