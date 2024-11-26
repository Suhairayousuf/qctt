import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qctt/core/pallette/pallete.dart';
import 'package:qctt/features/Home/screens/splash_screen.dart';

import '../../../core/utils/utils.dart';
import '../../Home/screens/navigation_page.dart';
class GroupSharePage extends StatefulWidget {
  const GroupSharePage({Key? key}) : super(key: key);

  @override
  State<GroupSharePage> createState() => _GroupSharePageState();
}

class _GroupSharePageState extends State<GroupSharePage> {
  final List<String> items = ['Home', 'Friends', 'Work', ];

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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding:  EdgeInsets.only(left: width*0.045,right: width*0.045),
            child: Text('Cards',style: GoogleFonts.inter(fontSize: width*0.045),),


          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0,left: 8.0),
              child: Text('version : 0.1',style: GoogleFonts.inter(fontSize: width*0.02),),
            )          ],
        ),
        body: Padding(
          padding:  EdgeInsets.all(width*0.05),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              mainAxisSpacing: width*0.02,
              crossAxisSpacing: width*0.03,
              childAspectRatio: width*0.0023, // Square containers
            ),
            itemCount: 3, // Number of items in the grid
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  // Navigator.pushNamed(context, '/GroupDetailesPage',
                  //   arguments: {
                  //     'id': items[index],
                  //     'members': index,
                  //   },);
                },
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                      borderRadius: BorderRadius.circular(12),

                    ),
                    child: Stack(
                      children: [
                        // Delete icon in the top-left corner

                        Positioned(
                          bottom: width*0.03,
                          left: width*0.04,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[index],
                                style: GoogleFonts.inter(
                                    fontSize:  width*0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                              Text(
                                '$index Members ',
                                style: GoogleFonts.inter(
                                    fontSize:  width*0.03,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Add icon in CircleAvatar at the bottom-right corner
                        Positioned(
                          bottom: width*0.03,
                          right: width*0.03,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(Icons.share, color: primaryColor),
                              onPressed: () async {
                                bool? confirmed = await ShareCardPopup.show(
                                  context: context,
                                  title: "Share",
                                  content: "Are you sure want to Share?",
                                  primaryColor:primaryColor, // Use app's primary color
                                );

                                if (confirmed == true) {
                                  // Perform the delete action
                                  setState(() {
                                    // items.removeAt(index); // Example: remove the item from the list
                                  });
                                }

                                // Handle add action
                              },
                            ),
                          ),
                        ),

                        // Text at the bottom-left corner
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

      ),
    );
  }}
