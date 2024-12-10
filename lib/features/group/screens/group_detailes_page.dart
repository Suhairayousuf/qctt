import 'dart:async';

import 'package:QCTT/core/constants/firebase_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/images/images.dart';
import '../../../core/pallette/pallete.dart';
import '../../../main.dart';
import '../../../models/member_model.dart';
import '../../Home/screens/routing_page.dart';
import '../../Home/screens/splash_screen.dart';
import 'add_member_page.dart';



class GroupDetailesPage extends ConsumerStatefulWidget {

  @override
  ConsumerState<GroupDetailesPage> createState() => _GroupDetailesPageState();
}

class _GroupDetailesPageState extends ConsumerState<GroupDetailesPage> {
   String groupName="";
   String groupId="";
   List<MemberModel> members=[];

  // final List<Contacts> contacts = [
  //   Contacts(name: 'John Doe', number: '+9090909090'),
  //   Contacts(name: 'Jane Smith', number: '+945673889'),
  //   Contacts(name: 'Alex Johnson', number: '+9090909090'),
  //   Contacts(name: 'Lisa Brown', number: '+9090909090'),
  //   Contacts(name: 'John Doe', number: '+9090909090'),
  //   Contacts(name: 'Jane Smith', number: '+945673889'),
  //   Contacts(name: 'Alex Johnson', number: '+9090909090'),
  //   Contacts(name: 'Lisa Brown', number: '+9090909090'),
  //   Contacts(name: 'John Doe', number: '+9090909090'),
  //   Contacts(name: 'Jane Smith', number: '+945673889'),
  //   Contacts(name: 'Alex Johnson', number: '+9090909090'),
  //   Contacts(name: 'Lisa Brown', number: '+9090909090'),
  //
  //
  //
  // ];
  @override
void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    a?.cancel();
  }
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    groupName = arguments['groupName'];
    groupId = arguments['id'];

  }
   StreamSubscription? a;

   getMembers(){
     a=FirebaseFirestore.instance.collection('groups').doc(groupId).collection('members').snapshots().listen((value) {
       members=[];
       for (var doc in value.docs) {
         members.add(MemberModel.fromJson(doc.data()));
         members.sort((a, b) => b.memberName!.compareTo(a!.memberName!));


         // customerReward=doc.get('customerReward');
       }
       if(mounted){
         setState(() {

         });
       }
     });
   }

  // Stream<List<MemberModel>> getMembers(String groupId) {
  //   print(groupId);
  //   print(groupId);
  //   final membersCollection = FirebaseFirestore.instance
  //       .collection('groups')
  //       .doc(groupId)
  //       .collection('members');
  //   return membersCollection.snapshots().map((snapshot) {
  //     if (mounted) {
  //       // Only trigger setState if the widget is still in the widget tree.
  //       setState(() {
  //         print(membersCollection.doc());
  //       });
  //     }
  //     return snapshot.docs
  //         .map((doc) => MemberModel.fromJson(doc as Map<String, dynamic>))
  //         .toList();
  //   });
  //
  //   return membersCollection.snapshots().map((snapshot) =>
  //       snapshot.docs.map((doc) => MemberModel.fromJson(doc as Map<String, dynamic>  )).toList());
  // }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0, // Increase for more shadow
        shadowColor: Colors.grey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,size: width*0.05,),
          onPressed: () {
            Navigator.pop(context); // Goes back to the previous screen
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(groupName.toString(),style: GoogleFonts.inter(fontSize:  width*0.045),),
            Text(members.length.toString()+' Members',style: GoogleFonts.inter(fontSize:  width*0.03,color: Colors.grey),),
          ],
        ),
        actions: [
          Padding(
            padding:  EdgeInsets.only(right:  width*0.045,),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMemberPage(
                      type: true,
                      groupId: groupId,
                    ),
                  ),
                );
                // Navigator.pushNamed(context, '/AddMemberPage',);
                // Define the action when "Add Member" is tapped
                print("Add Member tapped!");
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal:  width*0.02, vertical:  width*0.02),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width:  width*0.01),
                    Text(
                      'Add Member',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],      ),
      body:

      Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MemberModel>>(
              stream: getMembers(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final contact = members[index];

                    return Dismissible(
                      key: Key(contact.memberId.toString()), // Unique key for each contact
                      direction: DismissDirection.endToStart, // Swipe right to left
                      background: Container(
                        color: Colors.red, // Background color while swiping
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: width * 0.05),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        // Delete the contact from Firebase and the list
                        FirebaseFirestore.instance.collection(FirebaseConstants.groups).
                        doc(groupId).collection(FirebaseConstants.members).doc(contact.memberId).delete();
                        // await deleteContactFromFirebase(contact.memberId); // Implement this function
                        setState(() {
                          members.removeAt(index); // Remove from the local list
                        });

                        // Optionally, show a snackbar to confirm the deletion
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${contact.memberName} deleted")),
                        );
                      },
                      child: InkWell(
                        onTap: () {
                          // Handle tap
                        },
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                          child: Column(
                            children: [
                              SizedBox(height: width * 0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.black,
                                    child: Icon(Icons.person, color: Colors.white, size: width * 0.08),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          contact.memberName.toString(),
                                          style: GoogleFonts.inter(
                                            color: Colors.black,
                                            fontSize: width * 0.036,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (contact.phone != null && contact.phone!.isNotEmpty)
                                          Text(
                                            contact.phone ?? "No Phone Number",
                                            style: GoogleFonts.inter(
                                              color: Colors.grey,
                                              fontSize: width * 0.032,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/UserSinglePage',
                                            arguments: {
                                              'name': contact.memberName,
                                              'phNumber': contact.phone,
                                            },
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: width * 0.05,
                                          backgroundColor: Colors.green.shade700,
                                          child: Icon(Icons.group_sharp, color: Colors.white, size: width * 0.08),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      InkWell(
                                        onTap: () async {
                                          String whatsappNumber = "+91" + (contact.phone.toString() ?? "");
                                          String url = "https://wa.me/$whatsappNumber";

                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            print('Could not launch $url');
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: CircleAvatar(
                                          radius: width * 0.05,
                                          backgroundColor: Colors.green.shade700,
                                          child: Image.asset(
                                            ImageConstants.whatsapp,
                                            color: Colors.white,
                                            height: width * 0.06,
                                            width: width * 0.06,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      InkWell(
                                        onTap: () async {
                                          String phoneNumber = "+91" + (contact.phone.toString() ?? "");
                                          final Uri url = Uri(scheme: 'tel', path: phoneNumber);

                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: CircleAvatar(
                                          radius: width * 0.05,
                                          backgroundColor: primaryColor,
                                          child: Icon(Icons.call, color: Colors.white, size: width * 0.06),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: width * 0.025),
                              Divider(color: Colors.grey.shade300),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      )


    );
        }
      // ),
    // );
  }
// }

class Contacts {
  final String name;
  final String number;

  Contacts({required this.name, required this.number});
}
