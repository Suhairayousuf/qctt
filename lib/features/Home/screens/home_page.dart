import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:upgrader/upgrader.dart';

import '../../../core/pallette/pallete.dart';
import '../../../core/utils/utils.dart';
import '../../../main.dart';
import '../../../models/member_model.dart';
import '../../group/controller/group_controller.dart';
import '../../group/screens/add_group_page.dart';
import '../../group/screens/add_member_page.dart';
import '../../group/screens/edit_group_page.dart';
import 'navigation_page.dart';
class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // final List<String> items = ['Home', 'Friends', 'Work', ];

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

      child: UpgradeAlert(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar:
          AppBar(
              elevation: 0.5, // Increase for more shadow
            shadowColor: Colors.white,
            backgroundColor: Colors.white,// Increase for more shadow
             // shadowColor: Colors.grey,          automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Quick Contact',style: GoogleFonts.inter(fontSize: width*0.05),),
            ),
          ),
          body: Padding(
            padding:  EdgeInsets.all(width*0.05),
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final groupList = ref.watch(getGroupProvider);

                return groupList.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Center(
                        child: Text("No groups found"),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              mainAxisSpacing: width * 0.02,
                              crossAxisSpacing: width * 0.03,
                              childAspectRatio: width * 0.0023, // Container aspect ratio
                            ),
                            itemCount: data.length, // Number of items in the grid
                            itemBuilder: (context, index) {
                              final group = data[index];

                              // Use StreamBuilder to dynamically get the count of documents
                              final memberListStream = FirebaseFirestore.instance
                                  .collection('groups')
                                  .doc(group.groupId)
                                  .collection('members')
                                  .snapshots()
                                  .map((snapshot) => snapshot.docs
                                  .map((doc) => MemberModel.fromJson(doc.data()))
                                  .toList());




                              return  StreamBuilder<List<MemberModel>>(
                                stream: memberListStream,
                                builder: (context, snapshot) {
                                  final memberList = snapshot.data ?? [];
                                  final memberCount = memberList.length;

                                  return InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/GroupDetailesPage',
                                        arguments: {
                                          'id': group.groupId,
                                          'groupName': group.groupName,
                                        },
                                      );
                                    },
                                    child: Card(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: group.image != null && group.image!.isNotEmpty
                                              ? DecorationImage(
                                            image: CachedNetworkImageProvider(group.image.toString()),
                                            fit: BoxFit.cover,
                                          )
                                              : null, // If no image, set the image decoration to null
                                          color: group.color.isEmpty
                                              ? Colors.blueGrey
                                              : Color(int.parse("0x" + group.color.replaceAll("#", ""))),
                                          borderRadius: BorderRadius.circular(12),
                                        ),

                                        child: Stack(
                                          children: [
                                            // Delete icon in the top-left corner
                                            Positioned(
                                              top: width * 0.02,
                                              child: IconButton(
                                                icon: Icon(Icons.delete, color: Colors.white),
                                                onPressed: () async {
                                                  bool? confirmed = await DeletePopup.show(
                                                    context: context,
                                                    title: "Delete Group",
                                                    content: "Are you sure you want to delete this group?",
                                                    primaryColor: primaryColor,
                                                  );

                                                  if (confirmed == true) {
                                                    // Perform delete action
                                                    FirebaseFirestore.instance
                                                        .collection('groups')
                                                        .doc(group.groupId)
                                                        .delete();
                                                  }
                                                },
                                              ),
                                            ),
                                            // Edit icon in the top-right corner
                                            Positioned(
                                              top: width * 0.02,
                                              right: width * 0.02,
                                              child: IconButton(
                                                icon: Icon(Icons.edit, color: Colors.white),
                                                onPressed: () async {
                                                  // bool? confirmed = await EditPopup.show(
                                                  //   context: context,
                                                  //   title: "Edit Card",
                                                  //   content: "Are you sure you want to Edit this Card?",
                                                  //   primaryColor: primaryColor,
                                                  // );

                                                  // if (confirmed == true) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => EditGroupPage(
                                                          groupId: group.groupId,
                                                          groupName: group.groupName,
                                                          image: group.image,
                                                          color: group.color,
                                                          memberList: memberList, // Pass the member list here
                                                        ),
                                                      ),
                                                    );
                                                  // }
                                                },
                                              ),
                                            ),
                                            // Text at the bottom-left corner
                                            Positioned(
                                              bottom: width * 0.03,
                                              left: width * 0.04,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    group.groupName,
                                                    style: GoogleFonts.inter(
                                                        fontSize: width * 0.04,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    '$memberCount Members',
                                                    style: GoogleFonts.inter(
                                                        fontSize: width * 0.03, color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Add member button at the bottom-right corner
                                            Positioned(
                                              bottom: width * 0.03,
                                              right: width * 0.03,
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.white,
                                                child: IconButton(
                                                  icon: Icon(Icons.add, color: primaryColor),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => AddMemberPage(
                                                          type: true,
                                                          groupId: group.groupId,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
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
                        SizedBox(height: width * 0.1),
                      ],
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding:  EdgeInsets.all( width*0.04),
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),

              backgroundColor: Colors.white,
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddGroupPage(), // Pass the index
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => NavigationBarPage(initialIndex: 0), // Pass the index
                //   ),
                // );
                // Handle the button press
              },
              label: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor,
                      radius:20,
                      child: Icon(Icons.add,color: Colors.white,)),
                  SizedBox(width:  width*0.03),
                  Text("Add New Card",style: GoogleFonts.inter(fontSize:  width*0.04),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }}
