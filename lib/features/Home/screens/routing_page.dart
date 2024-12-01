import 'package:flutter/material.dart';
import 'package:qctt/features/Home/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import 'navigation_page.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({super.key});

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  bool isFirstTime = true;
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }
  Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasVisited = prefs.getBool('hasVisited');

    if (hasVisited == true) {
      // If the app has been opened before, navigate directly to NavigationBarPage
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/NavigationBarPage', // Named route
            (route) => false,     // This removes all previous routes
      );
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (_) => NavigationBarPage()),
      // );
    } else {
      // If this is the first time, set the flag and stay on the splash screen
      await prefs.setBool('hasVisited', true);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/SplashScreenWidget', // Named route
            (route) => false,     // This removes all previous routes
      );
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (_) => SplashScreenWidget()),
      // );
      setState(() {
        isFirstTime = true;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
