import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qctt/features/Home/screens/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/images/images.dart';
import '../../../core/pallette/pallete.dart';

class CallLogPage extends StatefulWidget {
  @override
  _CallLogPageState createState() => _CallLogPageState();
}

class _CallLogPageState extends State<CallLogPage> {
  List<CallLogEntry> _callLogs = [];

  @override
  void initState() {
    super.initState();
    _fetchCallLogs();
  }

  Future<void> _fetchCallLogs() async {
    // Request permissions
    if (await Permission.phone.isGranted || await Permission.phone.request().isGranted) {
      if (await Permission.contacts.isGranted || await Permission.contacts.request().isGranted) {
        Iterable<CallLogEntry> callLogs = await CallLog.get();
        setState(() {
          _callLogs = callLogs.toList();
        });
      } else {
        print("Contacts permission not granted.");
      }
    } else {
      print("Phone permission not granted.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
          title: Text('Recent Call Log',style: GoogleFonts.inter(),)),
      body: _callLogs.isEmpty
          ? Center(child: CircularProgressIndicator())
          :ListView.builder(
        itemCount: _callLogs.length,
        itemBuilder: (context, index) {
          final contact = _callLogs[index];
          return InkWell(
            onTap: (){

              // Navigator.pushNamed(context, '/UserSinglePage',
              //   arguments: {
              //     // 'name': _contacts[index].name,
              //     // 'members': index,
              //   },
              // );
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12), // Adjust padding as needed

              child: Column(
                children: [
                  // SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out widgets
                    crossAxisAlignment: CrossAxisAlignment.center, // Align items in the center vertically
                    children: [
                      // Leading widget
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.person, color: Colors.white, size: width * 0.08),
                      ),
                      SizedBox(width: 16), // Space between leading and title

                      // Title and Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                          children: [
                            contact.name!= null  && contact.name!=" "?
                            Text(contact.name.toString(),style: GoogleFonts.roboto(color: Colors.black,fontSize:  width*0.036,fontWeight: FontWeight.w500),):Text(" "),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                contact.number != null && contact.number!.isNotEmpty?
                                Text(contact.number?? "No Phone Number", style: GoogleFonts.inter(color: Colors.grey, fontSize: width * 0.032),):Text(" ")
                                ,                  Text( DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(contact.timestamp!),),style: GoogleFonts.inter(color: Colors.grey, fontSize: width * 0.025) ,)
                              ],
                            ) ,

                          ],
                        ),
                      ),

                      // Trailing Actions
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(
                                context,
                                '/UserSinglePage',
                                arguments: {
                                  // 'groupId':groupId,
                                  // 'memberid': contact.memberId,
                                  'name': contact.name,
                                  'phNumber':contact.number.toString()

                                },
                              );
                            },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.green.shade700,
                              child: Icon(Icons.group_sharp, color: Colors.white, size: width * 0.08),
                            ),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () async {
                              String whatsappNumber = "+91" + (contact.number.toString() ?? "");
                              String url = "https://wa.me/$whatsappNumber";

                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                print('Could not launch $url');
                                throw 'Could not launch $url';
                              }
                            },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.green.shade700,
                              child: Image.asset(
                                ImageConstants.whatsapp,
                                color: Colors.white,
                                height: width * 0.06,
                                width: width * 0.06,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () async {
                              String phoneNumber = "+91" + (contact.number.toString() ?? "");
                              final Uri url = Uri(scheme: 'tel', path: phoneNumber);

                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: primaryColor,
                              child: Icon(Icons.call, color: Colors.white, size: width * 0.06),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
         //          ListTile(
         //
         //            leading: InkWell(
         //
         //              child: CircleAvatar(
         //                backgroundColor: Colors.black,
         //                child: Icon(Icons.person, color: Colors.white),
         //              ),
         //            ),
         //            title: InkWell(
         //                child:contact.name!= null  && contact.name!=" "?
         //                Text(contact.name.toString(),style: GoogleFonts.inter(color: Colors.black,fontSize:  width*0.035),):Text(" ")
         //            ),
         //            subtitle:
         //             Column(
         //               crossAxisAlignment: CrossAxisAlignment.start,
         //                  children: [
         //                    contact.number != null && contact.number!.isNotEmpty?
         //                    Text(contact.number?? "No Phone Number", style: GoogleFonts.inter(color: Colors.grey, fontSize: width * 0.025),):Text(" ")
         // ,                  Text( DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(contact.timestamp!),),style: GoogleFonts.inter(color: Colors.grey, fontSize: width * 0.025) ,)
         //                  ],
         //                ) ,
         //            trailing: Row(
         //            mainAxisSize: MainAxisSize.min,
         //            children: [
         //              CircleAvatar(
         //                backgroundColor: Colors.green.shade900,
         //                child: Icon(Icons.group, color: primaryColor,size: 30,),
         //              ),
         //              SizedBox(width: 10),
         //              InkWell(
         //                onTap: () async {
         //                  String whatsappNumber = "+91"+contact.number.toString()??"";
         //
         //                  String url = "https://wa.me/$whatsappNumber";
         //
         //
         //                  if (await canLaunch(url)) {
         //                    await launch(url);
         //                  } else {
         //                    print('Could not launch $url');
         //                    throw 'Could not launch $url';
         //                  }
         //                },
         //                child: CircleAvatar(
         //                  backgroundColor: Colors.green.shade900,
         //                  child: Image.asset(ImageConstants.whatsapp, color:primaryColor,height: 25,width: 25,),
         //                ),
         //              ),
         //              SizedBox(width: 10),
         //              InkWell(
         //                onTap: () async {
         //                  String phoneNumber = "+91"+contact.number.toString()??"";  // Enter your desired phone number here
         //                  final Uri url = Uri(scheme: 'tel', path: phoneNumber);
         //
         //                  if (await canLaunchUrl(url)) {
         //                    await launchUrl(url);
         //                  } else {
         //                    throw 'Could not launch $url';
         //                  }
         //                },
         //                child: CircleAvatar(
         //                  backgroundColor: primaryColor,
         //                  child: Icon(Icons.call, color: Colors.white),
         //                ),
         //              ),
         //            ],
         //          ),
         //          ),
         //      SizedBox(height: 8), // Space between items
              Divider(color: Colors.grey.shade300),
                  // )
                ],
              ),
            ),
          );
        },
      ),





      // ListView.builder(
      //   itemCount: _callLogs.length,
      //   itemBuilder: (context, index) {
      //     final entry = _callLogs[index];
      //     return ListTile(
      //       // title: Text(entry.name ?? entry.number ?? "Unknown"),
      //       title: Text(entry.name ?? ""),
      //       // subtitle: Text(
      //       //   "Call Type: ${entry.callType}\nDuration: ${entry.duration}s\nTime: ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}",
      //       // ),
      //       subtitle: Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             entry.number.toString(),
      //           ),
      //           Text( DateFormat('dd MMM yyyy, hh:mm a').format(
      //         DateTime.fromMillisecondsSinceEpoch(entry.timestamp!),))
      //
      //         ],
      //       ),
      //       isThreeLine: true,
      //     );
      //   },
      // ),
    );
  }
}
