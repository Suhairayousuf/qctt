import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


import '../../../core/constants/firebase_constants.dart';
import '../../../core/pallette/pallete.dart';
import '../../../core/utils/utils.dart';
import '../../../main.dart';
import '../../../models/group_model.dart';
import '../../../models/member_model.dart';
import '../../Home/screens/navigation_page.dart';
import '../../Home/screens/routing_page.dart';
import '../controller/group_controller.dart';
import 'add_member_page.dart';
import 'addmember_from_group.dart';

class EditGroupPage extends ConsumerStatefulWidget {
  final String groupId;
  final String groupName;
  final String image;
  final String color;
  final List<MemberModel> memberList;
  const EditGroupPage( {Key? key, required this.groupId, required this.  groupName,
    required this. image, required this.  color, required this. memberList}) : super(key: key);

  @override
  ConsumerState<EditGroupPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends ConsumerState<EditGroupPage> {
  String? _groupImagePath;
  File? _image;
  String? _imageName;
  String hexColor = '';
  String downloadUrl="";
  List addedMembers=[];
  List<MemberModel> memberList=[];
  String updatedDownloadUrl="";
  bool _isUploading = false;
  bool _isImageChanged = false;
  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            'Select the image source',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: width*0.05,
              fontWeight: FontWeight.w500,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickGroupImage(ImageSource.camera,context);// Return false
              },
              child: Text(
                "Camera",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickGroupImage(ImageSource.gallery,context);// Return true
              },
              child: Text(
                "Gallery",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
  // Future<void> _pickGroupImage(ImageSource source) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: source);
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       _groupImagePath = pickedFile.path;
  //       _image = File(pickedFile.path);
  //       _imageName = basename(pickedFile.path);
  //     });
  //
  //     try {
  //       // Upload image to Firebase Storage
  //       String fileName = "group_images/$_imageName";
  //       Reference storageRef = FirebaseStorage.instance.ref(fileName);
  //
  //       await storageRef.putFile(_image!);
  //
  //       // Get the download URL
  //       downloadUrl = await storageRef.getDownloadURL();
  //       setState(() {
  //
  //       });
  //
  //       // Save the download URL to Firestore (if needed)
  //       // await FirebaseFirestore.instance.collection('groups').add({
  //       //   'imageUrl': downloadUrl,
  //       //   'createdAt': FieldValue.serverTimestamp(),
  //       // });
  //
  //       print('Image uploaded and URL saved: $downloadUrl');
  //     } catch (e) {
  //       print('Failed to upload image: $e');
  //     }
  //   }
  // }
  // Future<void> _pickGroupImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       _groupImagePath = pickedFile.path;
  //       _image = File(pickedFile.path);
  //       _imageName = basename(pickedFile.path);
  //     });
  //
  //     try {
  //       // Upload image to Firebase Storage
  //       String fileName = "group_images/$_imageName";
  //       Reference storageRef = FirebaseStorage.instance.ref(fileName);
  //
  //       await storageRef.putFile(_image!);
  //
  //       // Get the download URL
  //       downloadUrl = await storageRef.getDownloadURL();
  //
  //       // Save the download URL to Firestore
  //       // await FirebaseFirestore.instance.collection('groups').add({
  //       //   'imageUrl': downloadUrl,
  //       //   'createdAt': FieldValue.serverTimestamp(),
  //       // });
  //
  //       print('Image uploaded and URL saved: $downloadUrl');
  //     } catch (e) {
  //       print('Failed to upload image: $e');
  //     }
  //   }
  // }
  Future<void> _pickGroupImage(ImageSource source, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _groupImagePath = pickedFile.path;
        _image = File(pickedFile.path);
        _imageName = basename(pickedFile.path);
        _isImageChanged = true;
      });

      try {
        // Show a loading indicator or placeholder while the image is uploading
        setState(() {
          _isUploading = true;  // Add this state to show uploading status
        });

        // Upload image to Firebase Storage
        String fileName = "group_images/$_imageName";
        Reference storageRef = FirebaseStorage.instance.ref(fileName);

        // Upload the file to Firebase Storage
        TaskSnapshot uploadTask = await storageRef.putFile(_image!);

        // Get the download URL after upload completes
        String updatedDownloadUrl = await uploadTask.ref.getDownloadURL();

        setState(() {
          downloadUrl = updatedDownloadUrl; // Update the URL in state
          _isUploading = false;  // Set uploading to false once the upload is complete
        });

        print('Image uploaded and URL saved: $downloadUrl');
      } catch (e) {
        print('Failed to upload image: $e');
        showSnackBar(context, 'Failed to upload image. Please try again.');
        setState(() {
          _isUploading = false;  // Ensure uploading state is reset in case of an error
        });
      }
    } else {
      print('No image selected');
      showSnackBar(context, 'No image selected.');
    }
  }

  // Future<void> _handleUpdateButtonClick(BuildContext context) async {
  //   if (_isUploading) return;  // Prevent clicks if uploading is in progress
  //
  //   setState(() {
  //     _isUploading = true;
  //   });
  //
  //   // If the image has been changed, upload the new image
  //   if (_isImageChanged) {
  //     try {
  //       String fileName = "group_images/$_imageName";
  //       Reference storageRef = FirebaseStorage.instance.ref(fileName);
  //
  //       // Upload the file to Firebase Storage
  //       TaskSnapshot uploadTask = await storageRef.putFile(_image!);
  //
  //       String updatedDownloadUrl = await uploadTask.ref.getDownloadURL();
  //
  //       setState(() {
  //         downloadUrl = updatedDownloadUrl;  // Update the download URL if image is uploaded
  //         _isImageChanged = false;  // Reset the image change flag
  //       });
  //
  //       print('Image uploaded and URL saved: $downloadUrl');
  //     } catch (e) {
  //       print('Failed to upload image: $e');
  //       showSnackBar(context, 'Failed to upload image. Please try again.');
  //     }
  //   } else {
  //     // If the image has not changed, skip the upload process
  //     print('No new image selected. Skipping upload.');
  //     setState(() {
  //       _isUploading = false;  // Finish the process even if no upload happened
  //     });
  //   }
  // }

  final cardTitle = TextEditingController();
  Color selectedColor = Colors.blueGrey;
  UpdateGroup(BuildContext context, GroupModel groupData, List<MemberModel> memberList){
    ref.read(groupControllerProvider.notifier).updateGroup(context: context,groupModel: groupData,members:memberList);



  }
  @override
  void initState() {
    cardTitle.text = widget.groupName; // Set group name
    selectedColor = widget.color=="" ?Colors.blueGrey:Color(int.parse("0x" + widget.color.replaceAll("#", ""))); // Set color
    downloadUrl = widget.image; // Set image URL
    memberList = widget.memberList; // Set image URL
    hexColor = '#${selectedColor.value.toRadixString(16).padLeft(8, '0')}';
     // Prepopulate members

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return
      // WillPopScope(
      // onWillPop: () async {
      //   final shouldPop = await showDialog<bool>(
      //     context: context,
      //     builder: (context) =>
      //         AlertDialog(
      //           title:  Text('Are you sure?',style: GoogleFonts.inter(color: primaryColor)),
      //           content:  Text('Do you really want to Exit?',style: GoogleFonts.inter()),
      //           actions: <Widget>[
      //             TextButton(
      //               onPressed: () => Navigator.of(context).pop(false),
      //               child: Text('No',style: GoogleFonts.inter(color: primaryColor)),
      //             ),
      //             TextButton(
      //               onPressed: () => Navigator.of(context).pop(true),
      //               child:  Text('Yes',style: GoogleFonts.inter(color: primaryColor),),
      //             ),
      //           ],
      //         ),
      //   );
      //   return shouldPop ?? false;
      // },
      // child:
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(

          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,size: width*0.045,),
            onPressed: () {
              Navigator.pop(context); // Goes back to the previous screen
            },
          ),
          // toolbarHeight: 50.0, // Increases AppBar height
          elevation: 1.0, // Increase for more shadow
          shadowColor: Colors.grey,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back_ios,size: width*0.045,),
          //   onPressed: () {
          //     Navigator.pop(context); // Goes back to the previous screen
          //   },
          // ),
          title: Padding(
            padding:  EdgeInsets.only(left: width*0.045,right: width*0.045),
            child: Text(
              'Edit Card',
              style: GoogleFonts.inter(fontSize: width*0.05,fontWeight: FontWeight.w500),
            ),
          ),
          actions: [
            Row(
              children: [

                // Delete Icon
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: IconButton(
                    icon: Icon(Icons.delete, size: width * 0.05, color:  Colors.grey.shade600),
                    onPressed: () {
                      // Handle the delete action here
                      _showDeleteDialog(context,widget.groupId);
                    },
                  ),
                ),
                // Delete Text
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: InkWell(
                    onTap: (){
                      _showDeleteDialog(context,widget.groupId);

                    },
                    child: Text(
                      "Delete Card",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: width * 0.04),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Padding(
          padding:  EdgeInsets.only(top:width*0.045,left: width*0.06,right: width*0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextFormField for input
              TextFormField(
                controller: cardTitle,
                decoration: InputDecoration(
                  labelText: "Card title",
                  hintText: "Card title",
                  labelStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: width*0.03,
                    color: Color(0xff6F6F6F),
                  ),
                  hintStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: width*0.03,
                    color: const Color(0xFF6F6F6F),
                  ),
                  // border: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(width*0.03)),
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide: const BorderSide(color: primaryColor),
                  //   borderRadius: BorderRadius.circular(width*0.03),
                  // ),
                ),
              ),
              SizedBox(height: width*0.06),
              Text(
                'Set Cover',
                style: GoogleFonts.inter(fontSize: width*0.03),
              ),
              // Row with Color Palette and Image Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Pick a Color'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: selectedColor,
                                onColorChanged: (Color color) {
                                  setState(() {
                                    selectedColor = color;
                                    hexColor = '#${selectedColor.value.toRadixString(16).padLeft(8, '0')}';                                      });
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Done'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedColor, // Display the selected color
                        borderRadius: BorderRadius.circular(width*0.005),
                      ),
                      padding: EdgeInsets.all(width*0.02),
                      child: Icon(
                        Icons.palette,
                        size: width*0.1,
                        // color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: EdgeInsets.only(top: width * 0.028),
                    child: Column(
                      children: [
                        downloadUrl.isEmpty
                            ? _image==null? IconButton(
                          icon: Icon(
                            Icons.image,
                            size: width * 0.185,
                          ),
                          onPressed: _isUploading
                              ? null  // Disable while uploading
                              : () {
                            _showImageSourceActionSheet(context);
                          },
                        ):
                        InkWell(
                          onTap: _isUploading
                              ? null  // Disable while uploading
                              : () {
                            _showImageSourceActionSheet(context);
                          },
                          child: Container(
                            color: Colors.grey,
                            height: width * 0.14,
                            width: width * 0.14,
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                            : InkWell(
                          onTap: _isUploading
                              ? null  // Disable while uploading
                              : () {
                            _showImageSourceActionSheet(context);
                          },
                          child: Container(
                            color: Colors.grey,
                            height: width * 0.14,
                            width: width * 0.14,
                            child: _isUploading
                                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                                : _image != null
                                ? Image.file(_image!, fit: BoxFit.fill)
                                : Image.network(downloadUrl, fit: BoxFit.fill),
                          ),
                        ),
                        Text(
                          'Select image',
                          style: GoogleFonts.inter(fontSize: width * 0.02),
                        ),
                      ],
                    ),
                  )


                ],
              ),
              // SizedBox(height: width*0.1),

              // Add New Card section with Add Icon
              Row(
                children: [
                  Text(
                    'Add Members',
                    style: GoogleFonts.inter(
                        fontSize: width*0.04, color: Colors.black.withOpacity(.6)),
                  ),
                  SizedBox(width: width*0.04),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddMemberPage(type: false, groupId:widget.groupId ,)),
                        ).then((value) {
                          // Make sure the returned value is of the expected type
                          if (value is List) {
                            setState(() {
                              addedMembers = value; // Update added members
                            });
                          }
                        });
                        // Navigator.pushNamed(context, '/AddMemberPage',
                        //   arguments: {
                        //     'type':false,
                        //     'id': "",
                        //     'members': 0,
                        //   },);
                        // Handle add action
                      },
                    ),
                  ),



                ],
              ),
              Expanded(
                child: (widget.memberList.isEmpty && addedMembers.isEmpty)
                    ? Center(
                  child: Text(
                    "No members added yet",
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.memberList.length + addedMembers.length,
                  itemBuilder: (context, index) {
                    // Determine if the item is from memberList or addedMembers
                    final isExistingMember = index < widget.memberList.length;
                    final member = isExistingMember
                        ? widget.memberList[index] // MemberModel
                        : addedMembers[index - widget.memberList.length]; // Contact

                    // Use the correct properties based on the type of member
                    String title;
                    String? subtitle;

                    if (isExistingMember) {
                      // MemberModel object
                      title = member.memberName ?? "No Name"; // Replace with the correct property for MemberModel
                      subtitle = member.phone ?? "No Phone"; // Replace with the correct property
                    } else {
                      // Contact object
                      title = member.displayName ?? "No Name";
                      subtitle = member.phones.isNotEmpty
                          ? member.phones.first.value
                          : "No Phone";
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          title,
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          subtitle ?? "",
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                        ),
                        trailing:GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isExistingMember) {
                                if (index >= 0 && index < widget.memberList.length) {
                                  final memberId = widget.memberList[index].memberId;

                                  if (memberId != null && memberId.isNotEmpty) {
                                    FirebaseFirestore.instance
                                        .collection(FirebaseConstants.groups)
                                        .doc(widget.groupId)
                                        .collection(FirebaseConstants.members)
                                        .doc(memberId)
                                        .delete()
                                        .then((_) {
                                      setState(() {
                                        widget.memberList.removeAt(index);
                                      });
                                    }).catchError((error) {
                                      print('Error deleting member: $error');
                                    });
                                  } else {
                                    print('Invalid memberId: $memberId');
                                  }
                                } else {
                                  print('Invalid index for memberList: $index');
                                }
                              } else {
                                int addedMembersIndex = index - widget.memberList.length;
                                if (addedMembersIndex >= 0 && addedMembersIndex < addedMembers.length) {
                                  setState(() {
                                    addedMembers.removeAt(addedMembersIndex);
                                  });
                                } else {
                                  print('Invalid index for addedMembers: $addedMembersIndex');
                                }
                              }
                            });
                          },

                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),

                      ),
                    );
                  },
                ),
              ),



            ],
          ),
        ),
        ///it is for add new card or group
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:_isUploading==false? Padding(
          padding:  EdgeInsets.all(width*0.07),
          child: SizedBox(
            height: width*0.12,
            width: width*0.3,
            child: FloatingActionButton.extended(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.white,
              onPressed: () async {
                if(cardTitle.text != ""){
                  bool? confirmed = await EditPopup.show(
                    context: context,
                    title: "Edit Card",
                    content: "Are you sure you want to Edit Card?",
                    // primaryColor:primaryColor, // Use app's primary color
                    primaryColor:primaryColor, // Use app's primary color
                  );

                  if (confirmed == true) {
                    final groupData = GroupModel(
                      groupName: cardTitle.text.trim(),
                      date: DateTime.now(),
                      groupId: widget.groupId,
                      delete:false,
                      color:hexColor??"",
                      image: downloadUrl??"",
                      membersCount:0,
                      userId: globalUserId.toString()
                    );
                    if(addedMembers.isNotEmpty){
                      memberList = addedMembers.map((member) {
                        return MemberModel(
                          memberName: member.displayName ?? "",
                          phone: member.phones != null && member.phones!.isNotEmpty
                              ? member.phones!.first.value
                              : "",
                          memberId: '', // This will be generated when added to Firestore
                          date: DateTime.now(),
                          delete: false,
                          email: "",
                          facebook: "",
                          twitter: "",
                          linkedin: "",
                          website: "",
                          whatsapp: "",
                          instagram: "",
                          // Set image if necessary
                        );
                      }).toList();
                    }
                    await UpdateGroup(context, groupData,memberList);
                    cardTitle.text = "";
                    setState(() {
                      addedMembers.clear();
                    });

                    // admins1=[];
                    showUploadMessage(context,
                      'Group updated successfully',);
                    // Perform the delete action
                    // setState(() {
                    //   // items.removeAt(index); // Example: remove the item from the list
                    // });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>NavigationBarPage(initialIndex: 0)));



                  }

                }else{
                  showSnackBar(context, 'Please enter card Name');
                }


                // Handle the button press

              },
               icon: CircleAvatar(
                radius: 16,
                backgroundColor:primaryColor,child: Icon(Icons.check,color: Colors.white,)),
            label: Text('Done',style: GoogleFonts.inter(color: Colors.black,fontSize: 20),),
            ),
          ),
        ):Padding(
          padding:  EdgeInsets.all(width*0.07),
          child: SizedBox(
            height: width*0.12,
            width: width*0.3,
            child: FloatingActionButton.extended(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                showSnackBar(context, 'Uploading Image');

              },
              icon: CircleAvatar(
                  radius: 16,
                  backgroundColor:primaryColor,child: Icon(Icons.check,color: Colors.white,)),
              label: Text('Done',style: GoogleFonts.inter(color: Colors.black,fontSize: 20),),
            ),
          ),
        ),
      );
    // );
  }
  void _showDeleteDialog(BuildContext context, String groupId,) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Card?"),
        content: Text("Are you sure you want to delete this card?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Reference the group document
                DocumentReference groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);

                // Fetch the subcollections and delete their documents
                WriteBatch batch = FirebaseFirestore.instance.batch();

                // Deleting the 'members' subcollection documents
                QuerySnapshot membersSnapshot = await groupRef.collection('members').get();
                for (var memberDoc in membersSnapshot.docs) {
                  batch.delete(memberDoc.reference);
                }

                // Add deletion of other subcollections as needed


                // Finally delete the group document
                batch.delete(groupRef);

                // Commit the batch
                await batch.commit();

                // Provide feedback to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Card deleted successfully!')),
                );
              } catch (e) {
                // Handle errors gracefully
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete group: $e')),
                );
              }
              // FirebaseFirestore.instance
              //     .collection('groups')
              //     .doc(groupId)
              //     .delete();
              // Perform delete action here
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              // Add logic to delete the card
              // showUploadMessage(context, 'Card deleted successfully');
            },
            child: Text("Delete", style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }
}
