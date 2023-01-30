/* import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../constants.dart' as constants;
import '../main.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  bool isSwitched = constants.isDarkMode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            if (value == true) {
              MyApp.of(context).changeTheme(ThemeMode.dark);
            } else {
              MyApp.of(context).changeTheme(ThemeMode.light);
            }
            isSwitched = value;
            print(isSwitched);
          });
        },
        activeTrackColor: constants.primaryColorLight,
        activeColor: constants.primaryColor,
      ),
    );
  }
}
 */