import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qctt/core/constants/images/images.dart';
import 'package:qctt/features/Home/screens/splash_screen.dart';

import '../../../core/pallette/pallete.dart';

class CardPage extends StatefulWidget {
  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  getCards(){
    FirebaseFirestore.instance.collection('cards').get();

  }
  void _showBottomSheet(BuildContext context,) {
     // Set the existing value before showing the sheet

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to take more space
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) {
        return Container(
          height: width*1.1,
          padding:  EdgeInsets.all(width*0.08),
          child: Column(


            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: width*0.1),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    child: Image.asset(ImageConstants.whatsapp, height: 40, color: Colors.black),

                  ),
                  SizedBox(width:  width*0.05),

                  Text('000000000',style: GoogleFonts.roboto(fontSize: 25),)
                ],
              ),
              SizedBox(height:  width*0.09),
              Row(
                children: [
                  SizedBox(
                    child: Image.asset(ImageConstants.facebook, height: 40,color: Colors.black, ),

                  ),
                  SizedBox(width:  width*0.05),

                  Text('000000000',style: GoogleFonts.roboto(fontSize: 25),)                ],
              ),
              SizedBox(height:  width*0.09),
              Row(
                children: [
                  SizedBox(
                    child: Image.asset(ImageConstants.linkedinIcon, height: 40, color: Colors.black),

                  ),
                  SizedBox(width:  width*0.05),

                  Text('000000000',style: GoogleFonts.roboto(fontSize: 25),)                ],
              ),
              SizedBox(height:  width*0.09),
              Row(
                children: [
                  SizedBox(
                    child: Image.asset(ImageConstants.twitter, height: 40, color: Colors.black),

                  ),
                  SizedBox(width:  width*0.05),

                  Text('000000000',style: GoogleFonts.roboto(fontSize: 25),)                ],
              ),


            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Card Page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            // Container with primary color occupying most of the screen
            Padding(
              padding:  EdgeInsets.only(left: 15.0,right: 15,top: 15),
              child: Container(
                height: width*1.1, // Adjust the height to take up a portion of the screen
                width: width*1.2,
                color: primaryColor, // Primary color of the app
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close, Copy, Share Icons in the upper row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(left: 18.0,top: 18),
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              print("Close icon pressed");
                            },
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(right: width*0.1,top: 18),
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
                        )

                      ],
                    ),
                    SizedBox(height: 20), // Add space between the icons and the card name

                    // Card Name
                    Center(
                      child: Text(
                        "Card Name", // Replace with dynamic card name if needed
                        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20), // Add space between the card name and the icons below

                    // Left side icons (Call, Mail, Web) in a column
                    Padding(
                      padding:  EdgeInsets.only(left: width*.15),
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
                    SizedBox(height: 30), // Add space between the icons and the next row of icons

                    // Row with WhatsApp, Facebook, LinkedIn, and Twitter icons
                    InkWell(
                      onTap: (){
                        _showBottomSheet(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Image.asset(ImageConstants.whatsapp, height: 35, color: Colors.white),

                          ),
                          SizedBox(width: width*0.02,),
                          IconButton(
                            icon: Icon(Icons.facebook, size: 40, color: Colors.white),
                            onPressed: () {
                              print("Facebook icon pressed");
                            },
                          ),
                          SizedBox(width: width*0.02,),
                          SizedBox(
                            child: Image.asset(ImageConstants.linkedin2, height: 30, color: Colors.white),

                          ),
                          SizedBox(width: width*0.04,),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Image.asset(ImageConstants.twitter, height: 20, color: primaryColor),

                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 15.0,right: 15,bottom: 15),
              child: Container(
                height: width*0.2, // Adjust the height to take up a portion of the screen
                width: width*1.2,
                color: Colors.white, // Primary color of the app
              ),
            ),
            SizedBox(height: width*0.1,),

            // Button to add a card at the bottom
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/AddCardDetailsPage')  ;              print("Add Card Button Pressed");
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Increase vertical padding to change height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ), // Set the text color to white
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
