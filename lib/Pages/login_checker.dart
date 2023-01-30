import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rx_comrade/Pages/homepage.dart';
import 'package:rx_comrade/Pages/landing_page.dart';
import 'package:rx_comrade/Pages/login_signup_page.dart';

class LoginChecker extends StatelessWidget {
  LoginChecker({Key? key}) : super(key: key);

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (_googleSignIn.currentUser == null) {
      //not currently signed in via google, check firebase signin
      return Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              //snapshot contains details of logged in user
              return HomePage(user: _googleSignIn.currentUser);
            } else {
              return LoginSignupPage();
              //return LandingPage();
            }
          }),
        ),
      );
    } else {
      //signed in via google, go to homepage
      return Scaffold(
          //body: HomePage(),
          );
    }
  }
}
