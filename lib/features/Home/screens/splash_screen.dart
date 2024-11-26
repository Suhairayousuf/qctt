// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../core/constants/variables.dart';
// import 'add_group_page.dart';
// import 'navigation_page.dart';
// var height;
// var width;
// class SplashScreenWidget extends StatefulWidget {
//
//   const SplashScreenWidget({Key? key}) : super(key: key);
//
//   @override
//   State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
// }
//
// class _SplashScreenWidgetState extends State<SplashScreenWidget> {
//
// @override
// //   void didChangeDependencies() {
// //     // TODO: implement didChangeDependencies
// //     super.didChangeDependencies();
// //     checkDate();
// //     setState(() {
// //
// //     });
// //
// // }
//
//
//   void initState() {
//
//     super.initState();
//
//     // Timer to move to the next screen after 3 seconds
//     Timer(Duration(seconds: 2), () {
//       Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => NavigationBarPage())
//       );
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     width=MediaQuery.of(context).size.width;
//     height=MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Center(
//
//         child: Container(
//           height: width*0.25,
//           width: width*0.25,
//           color: Colors.black,
//           child: Center(child: Text('Logo',style: GoogleFonts.inter(color: Colors.white),)),
//         )
//         // Image.asset('assets/images/Pixelfinish_Logo.png',height: w*0.5,width: w*0.5,), // Splash logo
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation_page.dart';
var height;
var width;
class SplashScreenWidget extends StatefulWidget {
  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => NavigationBarPage()),
      );
    } else {
      // If this is the first time, set the flag and stay on the splash screen
      await prefs.setBool('hasVisited', true);
      setState(() {
        isFirstTime = true;
      });
    }
  }
  // void initState() {
  //
  //   super.initState();
  //
  //   // Timer to move to the next screen after 3 seconds
  //   Timer(Duration(seconds: 2), () {
  //     Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (_) => NavigationBarPage())
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    if (!isFirstTime) {
      // Return a blank screen while checking first-time status
      return Scaffold(body: Container());
    }
    return Scaffold(
      body: PageView(
        children: [
          SplashPage(
            color: Colors.white,
            title: "Welcome",
            description: "This is the first slide.",
            isLastPage: false,
          ),
          SplashPage(
            color: Colors.white,
            title: "Explore",
            description: "This is the second slide.",
            isLastPage: false,

          ),
          SplashPage(
            color: Colors.white,
            title: "Get Started",
            description: "This is the third slide.",
            isLastPage: true,
            onNext: () {
              Navigator.pushReplacementNamed(context, '/NavigationBarPage');
            },
          ),
        ],
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  final Color color;
  final String title;
  final String description;
  final bool isLastPage;
  final VoidCallback? onNext;

  SplashPage({
    required this.color,
    required this.title,
    required this.description,
    this.isLastPage = false,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset('assets/images/user.png',height: 100,width: 100,),
          ),
          
          Text(
            title,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          if (isLastPage) ...[
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: onNext,
              child: Text("Get Started"),
            ),
          ],
        ],
      ),
    );
  }
}
