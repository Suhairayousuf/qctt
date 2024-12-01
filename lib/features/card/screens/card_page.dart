import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qctt/core/constants/images/images.dart';
import 'package:qctt/core/utils/utils.dart';
import 'package:qctt/features/Home/screens/splash_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/globals/functions.dart';
import '../../../core/pallette/pallete.dart';
import '../../../main.dart';
import '../../../models/card_model.dart';
import '../../Home/screens/navigation_page.dart';
import '../../Home/screens/routing_page.dart';

class CardPage extends StatefulWidget {
  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
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

  void _showBottomSheet(BuildContext context,String whatsapp,String facebook,String linkdn,String twitter) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: width * 0.1),
              Row(
                children: [
                  SizedBox(
                    child: Image.asset(ImageConstants.whatsapp, height: 40, color: Colors.black),
                  ),
                  SizedBox(width: width * 0.05),
                  InkWell(
                      onTap: () async {
                        String whatsappNumber = "+91"+whatsapp.toString();

                        //String whatsappNumber = "+91" + (contact.phone.toString() ?? "");
                        String url = "https://wa.me/$whatsapp";

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          print('Could not launch $url');
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(whatsapp, style: GoogleFonts.inter(fontSize: 25))),
                ],
              ),
              SizedBox(height: width * 0.09),
              Row(
                children: [
                  SizedBox(
                    child: Image.asset(ImageConstants.facebook, height: 40, color: Colors.black),
                  ),
                  SizedBox(width: width * 0.05),
                  InkWell(
                      onTap: (){
                        launchProfileURL(facebook.toString());

                      },
                      child: Text(facebook, style: GoogleFonts.inter(fontSize: 25))),
                ],
              ),
              SizedBox(height: width * 0.09),
              Row(
                children: [
                  SizedBox(
                    child: Image.asset(ImageConstants.linkedinIcon, height: 40, color: Colors.black),
                  ),
                  SizedBox(width: width * 0.05),
                  InkWell(
                      onTap: (){
                        launchProfileURL(linkdn.toString());
                      },
                      child: Text(linkdn, style: GoogleFonts.inter(fontSize: 25))),
                ],
              ),
              SizedBox(height: width * 0.09),
              Row(
                children: [
                  SizedBox(
                    child: Image.asset(ImageConstants.twitter, height: 40, color: Colors.black),
                  ),
                  SizedBox(width: width * 0.05),
                  InkWell(
                    onTap: (){
                      launchProfileURL(twitter.toString());

                    },
                      child: Text(twitter, style: GoogleFonts.inter(fontSize: 25))),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCards();
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
        appBar: AppBar(
          title: Text("Cards"),
          automaticallyImplyLeading: false,
          // centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              cardsList.isEmpty
                  ? Center(child: Container(
                  height: width * 1,
                  child:
              Center(child: Text('No cards '))))
                  :SizedBox(

                    height:width*1.5, // To ensure proper scrolling

                child: CardSwiper(
                    numberOfCardsDisplayed: cardsList.length < 3 ? cardsList.length : 3, // Adjust dynamically

                    cardsCount: cardsList.length,
                                    cardBuilder: (context, index, percentThresholdX, percentThresholdY){
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor, // Primary color of the app


                          ),
                           height: width * 1, // Adjust the height to take up a portion of the screen
                          width: width * 1.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: width * 0.04, top: width * 0.04),
                                    child: IconButton(
                                      icon: Icon(Icons.close, color: Colors.white),
                                      onPressed: () async {

                                          bool? confirmed = await DeletePopup.show(
                                            context: context,
                                             title: "Delete Card",
                                            content: "Are you sure you want to delete this Card?",
                                            primaryColor: primaryColor,
                                          );

                                          if (confirmed == true) {
                                            FirebaseFirestore.instance.collection('cards').
                                            doc(cardsList[index].cardId).delete();
                                            setState(() {
                                              cardsList.removeAt(index); // Remove the card from the local list
                                            });
                                            // Navigator.pop(context);

                                          }

                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: width * 0.1, top: width * 0.04),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.copy, color: Colors.white),
                                          onPressed: () {
                                            String messageToCopy = '''
                                                  Name: ${cardsList[index].name}, Contact: ${cardsList[index].phone} ,Website: ${cardsList[index].website}, Designation: ${cardsList[index].designation}, Email:${cardsList[index].email}, Twitter: ${cardsList[index].twitter}, Facebbok: ${cardsList[index].facebook}, Whatsapp: ${cardsList[index].whatsapp}, LinkedIn: ${cardsList[index].linkedin}
      
                                                  ''';
                                            Clipboard.setData(ClipboardData(text: messageToCopy));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Text copied')),
                                            );

                                            print("Copy icon pressed");
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.share, color: Colors.white),
                                          onPressed: () {
                                            Share.share('Name: ${cardsList[index].name}, Contact: ${cardsList[index].phone} ,Website: ${cardsList[index].website}, Designation: ${cardsList[index].designation}, Email:${cardsList[index].email}, Twitter: ${cardsList[index].twitter}, Facebbok: ${cardsList[index].facebook}, Whatsapp: ${cardsList[index].whatsapp}, LinkedIn: ${cardsList[index].linkedin}'
                                             );

                                            print("Share icon pressed");
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(height: ),
                              Center(
                                child: Text(
                                  cardsList[index].name, // Replace with dynamic card name if needed
                                  style: TextStyle(fontSize: width * 0.08, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: width * 0.03),
                              Padding(
                                padding: EdgeInsets.only(left: width * 0.15),
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.call, size: width * 0.06, color: Colors.white),
                                      onPressed: () {
                                        print("Call icon pressed");
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.mail, size: width * 0.06, color: Colors.white),
                                      onPressed: () {
                                        print("Mail icon pressed");
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.language, size: width * 0.06, color: Colors.white),
                                      onPressed: () {
                                        print("Web icon pressed");
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: width * 0.05),
                              InkWell(
                                onTap: () {
                                  _showBottomSheet(context,cardsList[index].whatsapp.toString(),cardsList[index].facebook.toString()
                                  ,cardsList[index].linkedin.toString(),cardsList[index].twitter.toString());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Image.asset(
                                        ImageConstants.whatsapp,
                                        height: width * 0.09,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: width * 0.01),
                                    IconButton(
                                      icon: Icon(Icons.facebook, size: width * 0.1, color: Colors.white),
                                      onPressed: () {
                                        print("Facebook icon pressed");
                                      },
                                    ),
                                    SizedBox(width: width * 0.01),
                                    SizedBox(
                                      child: Image.asset(
                                        ImageConstants.linkedin2,
                                        height: width * 0.08,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: width * 0.03),
                                    CircleAvatar(
                                      radius: width * 0.045,
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                        ImageConstants.twitter,
                                        height: width * 0.06,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: width * 0.2, // Adjust the height to take up a portion of the screen
                          width: width * 1.2,
                          color: Colors.white,
                        ),
                      ],
                    );
                                    }


                    ),
                  ),
              // SizedBox(height: width * 0.01),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/AddCardDetailsPage');
                  print("Add Card Button Pressed");
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: width * 0.01),
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
