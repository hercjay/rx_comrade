import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rx_comrade/Pages/homepage.dart';
import '../constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({Key? key}) : super(key: key);

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool isSwitched = constants.isDarkMode;

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

  //textfield controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //sign in methods
  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future signInWithGoogle() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    setSwitchValue(); //make darkmode switch toggle go on the correct side
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? googleUser = _currentUser;

    //Google user is signed in, redirect to homepage
    if (googleUser != null) {
      return const Scaffold(
          //body: HomePage(),
          );
    }
    //
    //Google user is not signed in, show signIn form
    else {
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
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/images/festivity.svg',
                //width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.25,
                //fit: BoxFit.scaleDown
              ),
              //
              const SizedBox(height: 5),
              Text(
                'Hello Rx Comrade,',
                style: TextStyle(
                  fontSize: constants.landingFontSize,
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
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: constants.textFieldBg,
                  //border: Border.all(
                  //width: 1,
                  //color: constants.textFieldBorder,
                  //),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Email',
                  ),
                ),
              ),
              //
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: constants.textFieldBg,
                  //border: Border.all(
                  //width: 1,
                  //color: constants.textFieldBorder,
                  //),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Password',
                  ),
                ),
              ),
              //
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: constants.textDarkMode,
                    fontSize: constants.buttonTextFont,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: signIn,
                child: Container(
                  alignment: const Alignment(0, 0),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15.0,
                        color: constants.textLightMode2,
                        offset: Offset.fromDirection(-60, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: constants.textDarkMode,
                      fontSize: constants.buttonTextFont,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('OR'),
              const SizedBox(height: 10),
              //
              //sign in with GOOGLE container
              Container(
                alignment: const Alignment(0, 0),
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: constants.secondaryColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15.0,
                      color: constants.textLightMode2,
                      offset: Offset.fromDirection(-60, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/google.svg',
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: signInWithGoogle,
                        child: Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: constants.textDarkMode,
                            fontSize: constants.buttonTextFont,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), //signIn with google container end
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.overline,
                    decorationThickness: 3,
                    decorationColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    } //end of else
  }
}
