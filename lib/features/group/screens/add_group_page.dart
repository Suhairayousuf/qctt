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


import '../../../core/pallette/pallete.dart';
import '../../../core/utils/utils.dart';
import '../../../main.dart';
import '../../../models/group_model.dart';
import '../../../models/member_model.dart';
import '../../Home/screens/navigation_page.dart';
import '../../Home/screens/routing_page.dart';
import '../controller/group_controller.dart';
import 'add_member_page.dart';

class AddGroupPage extends ConsumerStatefulWidget {
  const AddGroupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddGroupPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends ConsumerState<AddGroupPage> {
  String? _groupImagePath;
  File? _image;
  String? _imageName;
  String hexColor = '';
  String downloadUrl="";
   List addedMembers=[];
  List<MemberModel> memberList=[];
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
                _pickGroupImage(ImageSource.camera);// Return false
              },
              child: Text(
                "Camera",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickGroupImage(ImageSource.gallery);// Return true
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
  Future<void> _pickGroupImage(ImageSource source) async {
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

        // Get the download URL
        setState(() {
          downloadUrl = updatedDownloadUrl; // Update the URL in state

          _isUploading = false;
        });


        // Save the download URL to Firestore (if needed)
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
  addGroup(BuildContext context, GroupModel groupData, List<MemberModel> memberList){
    ref.read(groupControllerProvider.notifier).addGroup(context: context,groupModel: groupData,members:memberList);



  }
  @override
  Widget build(BuildContext context) {

    return

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

          title: Padding(
            padding:  EdgeInsets.only(left: width*0.045,right: width*0.045),
            child: Text(
              'Add New Card',
              style: GoogleFonts.inter(fontSize: width*0.05,fontWeight: FontWeight.w500),
            ),
          ),
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
                  SizedBox(width: width*0.04),
                  Padding(
                    padding: EdgeInsets.only(top: width * 0.028),
                    child: Column(
                      children: [
                        downloadUrl.isEmpty
                            ?_image==null? IconButton(
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
                  // _image==null?Padding(
                  //   padding:  EdgeInsets.only(top: width*0.028,),
                  //   child: Column(
                  //     children: [
                  //       IconButton(
                  //         icon: Icon(
                  //           Icons.image,
                  //           size: width*0.185,
                  //         ),
                  //         onPressed: () {
                  //           _showImageSourceActionSheet(context); // Pass the BuildContext
                  //
                  //           // _pickGroupImage();
                  //           // Handle image icon action
                  //         },
                  //       ),
                  //       Text(
                  //         'Select image',
                  //         style: GoogleFonts.inter(fontSize: width*0.02,),
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ):Padding(
                  //   padding:  EdgeInsets.only(top: width*0.028,),
                  //   child: Column(
                  //     children: [
                  //       InkWell(
                  //         onTap: () {
                  //           _showImageSourceActionSheet(context); // Pass the BuildContext
                  //           // _pickGroupImage();
                  //           // Handle image icon action
                  //         },
                  //         child: Container(
                  //           color: Colors.grey,
                  //             height: width*0.14
                  //             ,width: width*0.14,child: Image.file(_image!,fit: BoxFit.fill,)),
                  //       ),
                  //       SizedBox(height: width*0.01),
                  //
                  //       Text(
                  //         // _imageName.toString(),
                  //         'select image',
                  //         style: GoogleFonts.inter(fontSize: width*0.02,), overflow: TextOverflow.ellipsis
                  //       ),
                  //     ],
                  //   ),
                  // )
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
                child: addedMembers.isEmpty
                    ? Center(child:Container())
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: addedMembers.length,
                  itemBuilder: (context, index) {
                    final member = addedMembers[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0), // Padding for ListTile separation
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
                          member.displayName ?? "No Name",
                          style: GoogleFonts.inter(fontSize: 14,fontWeight: FontWeight.bold),
                        ),
                        subtitle: member.phones != null && member.phones!.isNotEmpty
                            ? Text(member.phones!.first.value ?? "No Number",style:GoogleFonts.inter(fontSize: 12,color: Colors.grey) ,)
                            : null,
                        trailing: GestureDetector(
                          onTap: () {
                            // Handle close icon tap
                            setState(() {
                              addedMembers.removeAt(index); // Remove the member at the current index
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: width*0.05,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        ///it is for add new card or group
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:_isUploading==false? Padding(
          padding:  EdgeInsets.all(width*0.05),
          child: SizedBox(
            height: width*0.12,
            width: width*0.35,
            child: FloatingActionButton.extended(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.blue,
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
                    await addGroup(context, groupData,memberList);
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
              label: Row(
                children: [
                  Icon(Icons.add,color: Colors.white,),
                  SizedBox(width: width*0.02),
                  Text(
                    "Add Card",
                    style: GoogleFonts.inter(fontSize: width*0.04,color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ):Padding(
          padding: EdgeInsets.all(width * 0.05),
          child: SizedBox(
            height: width * 0.12,
            width: width * 0.35,
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.blue,
              onPressed: _isUploading
                  ? null // Disable the button while uploading
                  : () async {
                setState(() {
                  _isUploading = true; // Set uploading state to true
                });

                // Simulate uploading process
                await Future.delayed(Duration(seconds: 3));

                setState(() {
                  _isUploading = false; // Reset uploading state to false
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Image uploaded successfully!')),
                );
              },
              label: _isUploading
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: width * 0.05,
                    width: width * 0.05,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.0,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    "Uploading...",
                    style: GoogleFonts.inter(
                      fontSize: width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
                  : Row(
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: width * 0.02),
                  Text(
                    "Add Card",
                    style: GoogleFonts.inter(
                      fontSize: width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        );


     // );
  }
}
