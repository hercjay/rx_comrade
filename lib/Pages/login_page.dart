import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rx_comrade/Pages/homepage.dart';
import 'package:rx_comrade/Pages/no_internet.dart';
import '../constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../widgets/google_sign_in_button.dart';
import 'landing_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  @override
  void initState() {
    setSwitchValue();
    super.initState();
  }

//
//
//
//
//
  @override
  Widget build(BuildContext context) {
    setSwitchValue;
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
                'assets/images/festivityG.svg',
                width: MediaQuery.of(context).size.width * 0.9,
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
              GoogleSignInButton(),
            ],
          ),
        ),
      ),
    );
  }
}
