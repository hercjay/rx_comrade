/// gist for https://stackoverflow.com/a/67714404/2301224
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rx_comrade/Pages/homepage.dart';
import 'package:rx_comrade/Pages/login_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart' as constants;

import 'Pages/landing_page.dart';
import 'firebase_options.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  /// InheritedWidget style accessor to our State object.
  /// We can call this static method from any descendant context to find our
  /// State object and switch the themeMode field value & call for a rebuild.
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

/// Our State object
class _MyAppState extends State<MyApp> {
  /// 1) our themeMode "state" field
  ThemeMode _themeMode = ThemeMode.system;
  GoogleSignInAccount? _currentUser;

//on app start, try to sign in existing user and set value to variable
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  //body builder
  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return HomePage(user: user);
    } else {
      return const LandingPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    getandSetTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'TitilliumWeb',
        scaffoldBackgroundColor: constants.bgLightMode,
        primaryColor: constants.primaryColor,
        primaryColorDark: constants.textLightMode2,
        appBarTheme: ThemeData.dark().appBarTheme.copyWith(
              backgroundColor: constants.appBarBgLightMode,
            ),
      ),
      //darkTheme: ThemeData.dark(),
      //darkTheme: ThemeData.dark().copyWith(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'TitilliumWeb',
        primaryColor: constants.primaryColor,
        primaryColorLight: constants.primaryColorLight,
        primaryColorDark: constants.textDarkMode2,
        scaffoldBackgroundColor: constants.bgDarkMode,
        appBarTheme: ThemeData.dark().appBarTheme.copyWith(
              backgroundColor: constants.appBarBgDarkMode,
            ),
        floatingActionButtonTheme:
            ThemeData.dark().floatingActionButtonTheme.copyWith(
                  backgroundColor: constants.primaryColor,
                ),
      ),
      themeMode: _themeMode,
      home: SafeArea(
        //child: LandingPage(),
        child: _buildBody(),
      ),
    );
  }

  /// 3) Call this to change theme from any context using "of" accessor
  /// e.g.:
  /// MyApp.of(context).changeTheme(ThemeMode.dark);
  ///
  void changeTheme(ThemeMode themeMode) async {
    setState(() {
      _themeMode = themeMode;
    });
    //save new userTheme preference to memory and constants file
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (themeMode == ThemeMode.light) {
      //if user chose light theme, then set isUserDarkMode to false
      await prefs.setBool('isUserDarkMode', false);
      constants.isDarkMode = false;
    } else {
      await prefs.setBool('isUserDarkMode', true);
      constants.isDarkMode = true;
    }
  }

  //get the current theme and set it
  Future getandSetTheme() async {
    final prefs = await SharedPreferences.getInstance();
    ThemeMode userTheme;

    //check if preferred theme already exists (null if it does not, create one)
    if (prefs.getBool('isUserDarkMode') == null) {
      await prefs.setBool('isUserDarkMode', false);
      userTheme = ThemeMode.dark;
      constants.isDarkMode = true;
    } else {
      bool? isUserDarkMode = prefs.getBool('isUserDarkMode');

      /// set theme mode according to preferred value
      if (isUserDarkMode == true) {
        userTheme = ThemeMode.dark;
        constants.isDarkMode = true;
      } else {
        userTheme = ThemeMode.light;
        constants.isDarkMode = false;
      }
    }
    setState(() {
      _themeMode = userTheme;
      changeTheme(_themeMode);
    });
  }
}
