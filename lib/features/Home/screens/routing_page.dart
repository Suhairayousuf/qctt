// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../main.dart';
// import 'navigation_page.dart';
//
// class RoutingPage extends StatefulWidget {
//   const RoutingPage({super.key});
//
//   @override
//   State<RoutingPage> createState() => _RoutingPageState();
// }
//
// class _RoutingPageState extends State<RoutingPage> {
//   bool isFirstTime = true;
//   @override
//   void initState() {
//     super.initState();
//     _checkFirstTime();
//   }
//   Future<void> _checkFirstTime() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? hasVisited = prefs.getBool('hasVisited');
//
//     if (hasVisited == true) {
//       // If the app has been opened before, navigate directly to NavigationBarPage
//       Navigator.pushNamedAndRemoveUntil(
//         context,
//         '/NavigationBarPage', // Named route
//             (route) => false,     // This removes all previous routes
//       );
//       // Navigator.of(context).pushReplacement(
//       //   MaterialPageRoute(builder: (_) => NavigationBarPage()),
//       // );
//     } else {
//       // If this is the first time, set the flag and stay on the splash screen
//       await prefs.setBool('hasVisited', true);
//       Navigator.pushNamedAndRemoveUntil(
//         context,
//         '/SplashScreenWidget', // Named route
//             (route) => false,     // This removes all previous routes
//       );
//       // Navigator.of(context).pushReplacement(
//       //   MaterialPageRoute(builder: (_) => SplashScreenWidget()),
//       // );
//       setState(() {
//         isFirstTime = true;
//
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     width=MediaQuery.of(context).size.width;
//     height=MediaQuery.of(context).size.height;
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../main.dart';

class RoutingPage extends StatefulWidget {
  @override
  _RoutingPageState createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  bool isFirstTime = true;
  // String? globalUserId;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initializeUserId();
    await _checkFirstTime();
  }

  Future<void> _initializeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globalUserId = prefs.getString('userId');
    if (globalUserId == null) {
      var uuid = Uuid();
      globalUserId = uuid.v4(); // Generate unique user ID
      await prefs.setString('userId', globalUserId!);
    }
    print('User ID: $globalUserId'); // Debugging log to ensure it's generated
  }

  Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasVisited = prefs.getBool('hasVisited');

    if (hasVisited == true) {
      // Navigate to NavigationBarPage
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/NavigationBarPage',
            (route) => false,
      );
    } else {
      // First-time visit
      await prefs.setBool('hasVisited', true);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/SplashScreenWidget',
            (route) => false,
      );
      setState(() {
        isFirstTime = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
