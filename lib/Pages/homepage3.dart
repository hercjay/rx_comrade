import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rx_comrade/Pages/no_internet.dart';
import 'package:rx_comrade/models/course_card.dart';
import 'package:rx_comrade/screens/home.dart';
import 'package:rx_comrade/screens/inventory.dart';
import 'package:rx_comrade/screens/leaderboard.dart';
import 'package:rx_comrade/utils/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart' as constants;
import '../main.dart';
import '../res/custom_colors.dart';
import '../screens/battle.dart';

class HomePage3 extends StatefulWidget {
  const HomePage3({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  State<HomePage3> createState() => _HomePage3State();
}

class _HomePage3State extends State<HomePage3> {
  late User _user;
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

  //FOR BOTTOM NAVIGATION
  int _selectedIndex = 0;
  bool _justLoaded = true;
  Widget _currentScreen = Scaffold();
  _onNavItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      _justLoaded = false;
    });

    switch (index) {
      case 0:
        setState(() {
          _currentScreen = HomeScreen(user: _user);
        });
        break;
      case 1:
        setState(() {
          _currentScreen = LeaderboardScreen();
        });
        break;
      case 2:
        setState(() {
          _currentScreen = BattleScreen();
        });
        break;
      case 3:
        setState(() {
          _currentScreen = InventoryScreen();
        });
        break;
      default:
        setState(() {
          _currentScreen = HomeScreen(user: _user);
        });
        break;
    }
  }

  final int userHercads = 5438;
  final int userTrophies = 0985;
  final int userGems = 78745;

  //MENU ITEMS CLICK HANDLERS
  void _onAvatarMenuIconTap() {
    print('Avatar Menu Clicked');
  }

  void _onMenuIconTap() {
    print('Main Menu Clicked');
  }

  void _onNotificationsIconTap() {
    print('Notifications menu icon Clicked');
  }

  //for internet connection checks
  late StreamSubscription subscription;
  var isConnected = false;
  bool isAlertSet = false;

  Future getConnectivity() async {
    //EasyLoading.showInfo('Checking Network');
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isConnected = await InternetConnectionChecker().hasConnection;
      if (!isConnected && isAlertSet == false) {
        setState(() {
          isAlertSet = true;
        });
      }
    });
    //EasyLoading.dismiss();
  }

  @override
  void initState() {
    _user = widget._user;
    getConnectivity();
    setSwitchValue();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

//when back button is pressed on the homepage
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            content: const Text('Do you want to exit Rx Comrade App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: constants.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () =>
                    //Navigator.of(context).pop(true), // <-- SEE HERE
                    SystemNavigator.pop(), //quit app
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Color.fromARGB(255, 187, 4, 20),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                //when button is pressed, check connection again and proceed or redraw dialog
                Navigator.pop(context, 'Cancel');
                setState(() {
                  isAlertSet = false;
                });
                isConnected = await InternetConnectionChecker().hasConnection;
                if (!isConnected) {
                  showDialogBox();
                  setState(() {
                    isAlertSet = true;
                  });
                }
              },
              child: const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      );

//
//
  @override
  Widget build(BuildContext context) {
    getConnectivity;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //menu icon
                InkWell(
                  onTap: _onMenuIconTap,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: constants.textFieldBg.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 40,
                    child: Image.asset(
                      'assets/icons/menu.png',
                      //color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                //inventory icons and count
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/hercads.png',
                      height: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      //if string is longer than 4 chars, display with ..
                      userHercads.toString().length < 4
                          ? userHercads.toString()
                          : '${userHercads.toString().substring(0, 3)}..',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    //trophy
                    const SizedBox(width: 12),
                    Image.asset(
                      'assets/icons/trophy.png',
                      height: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      //if string is longer than 4 chars, display with ..
                      userTrophies.toString().length < 4
                          ? userTrophies.toString()
                          : '${userTrophies.toString().substring(0, 3)}..',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    //gem
                    const SizedBox(width: 12),
                    Image.asset(
                      'assets/icons/gem.png',
                      height: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      userGems.toString().length < 4
                          ? userGems.toString()
                          : '${userGems.toString().substring(0, 3)}..',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
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
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: constants.textFieldBg.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(500),
                      ),
                      height: 40,
                      width: 40,
                    ),
                    Positioned(
                      top: -3,
                      right: -3,
                      child: IconButton(
                        onPressed: _onNotificationsIconTap,
                        icon: const Icon(Icons.notifications),
                        alignment: Alignment.center,
                      ),
                    ),
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: SizedBox(
                        height: 19,
                        width: 19,
                        child: ClipOval(
                          child: Material(
                            color: constants.secondaryColor,
                            child: Text(
                              '99+',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: _justLoaded ? HomeScreen(user: _user) : _currentScreen,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onNavItemTap,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/home.png',
                  height: 24,
                  color: Colors.grey,
                ),
                label: 'Home',
                activeIcon: Image.asset('assets/icons/home.png', height: 24),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/leaderboard.png',
                  height: 24,
                  color: Colors.grey,
                ),
                label: 'Leaderboard',
                activeIcon:
                    Image.asset('assets/icons/leaderboard.png', height: 24),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/brain.png',
                  height: 24,
                  color: Colors.grey,
                ),
                label: 'Battle',
                activeIcon: Image.asset('assets/icons/brain.png', height: 24),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/shop.png',
                  height: 24,
                  color: Colors.grey,
                ),
                label: 'Inventory',
                activeIcon: Image.asset('assets/icons/shop.png', height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
