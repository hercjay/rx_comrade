//Implementing this again because somehow, the constants.isDarkMode value may not work?
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeUtil {
  static getSwitchValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //check if preferred theme already exists (null if it does not, create one)
    if (prefs.getBool('isUserDarkMode') == null) {
      await prefs.setBool('isUserDarkMode', false);
      return false;
    } else {
      bool? isUserDarkMode = prefs.getBool('isUserDarkMode');

      /// set theme mode according to preferred value
      if (isUserDarkMode == true) {
        return true;
      } else {
        return false;
      }
    }
  }
}
