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
import 'package:google_fonts/google_fonts.dart';
import 'package:qctt/core/constants/images/images.dart';
import 'package:qctt/features/Home/screens/routing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/pallette/pallete.dart';
import '../../../main.dart';
import 'navigation_page.dart';

// class SplashScreenWidget extends StatefulWidget {
//   @override
//   State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
// }
//
// class _SplashScreenWidgetState extends State<SplashScreenWidget> {
//   // bool isFirstTime = true;
//   @override
//   void initState() {
//     super.initState();
//     // _checkFirstTime();
//   }
//   // Future<void> _checkFirstTime() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   bool? hasVisited = prefs.getBool('hasVisited');
//   //
//   //   if (hasVisited == true) {
//   //     // If the app has been opened before, navigate directly to NavigationBarPage
//   //     Navigator.of(context).pushReplacement(
//   //       MaterialPageRoute(builder: (_) => NavigationBarPage()),
//   //     );
//   //   } else {
//   //     // If this is the first time, set the flag and stay on the splash screen
//   //     await prefs.setBool('hasVisited', true);
//   //     setState(() {
//   //       isFirstTime = true;
//   //     });
//   //   }
//   // }
//   // void initState() {
//   //
//   //   super.initState();
//   //
//   //   // Timer to move to the next screen after 3 seconds
//   //   Timer(Duration(seconds: 2), () {
//   //     Navigator.of(context).pushReplacement(
//   //         MaterialPageRoute(builder: (_) => NavigationBarPage())
//   //     );
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     width=MediaQuery.of(context).size.width;
//     height=MediaQuery.of(context).size.height;
//     // if (!isFirstTime) {
//     //   // Return a blank screen while checking first-time status
//     //   return Scaffold(body: Container());
//     // }
//     return Scaffold(
//       body: PageView(
//         children: [
//           SplashPage(
//             color: Colors.white,
//             title: "Welcome",
//             description: "This is the first slide.",
//             isLastPage: false,
//           ),
//           SplashPage(
//             color: Colors.white,
//             title: "Explore",
//             description: "This is the second slide.",
//             isLastPage: false,
//
//           ),
//           SplashPage(
//             color: Colors.white,
//             title: "Get Started",
//             description: "This is the third slide.",
//             isLastPage: true,
//             onNext: () {
//               Navigator.pushReplacementNamed(context, '/NavigationBarPage');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SplashPage extends StatelessWidget {
//   final Color color;
//   final String title;
//   final String description;
//   final bool isLastPage;
//   final VoidCallback? onNext;
//
//   SplashPage({
//     required this.color,
//     required this.title,
//     required this.description,
//     this.isLastPage = false,
//     this.onNext,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: color,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             child: Image.asset('assets/images/user.png',height: 100,width: 100,),
//           ),
//
//           Text(
//             title,
//             style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
//           ),
//           SizedBox(height: 20),
//           Text(
//             description,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 18, color: Colors.black),
//           ),
//           if (isLastPage) ...[
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: onNext,
//               child: Text("Get Started"),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class SplashScreenWidget extends StatefulWidget {
  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }
  void dispose() {
    _pageController.dispose(); // Dispose the controller when the widget is removed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     width = MediaQuery.of(context).size.width;
     height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                SplashPage(
                  color: Colors.white,
                  title: "Click to open the app",
                  description: "Open the app to make the\n hassle free calling experience\n of your life",
                  isLastPage: false,
                ),
                SplashPage(
                  color: Colors.white,
                  title: "Select the Group",
                  description: "Select from the list of groups\n that you custom created",
                  isLastPage: false,
                ),
                SplashPage(
                  color: Colors.white,
                  title: "Make the call",
                  description: "Once the Group is opened\n click the call button to contact\nthe person",
                  isLastPage: true,
                  onNext: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/NavigationBarPage', // Named route
                          (route) => false,     // This removes all previous routes
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (_currentPage < 2)
                GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    2,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
              if (_currentPage == 2) SizedBox(width: 50),
              // Text(
              //   'Skip',
              //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
              // ),
              SmoothPageIndicator(
                controller: _pageController, // Bind the page controller
                count: 3, // Number of pages
                effect: ExpandingDotsEffect(

                  dotHeight: 12,
                  dotWidth: 12,
                  spacing: 16,
                  dotColor: Colors.grey,
                  activeDotColor: Colors.blue,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_currentPage == 2) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/NavigationBarPage', // Named route
                          (route) => false,     // This removes all previous routes
                    );                    // Navigator.pushReplacementNamed(context, '/NavigationBarPage');
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: _currentPage == 2?Container(
                    width: width * 0.26,
                    height: width * 0.09,
                    
                    decoration: BoxDecoration(
                      // shape: BoxShape.rectangle
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(25)
                      
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Start', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
SizedBox(width: 10,),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    )

                ):CircleAvatar(
                    radius: width * 0.045,
                    backgroundColor: primaryColor,
                    child: Icon(Icons.arrow_forward,color: Colors.white,)
                )
              ),

            ],
          ),
          SizedBox(height: 30),
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
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) =>
              AlertDialog(
                title:  Text('Are you sure?',style: GoogleFonts.inter(color: primaryColor)),
                content:  Text('Do you really want to Exit?',style: GoogleFonts.inter()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No',style: GoogleFonts.inter(color: primaryColor)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child:  Text('Yes',style: GoogleFonts.inter(color: primaryColor),),
                  ),
                ],
              ),
        );
        return shouldPop ?? false;
      },
      child: Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: width*0.2),


            Container(
              child:title=='Select the Group'?
              Image.asset(ImageConstants.pageview2, height: width*0.7, width: width*0.7):
              Image.asset(ImageConstants.pageview1, height:width*0.7, width: width*0.7)
            ),
            SizedBox(height: width*0.02),

            title=='Click to open the app'?Text(
              'Quick Contact in the 3rd Touch',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: width*0.04, color: primaryColor,fontWeight: FontWeight.w600),
            ):Text(('')),
            SizedBox(height: width*0.08),

            Text(
              title,
              style: GoogleFonts.inter(fontSize: width*0.035, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            SizedBox(height: width*0.02),

            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: width*0.03, color: Colors.grey),
            ),

            if (isLastPage) ...[
              SizedBox(height: 30),
              // ElevatedButton(
              //   onPressed: onNext,
              //   child: Text("Get Started"),
              // ),
            ],
          ],
        ),
      ),
    );
  }
}
