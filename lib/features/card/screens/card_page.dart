import 'package:flutter/material.dart';
import 'package:qctt/features/Home/screens/splash_screen.dart';

import '../../../core/pallette/pallete.dart';

class CardPage extends StatefulWidget {
  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
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
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: width*1.2, // Adjust the height to take up a portion of the screen
                width: width*1.2,
                color: primaryColor, // Primary color of the app
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close, Copy, Share Icons in the upper row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            print("Close icon pressed");
                          },
                        ),
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
                    SizedBox(height: 20), // Add space between the icons and the card name

                    // Card Name
                    Text(
                      "Card Name", // Replace with dynamic card name if needed
                      style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20), // Add space between the card name and the icons below

                    // Left side icons (Call, Mail, Web) in a column
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.call, size: 30, color: Colors.green),
                          onPressed: () {
                            print("Call icon pressed");
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.mail, size: 30, color: Colors.blue),
                          onPressed: () {
                            print("Mail icon pressed");
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.language, size: 30, color: Colors.blueGrey),
                          onPressed: () {
                            print("Web icon pressed");
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 30), // Add space between the icons and the next row of icons

                    // Row with WhatsApp, Facebook, LinkedIn, and Twitter icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.chat_bubble, size: 30, color: Colors.green),
                          onPressed: () {
                            print("WhatsApp icon pressed");
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.facebook, size: 30, color: Colors.blue),
                          onPressed: () {
                            print("Facebook icon pressed");
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.message, size: 30, color: Colors.blueGrey),
                          onPressed: () {
                            print("LinkedIn icon pressed");
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.message, size: 30, color: Colors.blue),
                          onPressed: () {
                            print("Twitter icon pressed");
                          },
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: width*0.2,),

            // Button to add a card at the bottom
            ElevatedButton(
              onPressed: () {
                // Handle button press (e.g., navigate to add card screen)
                print("Add Card Button Pressed");
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Increase vertical padding to change height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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
