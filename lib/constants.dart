import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//storyset icons

double mobileScreen = 480;
double tabletScreen = 840;
double desktopScreen = 841; //and above

double maxImgWidth = 50000;

const primaryColor = Color(0xFF338C0B);
const primaryColorLight = Color.fromARGB(255, 104, 189, 67);
const primaryColorDark = Color(0xFF1E5C00);

const secondaryColor = Color.fromARGB(255, 187, 4, 20);

const bgDarkMode = Color(0xFF001824); //Color.fromARGB(255, 3, 1, 15);
const appBarBgDarkMode =
    Color.fromARGB(255, 0, 19, 29); //Color.fromARGB(255, 5, 1, 27);
const bgLightMode = Color.fromARGB(255, 236, 236, 236);
const appBarBgLightMode = Color.fromARGB(255, 230, 230, 230);

const textDarkMode = Color.fromARGB(255, 255, 255, 255);
const textDarkMode2 = Color.fromARGB(255, 201, 198, 198);
const textDarkMode3 = Color.fromARGB(255, 145, 145, 145);
const textLightMode = Color.fromARGB(255, 0, 0, 0);
const textLightMode2 = Color.fromARGB(255, 58, 58, 58);
const textLightMode3 = Color.fromARGB(255, 102, 102, 102);

const textFieldBg = Color.fromARGB(66, 158, 158, 158);
const textFieldBorder = Color.fromARGB(115, 255, 255, 255);

//fonts
double largeFont = 50;

double largeFont2 = 40;
double largeFont3 = 32;
double landingFontSize = 25;
double buttonTextFont = 20.0;
double courseCardTitle = 17.0;
double landingFontSize2 = 15;
double smallFont = 12;

//Text Styles
TextStyle titleTextStyle = const TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w700,
  //color: primaryColor,
);

TextStyle cardTitleStyle = const TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w700,
  overflow: TextOverflow.ellipsis,
  //color: primaryColor,
);

Color setTitleColor(context) {
  Color c = Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withOpacity(0.8)
      : Colors.black;
  return c;
}

Color setCardColor(context) {
  Color c = Theme.of(context).brightness == Brightness.dark
      ? Color.fromARGB(255, 11, 41, 56)
      : Color.fromARGB(255, 241, 241, 241); //Color.fromARGB(255, 236, 236, 236)
  return c;
}

Color setCardShadowColor(context) {
  Color c = Theme.of(context).brightness == Brightness.dark
      ? Color.fromARGB(255, 11, 41, 56)
      : Colors.grey.withOpacity(0.32);
  return c;
}

//APP Names
const appName = 'Rx Comrade';
const companyName = 'Hercjay Studios';

//user preferences stored on phone

bool isDarkMode = false;

//SharedPreferences prefs = await SharedPreferences.getInstance();
// bool boolValue = _prefs.getBool('option');

Future<bool> getThemeAndSetTheBoolean() async {
  final prefs = await SharedPreferences.getInstance();

  //check if preferred theme already exists (null if it does not, create one)
  if (prefs.getBool('isUserDarkMode') == null) {
    await prefs.setBool('isUserDarkMode', false);
    isDarkMode = false;
  } else {
    bool? isUserDarkMode = prefs.getBool('isUserDarkMode');

    /// set theme mode according to preferred value
    if (isUserDarkMode == true) {
      isDarkMode = true;
    } else {
      isDarkMode = false;
    }
  }
  return isDarkMode;
}
