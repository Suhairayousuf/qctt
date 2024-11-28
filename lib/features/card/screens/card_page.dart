import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qctt/core/constants/images/images.dart';
import 'package:qctt/features/Home/screens/splash_screen.dart';

import '../../../core/pallette/pallete.dart';
import '../../../models/card_model.dart';

class CardPage extends StatefulWidget {
  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  List<CardModel> cardsList = [];

  Future<void> getCards() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('cards').get();

      // Convert documents to a list of CardModel objects
      List<CardModel> fetchedCards = snapshot.docs.map((doc) {
        return CardModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      setState(() {
        cardsList = fetchedCards;
      });
    } catch (e) {
      print('Error fetching cards: $e');
    }
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
                  Text(whatsapp, style: GoogleFonts.roboto(fontSize: 25)),
                ],
              ),
              SizedBox(height: width * 0.09),
              Row(
                children: [
                  SizedBox(
                    child: Image.asset(ImageConstants.facebook, height: 40, color: Colors.black),
                  ),
                  SizedBox(width: width * 0.05),
                  Text(facebook, style: GoogleFonts.roboto(fontSize: 25)),
                ],
              ),
              SizedBox(height: width * 0.09),
              Row(
                children: [
                  SizedBox(
                    child: Image.asset(ImageConstants.linkedinIcon, height: 40, color: Colors.black),
                  ),
                  SizedBox(width: width * 0.05),
                  Text(linkdn, style: GoogleFonts.roboto(fontSize: 25)),
                ],
              ),
              SizedBox(height: width * 0.09),
              Row(
                children: [
                  SizedBox(
                    child: Image.asset(ImageConstants.twitter, height: 40, color: Colors.black),
                  ),
                  SizedBox(width: width * 0.05),
                  Text(twitter, style: GoogleFonts.roboto(fontSize: 25)),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Cards"),
        automaticallyImplyLeading: false,
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            cardsList.isEmpty
                ? Center(child: CircularProgressIndicator())
                :SizedBox(

                  height:width*1.5, // To ensure proper scrolling

              child: CardSwiper(
                                  cardsCount: cardsList.length,
                                  cardBuilder: (context, index, percentThresholdX, percentThresholdY){
                  return Column(
                    children: [
                      Container(
                         height: width * 1, // Adjust the height to take up a portion of the screen
                        width: width * 1.2,
                        color: primaryColor, // Primary color of the app
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 18.0, top: 18),
                                  child: IconButton(
                                    icon: Icon(Icons.close, color: Colors.white),
                                    onPressed: () {
                                      print("Close icon pressed");
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width * 0.1, top: 18),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.copy, color: Colors.white),
                                        onPressed: () {
                                          print("Copy icon pressed");
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.share, color: Colors.white),
                                        onPressed: () {
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
                                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.15),
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.call, size: 30, color: Colors.white),
                                    onPressed: () {
                                      print("Call icon pressed");
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.mail, size: 30, color: Colors.white),
                                    onPressed: () {
                                      print("Mail icon pressed");
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.language, size: 30, color: Colors.white),
                                    onPressed: () {
                                      print("Web icon pressed");
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
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
                                      height: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  IconButton(
                                    icon: Icon(Icons.facebook, size: 40, color: Colors.white),
                                    onPressed: () {
                                      print("Facebook icon pressed");
                                    },
                                  ),
                                  SizedBox(width: width * 0.02),
                                  SizedBox(
                                    child: Image.asset(
                                      ImageConstants.linkedin2,
                                      height: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.04),
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                      ImageConstants.twitter,
                                      height: 20,
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
                        height: width * 0.225, // Adjust the height to take up a portion of the screen
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Add Card",
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
