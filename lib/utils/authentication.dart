import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rx_comrade/Pages/login_page.dart';
import 'package:rx_comrade/Pages/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Pages/homepage2.dart';
import '../Pages/homepage3.dart';

class Authentication {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      duration: Duration(milliseconds: 1000),
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.redAccent,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage3(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      // try {
      //   final UserCredential userCredential =
      //       await auth.signInWithPopup(authProvider);
      // } catch (e) {
      //   print(e);
      // }

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content:
                'An error occurred while attempting to sign in with Google. Please try again.',
          ),
        );
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'This account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'An error occured while accessing your credentials. Please try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content:
                  'An error occured while attempting to use Google Sign In. Please try again.',
            ),
          );
        }
      }
    }

    // Check if user exists in Firestore
    final DocumentSnapshot userDocumentSnapshot =
        await _firestore.collection('users').doc(user!.uid).get();

    if (!userDocumentSnapshot.exists) {
      // User doesn't exist in Firestore, add the user data
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoURL
      });
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'An error occured while signing out. Please try again.',
        ),
      );
    }
  }
}
