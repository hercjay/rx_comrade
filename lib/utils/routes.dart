import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rx_comrade/Pages/homepage3.dart';
import 'package:rx_comrade/Pages/landing_page.dart';
import 'package:rx_comrade/Pages/login_page.dart';
import 'package:rx_comrade/utils/not_found.dart';

class Routes {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    User? user = FirebaseAuth.instance.currentUser!;

    return MaterialPageRoute(builder: (context) {
      switch (settings.name) {
        case "homepage":
          // ignore: prefer_const_constructors
          return HomePage3(
            user: user,
          );
        case "login":
          // ignore: prefer_const_constructors
          return LoginPage();
        case "landing_page":
          // ignore: prefer_const_constructors
          return LandingPage();
      }

      // ignore: prefer_const_constructors
      return NotFound();
    });
  }
}
