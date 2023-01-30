import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rx_comrade/Pages/login_signup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  var _user;

  @override
  Widget build(BuildContext context) {
    //set user value by checking account type that is logged in
    if (FirebaseAuth.instance.currentUser == null) {
      setState(() {
        _user = _googleSignIn.currentUser;
      });
    } else {
      setState(() {
        _user = FirebaseAuth.instance.currentUser;
      });
    }

    //if user value is null, return back to login page
    if (_user == null) {
      return const Scaffold(
        body: LoginSignupPage(),
      );
    }
    //
    else {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                'Signed in through: ' + _user.email,
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text('Sign out'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
