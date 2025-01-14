// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:qctt/core/constants/images/images.dart';
// import 'package:qctt/core/utils/utils.dart';
// import 'package:qctt/features/Home/screens/splash_screen.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../core/globals/functions.dart';
// import '../../../core/pallette/pallete.dart';
// import '../../../main.dart';
// import '../../../models/card_model.dart';
// import '../../Home/screens/navigation_page.dart';
// import '../../Home/screens/routing_page.dart';
//
// class CardPage extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<CardPage> createState() => _CardPageState();
// }
//
// class _CardPageState extends ConsumerState<CardPage> {
//   List<CardModel> cardsList = [];
//
//   Future<void> getCards() async {
//
//
//     FirebaseFirestore.instance.collection('cards').snapshots().listen((snapshot) {
//       // Convert documents to a list of CardModel objects
//       List<CardModel> fetchedCards = snapshot.docs.map((doc) {
//         return CardModel.fromJson(doc.data() as Map<String, dynamic>);
//       }).toList();
//
//       setState(() {
//         cardsList = fetchedCards;
//       });
//     }, onError: (e) {
//       print('Error fetching cards: $e');
//     });
//   }
//
//   void _showBottomSheet(BuildContext context,String whatsapp,String facebook,String linkdn,String twitter) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
//       ),
//       builder: (context) {
//         return Container(
//           height: width * 1.1,
//           padding: EdgeInsets.all(width * 0.08),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: width * 0.1),
//                 Row(
//                   children: [
//                     SizedBox(
//                       child: Image.asset(ImageConstants.whatsapp, height: 40, color: Colors.black),
//                     ),
//                     SizedBox(width: width * 0.05),
//                     InkWell(
//                         onTap: () async {
//                           String whatsappNumber = "+91"+whatsapp.toString();
//
//                           //String whatsappNumber = "+91" + (contact.phone.toString() ?? "");
//                           String url = "https://wa.me/$whatsapp";
//
//                           if (await canLaunch(url)) {
//                             await launch(url);
//                           } else {
//                             print('Could not launch $url');
//                             throw 'Could not launch $url';
//                           }
//                         },
//                         child: Container(
//                             width: width*0.6,
//                             child: Text(whatsapp, style: GoogleFonts.inter(fontSize: 25)))),
//                   ],
//                 ),
//                 SizedBox(height: width * 0.09),
//                 Row(
//                   children: [
//                     SizedBox(
//                       child: Image.asset(ImageConstants.facebook, height: 40, color: Colors.black),
//                     ),
//                     SizedBox(width: width * 0.05),
//                     InkWell(
//                         onTap: (){
//                           if(facebook.toString().contains('https://facebook.com/')){
//                             launchProfileURL(facebook.toString());
//
//                           }else{
//                             launchProfileURL("https://facebook.com/${facebook.toString()}");
//
//                           }
//                           // launchProfileURL(facebook.toString());
//
//                         },
//                         child: Container(
//                             width: width*0.6,child: Text(facebook, style: GoogleFonts.inter(fontSize: 25)))),
//                   ],
//                 ),
//                 SizedBox(height: width * 0.09),
//                 Row(
//                   children: [
//                     SizedBox(
//                       child: Image.asset(ImageConstants.linkedinIcon, height: 40, color: Colors.black),
//                     ),
//                     SizedBox(width: width * 0.05),
//                     InkWell(
//                         onTap: (){
//                           if(facebook.toString().contains('https://linkedin.com/in/')){
//                             launchProfileURL(linkdn.toString());
//
//                           }else{
//                             launchProfileURL("https://linkedin.com/in/${linkdn.toString()}");
//
//                           }
//                           // launchProfileURL(linkdn.toString());
//                         },
//                         child: Container( width: width*0.6,
//                             child: Text(linkdn, style: GoogleFonts.inter(fontSize: 25)))),
//                   ],
//                 ),
//                 SizedBox(height: width * 0.09),
//                 Row(
//                   children: [
//                     SizedBox(
//                       child: Image.asset(ImageConstants.twitter, height: 40, color: Colors.black),
//                     ),
//                     SizedBox(width: width * 0.05),
//                     InkWell(
//                       onTap: (){
//
//                         if(facebook.toString().contains('https://twitter.com/')){
//                           launchProfileURL(twitter.toString());
//
//                         }else{
//                           launchProfileURL("https://twitter.com/${twitter.toString()}");
//
//                         }
//                         // launchProfileURL(twitter.toString());
//
//                       },
//                         child: Container(
//                             width: width*0.6,child: Text(twitter, style: GoogleFonts.inter(fontSize: 25)))),
//                   ],
//                 ),
//                 SizedBox(height: width * 0.05),
//
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getCards();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => NavigationBarPage(initialIndex: 0),
//           ),
//               (route) => false,
//         );
//         return false; // Returning false ensures the current page will not pop.
//       },
//       child: Scaffold(
//          backgroundColor: Colors.grey.withOpacity(0.05),
//         appBar:  AppBar(
//           // elevation: 0, // Increase for more shadow
//           shadowColor: Colors.grey,
//           backgroundColor: Colors.white,
//
//           automaticallyImplyLeading: false,
//           title: Text('Cards',style: GoogleFonts.inter(fontSize: width*0.05),),
//           // centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               cardsList.isEmpty
//                   ? Center(child: Container(
//                   height: width * 1,
//                   child:
//               Center(child: Text('No cards '))))
//                   :SizedBox(
//
//                     height:width*1.5, // To ensure proper scrolling
//
//                 child: CardSwiper(
//                     numberOfCardsDisplayed: cardsList.length < 3 ? cardsList.length : 3, // Adjust dynamically
//
//                     cardsCount: cardsList.length,
//                                     cardBuilder: (context, index, percentThresholdX, percentThresholdY){
//                     return Column(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             // color: primaryColor,
//                             image: DecorationImage(
//                               image: AssetImage('assets/images/bg.png'), // Path to your background image
//                               fit: BoxFit.fill, // Ensures the image covers the entire container
//                             ),// Primary color of the app
//
//
//                           ),
//                            height: width * 1.1, // Adjust the height to take up a portion of the screen
//                           width: width * 1.2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(left: width * 0.04, top: width * 0.04),
//                                     child: IconButton(
//                                       icon: Icon(Icons.close, color: Colors.white),
//                                       onPressed: () async {
//
//                                           bool? confirmed = await DeletePopup.show(
//                                             context: context,
//                                              title: "Delete Card",
//                                             content: "Are you sure you want to delete this Card?",
//                                             primaryColor: primaryColor,
//                                           );
//
//                                           if (confirmed == true) {
//                                             FirebaseFirestore.instance.collection('cards').
//                                             doc(cardsList[index].cardId).delete();
//                                             setState(() {
//                                               cardsList.removeAt(index); // Remove the card from the local list
//                                             });
//                                             // Navigator.pop(context);
//
//                                           }
//
//                                       },
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(right: width * 0.1, top: width * 0.04),
//                                     child: Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(Icons.copy, color: Colors.white),
//                                           onPressed: () {
//                                             String messageToCopy = '''
//                                                   Name: ${cardsList[index].name}, Contact: ${cardsList[index].phone} ,Website: ${cardsList[index].website}, Designation: ${cardsList[index].designation}, Email:${cardsList[index].email}, Twitter: ${cardsList[index].twitter}, Facebbok: ${cardsList[index].facebook}, Whatsapp: ${cardsList[index].whatsapp}, LinkedIn: ${cardsList[index].linkedin}
//
//                                                   ''';
//                                             Clipboard.setData(ClipboardData(text: messageToCopy));
//                                             ScaffoldMessenger.of(context).showSnackBar(
//                                               SnackBar(content: Text('Text copied')),
//                                             );
//
//                                             print("Copy icon pressed");
//                                           },
//                                         ),
//                                         IconButton(
//                                           icon: Icon(Icons.share, color: Colors.white),
//                                           onPressed: () {
//                                             Share.share('Name: ${cardsList[index].name}, Contact: ${cardsList[index].phone} ,Website: ${cardsList[index].website}, Designation: ${cardsList[index].designation}, Email:${cardsList[index].email}, Twitter: ${cardsList[index].twitter}, Facebbok: ${cardsList[index].facebook}, Whatsapp: ${cardsList[index].whatsapp}, LinkedIn: ${cardsList[index].linkedin}'
//                                              );
//
//                                             print("Share icon pressed");
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               // SizedBox(height: ),
//                               Center(
//                                 child: Flexible(
//                                   child: Container(
//                                     width: width*0.8,
//                                     child: Center(
//                                       child: Text(
//                                         cardsList[index].name, // Replace with dynamic card name if needed
//                                         style: GoogleFonts.inter(fontSize: width * 0.075, color: Colors.white, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: width * 0.03),
//                               Padding(
//                                 padding: EdgeInsets.only(left: width * 0.15),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//
//
//
//                                   children: [
//                                     Row(
//
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(Icons.call, size: width * 0.06, color: Colors.white),
//                                           onPressed: () {
//                                             print("Call icon pressed");
//                                           },
//                                         ),
//                                         Text(cardsList[index].phone,
//
//                                           style: GoogleFonts.inter(fontSize: width * 0.03,color: Colors.white),),
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(Icons.mail, size: width * 0.06, color: Colors.white),
//                                           onPressed: () {
//                                             print("Mail icon pressed");
//                                           },
//                                         ),
//                                         Text(cardsList[index].email,
//                                           style: GoogleFonts.inter(fontSize: width * 0.03,color: Colors.white),),
//
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(Icons.language, size: width * 0.06, color: Colors.white),
//                                           onPressed: () {
//                                             print("Web icon pressed");
//                                           },
//                                         ),
//                                         Flexible(
//                                           child: Container(
//                                             width:width*0.5,
//                                             child: Text(cardsList[index].website,
//
//                                               style: GoogleFonts.inter(fontSize: width * 0.03,color: Colors.white),),
//                                           ),
//                                         ),
//
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: width * 0.05),
//                               InkWell(
//                                 onTap: () {
//                                   _showBottomSheet(context,cardsList[index].whatsapp.toString(),cardsList[index].facebook.toString()
//                                   ,cardsList[index].linkedin.toString(),cardsList[index].twitter.toString());
//                                 },
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       child: Image.asset(
//                                         ImageConstants.whatsapp,
//                                         height: width * 0.09,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(width: width * 0.01),
//                                     IconButton(
//                                       icon: Icon(Icons.facebook, size: width * 0.1, color: Colors.white),
//                                       onPressed: () {
//                                         print("Facebook icon pressed");
//                                       },
//                                     ),
//                                     SizedBox(width: width * 0.01),
//                                     SizedBox(
//                                       child: Image.asset(
//                                         ImageConstants.linkedin2,
//                                         height: width * 0.08,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(width: width * 0.03),
//                                     CircleAvatar(
//                                       radius: width * 0.045,
//                                       backgroundColor: Colors.white,
//                                       child: Image.asset(
//                                         ImageConstants.twitter,
//                                         height: width * 0.06,
//                                         color: primaryColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           height: width * 0.2, // Adjust the height to take up a portion of the screen
//                           width: width * 1.2,
//                           color: Colors.white,
//                           child: Image.asset('assets/images/Created by QCTT.png'),
//                         ),
//                       ],
//                     );
//                                     }
//
//
//                     ),
//                   ),
//               // SizedBox(height: width * 0.01),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/AddCardDetailsPage');
//                   print("Add Card Button Pressed");
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                   padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: width * 0.01),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Text(
//                   "Add Card",
//                   style: TextStyle(fontSize: width * 0.04),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/images/images.dart';
import '../../../core/globals/functions.dart';
import '../../../core/pallette/pallete.dart';
import '../../../core/utils/utils.dart';
import '../../../main.dart';
import '../../../models/card_model.dart';
import '../../Home/screens/navigation_page.dart';
import '../../Home/screens/routing_page.dart';
import '../controller/card_controller.dart';

class CardPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<CardPage> createState() => _CardPageState();
}

class _CardPageState extends ConsumerState<CardPage> {
  final ScreenshotController screenshotController = ScreenshotController();

  List<CardModel> cardsList = [];

  Future<void> getCards() async {


    FirebaseFirestore.instance.collection('cards').snapshots().listen((snapshot) {
      // Convert documents to a list of CardModel objects
      List<CardModel> fetchedCards = snapshot.docs.map((doc) {
        return CardModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      setState(() {
        cardsList = fetchedCards;
      });
    }, onError: (e) {
      print('Error fetching cards: $e');
    });
  }

  void _showBottomSheet(BuildContext context,String web,String facebook,String linkdn,String instagram,String twitter,) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) {
        return Container(
          height: width * 1.1,
          padding: EdgeInsets.all(width * 0.08),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: width * 0.1),
                ///web
                Row(
                  children: [
                    SizedBox(
                      child: Image.asset(ImageConstants.globIcon, height: width*0.07, color: Colors.black),
                    ),
                    SizedBox(width: width * 0.05),
                    InkWell(
                        onTap: () async {
                          launchURL(web.toString());
                          // String whatsappNumber = "+91"+whatsapp.toString();
                          //
                          // //String whatsappNumber = "+91" + (contact.phone.toString() ?? "");
                          // String url = "https://wa.me/$whatsapp";
                          //
                          // if (await canLaunch(url)) {
                          //   await launch(url);
                          // } else {
                          //   print('Could not launch $url');
                          //   throw 'Could not launch $url';
                          // }
                        },
                        child: Container(
                            width: width*0.6,
                            child: Text(web, style: GoogleFonts.inter(fontSize: width*0.07)))),
                  ],
                ),
                SizedBox(height: width * 0.09),
                ///facebook urllauncher
                Row(
                  children: [
                    SizedBox(
                      child: Image.asset(ImageConstants.facebook, height: width*0.07, color: Colors.black),
                    ),
                    SizedBox(width: width * 0.05),
                    InkWell(
                        onTap: (){
                          if(facebook.toString().contains('https://facebook.com/')){
                            launchProfileURL(facebook.toString());

                          }else{
                            launchProfileURL("https://facebook.com/${facebook.toString()}");

                          }
                          // launchProfileURL(facebook.toString());

                        },
                        child: Container(
                            width: width*0.6,child: Text(facebook, style: GoogleFonts.inter(fontSize: width*0.07)))),
                  ],
                ),
                SizedBox(height: width * 0.09),
                ///linkedin urllauncher

                Row(
                  children: [
                    SizedBox(
                      child: Image.asset(ImageConstants.linkedinIcon, height: width*0.07, color: Colors.black),
                    ),
                    SizedBox(width: width * 0.05),
                    InkWell(
                        onTap: (){
                          if(linkdn.toString().contains('https://linkedin.com/in/')){
                            launchProfileURL(linkdn.toString());

                          }else{
                            launchProfileURL("https://linkedin.com/in/${linkdn.toString()}");

                          }
                          // launchProfileURL(linkdn.toString());
                        },
                        child: Container( width: width*0.6,
                            child: Text(linkdn, style: GoogleFonts.inter(fontSize: width*0.07)))),
                  ],
                ),
                SizedBox(height: width * 0.09),
                ///instagram launcher
                Row(
                  children: [
                    SizedBox(
                      child: Image.asset(ImageConstants.instaIcon, height: width*0.07, color: Colors.black),
                    ),
                    SizedBox(width: width * 0.05),
                    InkWell(
                        onTap: (){
                          if(instagram.contains('https://instagram.com/')){
                            launchProfileURL(instagram.toString());

                          }else{
                            launchProfileURL("https://instagram.com/${instagram.toString()}");

                          }
                          // if(facebook.toString().contains('https://linkedin.com/in/')){
                          //   launchProfileURL(linkdn.toString());
                          //
                          // }else{
                          //   launchProfileURL("https://linkedin.com/in/${linkdn.toString()}");
                          //
                          // }
                          // launchProfileURL(linkdn.toString());
                        },
                        child: Container( width: width*0.6,
                            child: Text(instagram
                                , style: GoogleFonts.inter(fontSize: width*0.07)))),
                  ],
                ),
                SizedBox(height: width * 0.09),
                ///twitter launcher
                Row(
                  children: [
                    SizedBox(
                      child: Image.asset(ImageConstants.twitter, height: width*0.07, color: Colors.black),
                    ),
                    SizedBox(width: width * 0.05),
                    InkWell(
                        onTap: (){

                          if(facebook.toString().contains('https://twitter.com/')){
                            launchProfileURL(twitter.toString());

                          }else{
                            launchProfileURL("https://twitter.com/${twitter.toString()}");

                          }
                          // launchProfileURL(twitter.toString());

                        },
                        child: Container(
                            width: width*0.6,child: Text(twitter, style: GoogleFonts.inter(fontSize: width*0.07)))),
                  ],
                ),
                SizedBox(height: width * 0.05),

              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // getCards();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationBarPage(initialIndex: 0),
          ),
              (route) => false,
        );
        return false; // Returning false ensures the current page will not pop.
      },
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.05),
        appBar:  AppBar(
          // elevation: 0, // Increase for more shadow
          shadowColor: Colors.grey,
          backgroundColor: Colors.white,

          automaticallyImplyLeading: false,
          title: Text('Cards',style: GoogleFonts.inter(fontSize: width*0.05),),
          actions: [
            Padding(
              padding:  EdgeInsets.only(right: width*0.03),
              child: Text('v:1.5',style: GoogleFonts.inter(fontSize: 10),),
            )
          ],
          // centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: width * 1.5,
                child: Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    final cardList = ref.watch(getCardProvider);

                    return cardList.when(
                      data: (data) {
                        // Check if the list is empty and return a message if it is
                        if (data.isEmpty) {
                          return Center(
                            child: Container(
                              height: width * 1,
                              child: Center(child: Text('No cards available')),
                            ),
                          );
                        }

                        // Ensure the number of cards displayed is at least 1, and no more than the total cards available
                        int numberOfCardsDisplayed =
                        data.length > 0 ? (data.length < 3 ? data.length : 3) : 1;

                        return SizedBox(
                          height: width * 1.5, // To ensure proper scrolling
                          child: CardSwiper(
                            numberOfCardsDisplayed: numberOfCardsDisplayed,
                            cardsCount: data.length,
                            cardBuilder:
                                (context, index, percentThresholdX, percentThresholdY) {
                              if (index >= data.length) {
                                return Center(child: Text('No cards available'));
                              }

                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/bg.png'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                     // height: width * 1.1,
                                    width: width * 1.2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width * 0.04,
                                                  top: width * 0.04),
                                              child: IconButton(
                                                icon: Icon(Icons.close,
                                                    color: Colors.white),
                                                onPressed: () async {
                                                  bool? confirmed =
                                                  await DeletePopup.show(
                                                    context: context,
                                                    title: "Delete Card",
                                                    content:
                                                    "Are you sure you want to delete this Card?",
                                                    primaryColor: primaryColor,
                                                  );

                                                  if (confirmed == true) {
                                                    FirebaseFirestore.instance
                                                        .collection('cards')
                                                        .doc(data[index].cardId)
                                                        .delete();
                                                    setState(() {
                                                      data.removeAt(index);
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: width * 0.1,
                                                  top: width * 0.04),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.copy,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      String messageToCopy = '''
                                  Name: ${data[index].name}\nContact: ${data[index].phone}\nDesignation: ${data[index].designation}\nWebsite: ${data[index].website}\nEmail: ${data[index].email}\nX: ${data[index].twitter}\nFacebook: ${data[index].facebook}\nWhatsapp: ${data[index].whatsapp}\nInstagram: ${data[index].instagram}
                                  ''';
                                                      Clipboard.setData(ClipboardData(
                                                          text: messageToCopy));
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Text copied')));
                                                    },
                                                  ),

                                                  IconButton(
                                                    icon: Icon(Icons.share, color: Colors.white),
                                                    onPressed: () async {
                                                      // Create a ScreenshotController
                                                      // final ScreenshotController screenshotController = ScreenshotController();

                                                      // Wrap ScreenshotWidget with Builder to ensure the correct context
                                                      final imageFile = await screenshotController.captureFromWidget(
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                image: AssetImage('assets/images/bg.png'),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                            // height: width * 1.1,
                                                             width: width ,
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              children: [
                                                                SizedBox(height: width * 0.1),

                                                                Center(
                                                                  child: Text(
                                                                    data[index].name,
                                                                    style: GoogleFonts.inter(
                                                                      fontSize: width * 0.09,
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(height: width * 0.02),

                                                                Center(
                                                                  child: Text(
                                                                    data[index].designation,
                                                                    style: GoogleFonts.inter(
                                                                      fontSize: width * 0.04,
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(height: width * 0.05),
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: width * 0.15),
                                                                  child: Column(
                                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          IconButton(
                                                                            icon: Icon(Icons.call, size: width * 0.06, color: Colors.white),
                                                                            onPressed: () {
                                                                              print("Call icon pressed");
                                                                            },
                                                                          ),
                                                                          Expanded(
                                                                            child: Text(data[index].phone,
                                                                                style: GoogleFonts.roboto(fontSize: width * 0.045, color: Colors.white)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left: 11.0),
                                                                            child: SizedBox(
                                                                              child: Image.asset(
                                                                                ImageConstants.whatsapp,
                                                                                height: width * 0.06,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(width: 13),
                                                                          Expanded(
                                                                            child: Text(data[index].whatsapp,
                                                                                style: GoogleFonts.inter(fontSize: width * 0.042, color: Colors.white)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          IconButton(
                                                                            icon: Icon(Icons.mail, size: width * 0.06, color: Colors.white),
                                                                            onPressed: () {
                                                                              print("Mail icon pressed");
                                                                            },
                                                                          ),
                                                                          Expanded(
                                                                            child: Text(data[index].email,
                                                                                style: GoogleFonts.inter(fontSize: width * 0.042, color: Colors.white)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(height: width * 0.05),
                                                                Row(
                                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Image.asset(
                                                                      ImageConstants.globIcon,
                                                                       height: width * 0.1,
                                                                      color: Colors.white,
                                                                      fit: BoxFit.fitHeight,
                                                                    ),
                                                                    SizedBox(width: width * 0.03),
                                                                    Image.asset(
                                                                      ImageConstants.facebook,
                                                                      height: width * 0.1,
                                                                      color: Colors.white,
                                                                      fit: BoxFit.fitHeight,
                                                                    ),
                                                                    SizedBox(width: width * 0.03),
                                                                    Image.asset(
                                                                      ImageConstants.linkedin2,
                                                                      height: width * 0.1,
                                                                      color: Colors.white,
                                                                      fit: BoxFit.fitHeight,
                                                                    ),
                                                                    SizedBox(width: width * 0.03),
                                                                    Image.asset(
                                                                      ImageConstants.instaIcon,
                                                                      height: width * 0.1,
                                                                      color: Colors.white,
                                                                      fit: BoxFit.fitHeight,
                                                                    ),
                                                                    SizedBox(width: width * 0.03),
                                                                    Container(
                                                                      height: width * 0.1,
                                                                      width: width * 0.1,
                                                                      decoration:BoxDecoration(
                                                                        color: Colors.white,
                                                                        shape: BoxShape.circle
                                                                      ) ,

                                                                      child: Image.asset(
                                                                        ImageConstants.twitter,
                                                                        height: width * 0.1,
                                                                        // color: Colors.white,
                                                                        fit: BoxFit.fitHeight,
                                                                        color: primaryColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: width * 0.1),
                                                                Container(
                                                                   height: width * 0.2,
                                                                  width: width ,
                                                                  color: Colors.white,
                                                                  child:
                                                                  Image.asset('assets/images/Created by QCTT.png'),
                                                                ),

                                                              ],
                                                            ),
                                                          )

                                                          // ScreenshotWidget(
                                                          //
                                                          //           data: data[index],
                                                          //         width:width// Pass the data here
                                                          //       ),
                                                        // Builder(
                                                        //   builder: (context) {
                                                        //     // Now the ScreenshotWidget has a proper BuildContext
                                                        //     return ScreenshotWidget(
                                                        //         screenshotController: screenshotController,
                                                        //
                                                        //         data: data[index],
                                                        //       width:width// Pass the data here
                                                        //     );
                                                        //   },
                                                        // ),
                                                      );

                                                      if (imageFile != null) {
                                                        // Save the image to a temporary directory
                                                        final tempDir = await getTemporaryDirectory();
                                                        final file = File('${tempDir.path}/screenshot.png');
                                                        await file.writeAsBytes(imageFile);

                                                        // Share the image file along with other text data
                                                        Share.shareXFiles(
                                                          [XFile(file.path)],
                                                          text:
                                                          'Name: ${data[index].name}\nContact: ${data[index].phone}\nDesignation: ${data[index].designation}\nWebsite: ${data[index].website}\nEmail: ${data[index].email}\nX: ${data[index].twitter}\nFacebook: ${data[index].facebook}\nWhatsapp: ${data[index].whatsapp}\nLinkedIn: ${data[index].linkedin}\nInstagram: ${data[index].instagram}',
                                                        );
                                                      }
                                                    },
                                                  ),


                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Center(
                                          child: Container(
                                            width: width * 0.8,
                                            child: Center(
                                              child: Text(
                                                data[index].name,
                                                style: GoogleFonts.inter(
                                                  fontSize: width * 0.08,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            width: width * 0.8,
                                            child: Center(
                                              child: Text(
                                                data[index].designation,
                                                style: GoogleFonts.inter(
                                                  fontSize: width * 0.038,
                                                  color: Colors.white,
                                                   fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: width * 0.03),
                                        Padding(
                                          padding: EdgeInsets.only(left: width * 0.15),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,


                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.call,
                                                        size: width * 0.06,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      print("Call icon pressed");
                                                    },
                                                  ),
                                                  Text(data[index].phone,
                                                      style: GoogleFonts.roboto(
                                                          fontSize: width * 0.045,
                                                          color: Colors.white)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 11.0),
                                                    child: SizedBox(
                                                      child: Image.asset(
                                                        ImageConstants.whatsapp,
                                                        height: width * 0.06,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 13,),
                                                  Flexible(
                                                    child: Container(
                                                      // width: width * 0.5,
                                                      child: Text(data[index].whatsapp,
                                                          style: GoogleFonts.inter(
                                                              fontSize: width * 0.042,
                                                              color: Colors.white)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.mail,
                                                        size: width * 0.06,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      print("Mail icon pressed");
                                                    },
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      // width: width * 0.5,
                                                      child: Text(data[index].email,
                                                          style: GoogleFonts.inter(
                                                              fontSize: width * 0.042,
                                                              color: Colors.white)),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                        SizedBox(height: width * 0.05),
                                        InkWell(
                                          onTap: () {
                                            _showBottomSheet(
                                              context,
                                              // data[index].whatsapp.toString(),
                                              data[index].website.toString(),
                                              data[index].facebook.toString(),
                                              data[index].linkedin.toString(),
                                              data[index].instagram.toString(),
                                              data[index].twitter.toString(),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Image.asset(
                                                ImageConstants.globIcon,
                                                height: width * 0.08,
                                                color: Colors.white,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              SizedBox(width: width * 0.03),
                                              Image.asset(
                                                ImageConstants.facebook,
                                                height: width * 0.08,
                                                color: Colors.white,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              SizedBox(width: width * 0.03),
                                              Image.asset(
                                                ImageConstants.linkedin2,
                                                height: width * 0.08,
                                                color: Colors.white,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              SizedBox(width: width * 0.03),
                                              Image.asset(
                                                ImageConstants.instaIcon,
                                                height: width * 0.08,
                                                color: Colors.white,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              SizedBox(width: width * 0.03),
                                              Container(
                                                height: width * 0.08,
                                                width: width * 0.1,
                                                decoration:BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle
                                                ) ,

                                                child: Image.asset(
                                                  ImageConstants.twitter,
                                                  height: width * 0.1,
                                                  // color: Colors.white,
                                                  fit: BoxFit.fitHeight,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: width * 0.2),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: width * 0.2,
                                    width: width * 1.2,
                                    color: Colors.white,
                                    child:
                                    Image.asset('assets/images/Created by QCTT.png'),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        return Text(error.toString());
                      },
                      loading: () {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/AddCardDetailsPage');
                  print("Add Card Button Pressed");
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: width * 0.01),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Add Card",
                  style: TextStyle(fontSize: width * 0.04),
                ),
              )
            ],
          ),
        ),

      ),
    );
  }
}






