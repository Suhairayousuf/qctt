// //
// // import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
// // import 'package:flutter/material.dart';
// //
// // import 'home_widget.dart';
// // class FluidNavBarDemo extends StatefulWidget {
// //   @override
// //   State createState() {
// //     return _FluidNavBarDemoState();
// //   }
// // }
// //
// // class _FluidNavBarDemoState extends State {
// //   Widget? _child;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // Build a simple container that switches content based of off the selected navigation item
// //     return Scaffold(
// //       extendBody: true,
// //       body: _child,
// //       bottomNavigationBar: FluidNavBar(
// //         icons: [
// //           FluidNavBarIcon(
// //               svgPath: "assets/images/Vector.svg",
// //               backgroundColor: Color(0xFF4285F4),
// //               extras: {"label": "home"}),
// //           FluidNavBarIcon(
// //               icon: Icons.manage_accounts,
// //               backgroundColor: Color(0xFFEC4134),
// //               extras: {"label": "Manage"}),
// //
// //         ],
// //         onChange: _handleNavigationChange,
// //         style: FluidNavBarStyle(iconUnselectedForegroundColor: Colors.white),
// //         scaleFactor: 1.5,
// //         defaultIndex: 1,
// //         itemBuilder: (icon, item) => Semantics(
// //           label: icon.extras!["label"],
// //           child: item,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _handleNavigationChange(int index) {
// //     setState(() {
// //       switch (index) {
// //         case 0:
// //           _child = HomePage();
// //           break;
// //         case 1:
// //           _child = Container();
// //           break;
// //       }
// //       _child = AnimatedSwitcher(
// //         switchInCurve: Curves.easeOut,
// //         switchOutCurve: Curves.easeIn,
// //         duration: Duration(seconds: 1),
// //         child: _child,
// //       );
// //     });
// //   }
// // }
// import 'dart:async';
//
// import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
// import 'package:awesome_bottom_bar/chip_style.dart';
// import 'package:awesome_bottom_bar/tab_item.dart';
// import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
// import 'package:flutter/material.dart';
// import 'package:qctt/features/Home/screens/home_page.dart';
// import 'package:qctt/features/Home/screens/splash_screen.dart';
//
// import '../../../core/pallette/pallete.dart';
// import 'add_group_page.dart';
//
// Map shopMap={};
// class NavigationBarPage extends StatefulWidget {
//   const NavigationBarPage({Key? key}) : super(key: key);
//
//   @override
//   State<NavigationBarPage> createState() => _NavigationBarPageState();
// }
//
// class _NavigationBarPageState extends State<NavigationBarPage> {
//
//
//   // test(){
//   //   FirebaseFirestore.instance
//   //       .collection('shops')
//   //       .doc(currentshopId)
//   //       .snapshots().listen((event) {
//   //         print(event.data()!['status']);
//   //         if(event.data()!['status']==1){
//   //           showDialog(
//   //               context: context,
//   //               builder: (ctx) =>
//   //                   AlertDialog(
//   //             title: Text("Simple Alert"),
//   //             content: Text("This is an alert message."),
//   //             actions: [
//   //
//   //             ],
//   //           )
//   //           );
//   //         }
//   //         setState(() {
//   //
//   //         });
//   //   });
//   // }
//   @override
//   void dispose() {
//     super.dispose();
//   }
//   int visit = 0;
//
//
//
//   List<TabItem> items = [
//     TabItem(
//       icon: Icons.home,
//       title: 'Home',
//     ),
//     TabItem(
//       icon: Icons.call,
//       title: 'Call',
//     ),
//     TabItem(
//       icon: Icons.contacts_outlined,
//       title: 'Contact',
//     ),
//     TabItem(
//       icon: Icons.credit_card,
//       title: 'Card',
//     ),
//
//   ];
//
//   static const List<Widget> pages = <Widget>[
//     HomePage(),
//     QuickContactPage(),
//     HomePage(),
//     HomePage(),
//
//     // ProductManage(),
//
//   ];
//   set(){
//     setState(() {
//
//     });
//   }
//   @override
//   void initState() {
//
//
//
//
//     // TODO: implement initState
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     height=MediaQuery.of(context).size.height;
//     width=MediaQuery.of(context).size.width;
//     return
//     // shopList[0].position!.keys.isEmpty?
//     // Scaffold(
//     //   backgroundColor: Colors.white,
//     //   body: Center(
//     //     child: Container(
//     //       height: width * 0.7,
//     //       color: Colors.white,
//     //       child: AlertDialog(
//     //         title: Text(
//     //           'Enter Shop Location',
//     //           style: GoogleFonts.nunito(
//     //               color: Colors.blue.shade900, fontSize: 15),
//     //         ),
//     //         content: Column(
//     //           children: [
//     //             Container(
//     //               width: width*0.9,
//     //               height: textFormFieldHeight45,
//     //               // padding: EdgeInsets.symmetric(
//     //               //   horizontal: scrWidth * 0.015,
//     //               //   vertical:scrHeight*0.002,
//     //               // ),
//     //               decoration: BoxDecoration(
//     //                 border: Border.all(
//     //                   color: Color(0xffDADADA),
//     //                 ),
//     //                 color: textFormFieldFillColor,
//     //                 borderRadius: BorderRadius.circular(width * 0.026),
//     //               ),
//     //               child: Row(
//     //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//     //                 children: [
//     //                   Column(
//     //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     //                     children: [
//     //                       Text('Location: '+serviceLocation.toString(),style: GoogleFonts.outfit(),)
//     //                       // Text('Lattitude:'+latitude!.text),
//     //                       // Text('Longitude:'+longitude!.text),
//     //                     ],
//     //                   ),
//     //
//     //                   InkWell(
//     //                       onTap: ()  async {
//     //                         Position location = await Geolocator.getCurrentPosition(
//     //                             desiredAccuracy: LocationAccuracy.high
//     //                         );
//     //                         await   Navigator.push(
//     //                           context,
//     //                           MaterialPageRoute(
//     //                             builder: (context) =>
//     //                                 gMapPlacePicker.PlacePicker(
//     //                                   apiKey: "AIzaSyCUZFUZ1yMpkzh6QUnKj54Q2N4L2iT4tBY",
//     //                                   initialPosition: gMap.LatLng(
//     //                                       location.latitude,location.longitude
//     //                                   ),
//     //                                   // Put YOUR OWN KEY here.
//     //                                   searchForInitialValue: false,
//     //                                   selectInitialPosition: true,
//     //                                   // initialPosition: LatLng(currentLoc==null?0:currentLoc!.latitude,currentLoc==null?0:currentLoc!.longitude),
//     //                                   onPlacePicked: (res) async {
//     //                                     Navigator.of(context).pop();
//     //                                     // GeoCode geoCode = GeoCode();
//     //                                     // Address address=await geoCode.reverseGeocoding(latitude: res.geometry!.location.lat,longitude: res.geometry!.location.lng);
//     //                                     result=res;
//     //                                     latitude!.text=res.geometry!.location.lat.toString();
//     //                                     longitude!.text=res.geometry!.location.lng.toString();
//     //                                     List<Placemark> placemarks = await placemarkFromCoordinates(
//     //                                         res.geometry!.location.lat, res.geometry!.location.lng);
//     //                                     Placemark place = placemarks[0];
//     //                                     serviceLocation = place.locality!;
//     //                                     // longitude!.text=res.geometry!.location.lng.toString();
//     //                                     // lat=result.geometry!.location.lat;
//     //                                     // long=result.geometry!.location.lng;
//     //                                     set();
//     //                                   },
//     //                                   useCurrentLocation: true,
//     //                                 ),
//     //                           ),
//     //                         ).then((value) => setState((){}));
//     //                         set();
//     //                       },
//     //                       child: Icon(Icons.location_on,color: Colors.red,size: 30,)),
//     //
//     //                 ],
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //         actions: [
//     //           TextButton(
//     //               onPressed: () async {
//     //                 // _authentication.signOut(context);
//     //                 Navigator.pop(context);
//     //               },
//     //               child: Text(
//     //                 'Logout',
//     //                 style: GoogleFonts.outfit(
//     //                     color: Colors.black,
//     //                     fontSize: 15,
//     //                     fontWeight: FontWeight.bold),
//     //               )),
//     //           TextButton(
//     //               onPressed: () async {
//     //                 if(latitude!.text!=''&& longitude!.text!='' && serviceLocation!=''){
//     //                   GeoFirePoint myLocation = geo.point(latitude:double.tryParse(latitude!.text)??0, longitude: double.tryParse(longitude!.text)??0);
//     //
//     //                   await FirebaseFirestore.instance
//     //                       .collection('shops')
//     //                       .doc(currentshopId)
//     //                       .update({
//     //                     'position':myLocation.data,
//     //                   });
//     //
//     //                   setState((){
//     //
//     //                   });
//     //                   getShop();
//     //                   showUploadMessage(context, "Loaction added successfully", style: style);
//     //                 }
//     //
//     //
//     //
//     //               },
//     //               child: Text(
//     //                 'Ok',
//     //                 style: GoogleFonts.poppins(
//     //                     color: Colors.black,
//     //                     fontSize: 15,
//     //                     fontWeight: FontWeight.bold),
//     //               ))
//     //         ],
//     //       ),
//     //     ),
//     //   ),
//     // )
//     //     :
//     Scaffold(
//
//       body:Container(
//
//         child: pages.elementAt(visit),
//       ),
//       bottomNavigationBar:BottomBarInspiredOutside(
//         items: items,
//         backgroundColor: Color(0xfffef7ff),
//         color: primaryColor,
//         colorSelected: Colors.white,
//         indexSelected: visit,
//         onTap: (int index) => setState(() {
//           visit = index;
//         }),
//         top: -25,
//         animated: true,
//         itemStyle: ItemStyle.hexagon,
//         chipStyle:const ChipStyle(drawHexagon: true,background: primaryColor
//         ),
//       ),
//       // currentIndex: _selectedIndex,
//       // selectedItemColor: primaryColor,
//       // unselectedItemColor: Colors.black,
//       // onTap: _onItemTapped,
//       // body:Container(
//       //
//       //   child: _widgetOptions.elementAt(_selectedIndex),
//       // ),
//     );
//
//
//
//
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qctt/features/group/screens/add_group_page.dart';
import 'package:qctt/features/Home/screens/home_page.dart';
import 'package:qctt/features/Home/screens/recent_call_log_page.dart';
import 'package:qctt/features/Home/screens/splash_screen.dart';

import '../../../core/pallette/pallete.dart';
import '../../card/screens/card_page.dart';
import '../../group/screens/group_share_page.dart';
import 'contacts_page.dart';




class NavigationBarPage extends StatefulWidget {
   final int initialIndex; // Accept an initial index
  const NavigationBarPage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _NavigationBarPageState createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _selectedIndex = 0;
   // int _currentIndex=0;
  @override
  void initState() {
    super.initState();
    // _currentIndex = widget.initialIndex;
    _selectedIndex=widget.initialIndex;// Set the initial index
  }

  // List of widget options for each tab
  static  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CallLogPage(),


    ContactsPage(),
    CardPage(),
    // GroupSharePage()
    // QuickContactPage(),
    // QuickContactPage(),

  ];

  // Function to handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: primaryColor2,

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:  Colors.grey.withOpacity(0.2),
        // backgroundColor: primaryColor2,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Call',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Card',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade800,
        onTap: _onItemTapped,
      ),
    );
  }
}
