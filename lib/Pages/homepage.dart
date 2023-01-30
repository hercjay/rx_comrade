import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rx_comrade/Pages/login_signup_page.dart';

class HomePage extends StatefulWidget {
  final GoogleSignInAccount? user;
  const HomePage({Key? key, required this.user}) : super(key: key);

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

  Future<void> _handleSignOut() => _googleSignIn.signOut();

  GoogleSignInAccount? user;

  bool _signedOut = false;
//
//
//

  Widget _buildBody() {
    if (widget.user == null) {
      setState(() {
        _signedOut = true;
      });
    } else {
      setState(() {
        _signedOut = false;
      });
      user = widget.user;
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              // ignore: prefer_interpolation_to_compose_strings
              'signed in as: ' + widget.user!.email,
            ),
            ElevatedButton(
              onPressed: () {
                _handleSignOut;
                setState(() {
                  _signedOut = true;
                });
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
  //
  //
  //

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user;
    return _buildBody();
  }
}
