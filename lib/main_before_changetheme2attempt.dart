/// gist for https://stackoverflow.com/a/67714404/2301224
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/landing_page.dart';

void main() async {
  //ensure that sharedpreferences are loaded before starting app
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  ThemeMode userTheme;

  //check if preferred theme already exists (null if it does not, create one)
  if (prefs.getBool('isUserDarkMode') == null) {
    await prefs.setBool('isUserDarkMode', false);
    userTheme = ThemeMode.dark;
  } else {
    bool? isUserDarkMode = prefs.getBool('isUserDarkMode');

    /// set theme mode according to preferred value
    if (isUserDarkMode == true) {
      userTheme = ThemeMode.dark;
    } else {
      userTheme = ThemeMode.light;
    }
  }

  runApp(MyApp(
    userTheme: userTheme,
  ));
}

class MyApp extends StatefulWidget {
  final ThemeMode userTheme;

  const MyApp({
    required this.userTheme,
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

  @override
  Widget build(BuildContext context) {
    changeTheme(widget.userTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: SafeArea(
        child: const LandingPage(),
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

    //save new userTheme preference to memory
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (themeMode == ThemeMode.light) {
      //if user chose light theme, then set isUserDarkMode to false
      await prefs.setBool('isUserDarkMode', false);
    } else {
      await prefs.setBool('isUserDarkMode', true);
    }
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Choose your theme:',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// //////////////////////////////////////////////////////
                /// Change theme & rebuild to show it using these buttons
                /// to find our State object and call changeTheme()
                ElevatedButton(
                    onPressed: () =>
                        MyApp.of(context).changeTheme(ThemeMode.light),
                    child: Text('Light')),
                ElevatedButton(
                    onPressed: () =>
                        MyApp.of(context).changeTheme(ThemeMode.dark),
                    child: Text('Dark')),

                /// //////////////////////////////////////////////////////
              ],
            ),
          ],
        ),
      ),
    );
  }
}
