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
import 'package:qctt/core/pallette/pallete.dart';
import 'package:qctt/features/Home/screens/splash_screen.dart';
import 'package:qctt/models/group_model.dart';
import 'package:qctt/models/member_model.dart';

import '../../../core/utils/utils.dart';
import '../../Home/screens/navigation_page.dart';
import '../controller/group_controller.dart';
import 'add_member_page.dart';

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
  Future<void> _pickGroupImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _groupImagePath = pickedFile.path;
        _image = File(pickedFile.path);
        _imageName = basename(pickedFile.path);
      });

      try {
        // Upload image to Firebase Storage
        String fileName = "group_images/$_imageName";
        Reference storageRef = FirebaseStorage.instance.ref(fileName);

        await storageRef.putFile(_image!);

        // Get the download URL
        downloadUrl = await storageRef.getDownloadURL();

        // Save the download URL to Firestore
        // await FirebaseFirestore.instance.collection('groups').add({
        //   'imageUrl': downloadUrl,
        //   'createdAt': FieldValue.serverTimestamp(),
        // });

        print('Image uploaded and URL saved: $downloadUrl');
      } catch (e) {
        print('Failed to upload image: $e');
      }
    }
  }
// Path for the group image

  // Future<void> _pickGroupImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _groupImagePath = pickedFile.path;
  //       _image = File(pickedFile.path);
  //       _imageName = basename(pickedFile.path);
  //
  //       // Path to display in UI
  //     });
  //   }
  // }
  final cardTitle = TextEditingController();
  Color selectedColor = Colors.blueGrey;
  UpdateGroup(BuildContext context, GroupModel groupData, List<MemberModel> memberList){
    ref.read(groupControllerProvider.notifier).addGroup(context: context,groupModel: groupData,members:memberList);



  }
  @override
  void initState() {
    cardTitle.text = widget.groupName; // Set group name
    selectedColor =  Color(int.parse("0x" + widget.color.replaceAll("#", ""))); // Set color
    downloadUrl = widget.image; // Set image URL
    memberList = widget.memberList; // Set image URL
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
              style: GoogleFonts.roboto(fontSize: width*0.05,fontWeight: FontWeight.w500),
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
                  _image==null?Padding(
                    padding:  EdgeInsets.only(top: width*0.028,),
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.image,
                            size: width*0.185,
                          ),
                          onPressed: () {
                            _pickGroupImage();
                            // Handle image icon action
                          },
                        ),
                        Text(
                          'Select image',
                          style: GoogleFonts.inter(fontSize: width*0.02,),
                        ),

                      ],
                    ),
                  ):Padding(
                    padding:  EdgeInsets.only(top: width*0.028,),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _pickGroupImage();
                            // Handle image icon action
                          },
                          child: Container(
                              color: Colors.grey,
                              height: width*0.14
                              ,width: width*0.14,child: Image.file(_image!,fit: BoxFit.fill,)),
                        ),
                        SizedBox(height: width*0.01),

                        Text(
                          _imageName.toString(),
                          style: GoogleFonts.inter(fontSize: width*0.02,),
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
                          MaterialPageRoute(builder: (context) => AddMemberPage(type: false, groupId: '',)),
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
                        trailing: GestureDetector(
                          onTap: () {
                            // Remove logic
                            setState(() {
                              if (isExistingMember) {
                                widget.memberList.removeAt(index);
                              } else {
                                addedMembers.removeAt(index - widget.memberList.length);
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
        floatingActionButton: Padding(
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
                  bool? confirmed = await AddCardPopup.show(
                    context: context,
                    title: "Add Card",
                    content: "Are you sure you want to add Card?",
                    // primaryColor:primaryColor, // Use app's primary color
                    primaryColor:primaryColor, // Use app's primary color
                  );

                  if (confirmed == true) {
                    final groupData = GroupModel(
                      groupName: cardTitle.text.trim(),
                      date: DateTime.now(),
                      groupId: '',
                      delete:false,
                      color:hexColor??"",
                      image: downloadUrl??"",
                      membersCount:0,
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
                      'Card added suceesfully',);
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
            label: Text('Done',style: GoogleFonts.roboto(color: Colors.black,fontSize: 20),),
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
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('groups')
                  .doc(groupId)
                  .delete();
              // Perform delete action here
              Navigator.of(context).pop();
              // Add logic to delete the card
              showUploadMessage(context, 'Card deleted successfully');
            },
            child: Text("Delete", style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }
}
