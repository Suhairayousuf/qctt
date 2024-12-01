//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qctt/core/constants/firebase_constants.dart';
// import 'package:qctt/core/utils/utils.dart';
// import 'package:qctt/features/Home/screens/sqflite.dart';
// import 'package:qctt/models/member_model.dart';
//
// import '../../../core/pallette/pallete.dart';
// import '../../Home/screens/splash_screen.dart';
//
// class AddMemberPage extends StatefulWidget {
//   final bool type;
//   final String groupId;
//   const AddMemberPage({Key? key, required this.type, required this.groupId}) : super(key: key);
//
//   @override
//   State<AddMemberPage> createState() => _AddMemberPageState();
// }
//
// class _AddMemberPageState extends State<AddMemberPage> {
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   TextEditingController _searchController = TextEditingController();
//   List<Contact> totalContactsSearch = [];
//   List<Contact> _contacts = [];
//   List<Contact> selectedContacts = []; // To store selected contacts
//
//   Future<bool> requestContactPermission() async {
//     var status = await Permission.contacts.status;
//     if (status.isDenied) {
//       status = await Permission.contacts.request();
//     }
//     return status.isGranted;
//   }
//
//   Future<List<Contact>> getContacts() async {
//     bool isGranted = await requestContactPermission();
//     if (isGranted) {
//       Iterable<Contact> contacts = await ContactsService.getContacts();
//       return contacts.toList();
//     } else {
//       throw Exception("Contact permission not granted");
//     }
//   }
//
//   Future<void> loadContacts() async {
//     try {
//       List<Contact> contacts = await getContacts();
//       setState(() {
//         _contacts = contacts;
//         totalContactsSearch = contacts;
//       });
//     } catch (e) {
//       print("Error fetching contacts: $e");
//     }
//   }
//
//   void searchContacts(String txt) {
//     totalContactsSearch = _contacts
//         .where((contact) =>
//     contact.displayName != null &&
//         contact.displayName!.toLowerCase().contains(txt.toLowerCase()))
//         .toList();
//     setState(() {});
//   }
//
//   Future<void> saveContactsLocally(List<Contact> contacts) async {
//     await _dbHelper.deleteAllContacts(); // Clear existing data
//     for (Contact contact in contacts) {
//       String name = contact.displayName ?? "Unknown";
//       String phone = contact.phones!.isNotEmpty ? contact.phones!.first.value ?? "No Number" : "No Number";
//       await _dbHelper.insertContact(name, phone);
//     }
//   }
//   Future<void> loadContactsFromSQLite() async {
//     List<Map<String, dynamic>> savedContacts = await _dbHelper.fetchContacts();
//     setState(() {
//       _contacts = savedContacts.map((e) {
//         return Contact(
//           displayName: e['name'],
//           phones: [Item(label: 'mobile', value: e['phone'])],
//         );
//       }).toList();
//       totalContactsSearch = _contacts;
//     });
//   }
//   Future<void> fetchAndSaveContacts() async {
//     try {
//       List<Contact> contacts = await getContacts();
//       await saveContactsLocally(contacts);
//       setState(() {
//         _contacts = contacts;
//         totalContactsSearch = contacts;
//       });
//     } catch (e) {
//       print("Error fetching contacts: $e");
//     }
//   }
//   @override
//   void initState() {
//     requestContactPermission();
//     // loadContacts();
//     loadContactsFromSQLite(); // Load locally saved contacts
//     fetchAndSaveContacts();
//     super.initState();
//   }
//
//   void toggleSelection(Contact contact) {
//     setState(() {
//       if (selectedContacts.contains(contact)) {
//         selectedContacts.remove(contact);
//       } else {
//         selectedContacts.add(contact);
//       }
//     });
//   }
//
//   void saveAndReturn() {
//     // Save selectedContacts to memberList or database
//     Navigator.pop(context, selectedContacts);
//   }
//   void addMember() {
//     // Prepare a list to hold MemberModel instances
//     List<MemberModel> memberList = [];
//
//     // Convert selectedContacts to MemberModel instances
//     if (selectedContacts.isNotEmpty) {
//
//       memberList = selectedContacts.map((member) {
//         return MemberModel(
//           memberName: member.displayName ?? "",
//           phone: member.phones != null && member.phones!.isNotEmpty
//               ? member.phones!.first.value ?? ""
//               : "",
//           memberId: '', // Firestore will generate an ID
//           date: DateTime.now(),
//           delete: false,
//           email: "",
//           facebook: "",
//           twitter: "",
//           linkedin: "",
//           website: "",
//           whatsapp: "",
//           instagram: "",
//           // Add image or other fields if necessary
//         );
//       }).toList();
//     }
//
//     // Save each member in Firestore
//     // List numberList=[];
//     // for(var abc in selectedContacts){
//     //   numberList.add(abc.phones);
//     //
//     // }
//     final groupRef = FirebaseFirestore.instance
//         .collection(FirebaseConstants.groups)
//         .doc(widget.groupId)
//         .collection(FirebaseConstants.members);
//
//     for (var member in memberList) {
//       groupRef.add(member.toJson()); // Convert MemberModel to JSON and save to Firestore
//     }
//     if(mounted){
//       setState(() {
//
//       });
//     }
//     showSnackBar(context, 'Member added successfulyy');
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios, size: 24),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           shadowColor: Colors.grey,
//           backgroundColor: Colors.white,
//           title: Text(
//             'Add Member',
//             style: GoogleFonts.roboto(fontSize: 20),
//           ),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 0.0),
//               child: Card(
//                 child: Container(
//
//                   // width: scrWidth,
//                   // height: textFormFieldHeight45,
//                   width: 400,
//                   height: 50,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: width * 0.03,
//                     vertical: 2.5,
//                   ),
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.grey.withOpacity(0.1), // Shadow color
//                           offset: Offset(0, 4), // Shadow offset
//                           blurRadius: 8, spreadRadius: 8// Blur effect
//                       ),
//                     ],
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(17),
//                   ),
//                   child: TextFormField(
//                     // cursorHeight: scrWidth * 0.055,
//                     // cursorWidth: 1,
//                     // cursorColor: Colors.black,
//                     controller: _searchController,
//                     showCursor: false,
//                     onChanged: searchContacts,
//                     // ((txt) {
//                     //   totalContactsSearch = [];
//                     //   if (_searchController.text == '') {
//                     //     totalContactsSearch.addAll(_contacts);
//                     //   } else {
//                     //     searchContacts(_searchController.text);
//                     //   }
//                     // }),
//                     style: GoogleFonts.inter(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w300,
//                       fontSize: 14,
//
//                     ),
//                     decoration: InputDecoration(
//                       suffixIcon: Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: width * 0.015,
//                             vertical: width * 0.015,
//                           ),
//                           child: Icon(Icons.search,color: primaryColor,)
//                         // SvgPicture.asset('assets/icons/search.svg',
//                         //     fit: BoxFit.contain, color: Color(0xff8391A1)),
//                       ),
//                       hintText: 'Search contacts...',
//                       hintStyle: GoogleFonts.inter(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w300,
//                         fontSize: 14,
//                         // fontFamily: 'Urbanist',
//                       ),
//                       fillColor:Colors.white,
//                       filled: true,
//                       contentPadding: EdgeInsets.only(
//                           top: width * 0.03, bottom: width * 0.03),
//                       disabledBorder: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       errorBorder: InputBorder.none,
//                       border: InputBorder.none,
//                       focusedBorder: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: totalContactsSearch.isEmpty
//                   ? Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                 itemCount: totalContactsSearch.length,
//                 itemBuilder: (context, index) {
//                   final contact = totalContactsSearch[index];
//                   final isSelected = selectedContacts.contains(contact);
//                   return Column(
//                     children: [
//                       InkWell(
//                         onTap: (){
//                           toggleSelection(contact);
//                         },
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             radius: 22,
//                             backgroundColor: Colors.black,
//                             child: Icon(
//                               Icons.person,
//                               color: Colors.white,
//                               size: 24,
//                             ),
//                           ),
//                           title: Text(
//                             contact.displayName ?? "No Name",
//                             style: GoogleFonts.inter(fontSize: 16),
//                           ),
//                           subtitle: contact.phones != null &&
//                               contact.phones!.isNotEmpty
//                               ? Text(contact.phones!.first.value ?? "No Number")
//                               : null,
//                           trailing: GestureDetector(
//                             onTap: () => toggleSelection(contact),
//                             child: CircleAvatar(
//                               radius: 10,
//                               backgroundColor: isSelected
//                                   ? primaryColor
//                                   : Colors.grey.shade300,
//                               // child: Icon(
//                               //   Icons.check,
//                               //   color: Colors.white,
//                               //   size: 18,
//                               // ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Divider(color: Colors.grey.shade300), // Ad
//                     ],
//                   );
//                 },
//               ),
//             ),
//
//           ],
//         ),
//         floatingActionButton:selectedContacts.isNotEmpty? widget.type==false?Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: SizedBox(
//             height: width*0.12,
//             width: width*0.25,
//             child: FloatingActionButton.extended(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               onPressed: saveAndReturn,
//               backgroundColor: primaryColor,
//               icon: CircleAvatar(
//                   radius: 16,
//                   backgroundColor:Colors.white,child: Icon(Icons.check)),
//               label: Text('Add',style: GoogleFonts.roboto(color: Colors.white),),
//             ),
//           ),
//         ):Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: SizedBox(
//             height: width*0.12,
//             width: width*0.25,
//             child: FloatingActionButton.extended(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               onPressed: addMember,
//               backgroundColor: primaryColor,
//               icon: CircleAvatar(
//                   radius: 16,
//                   backgroundColor:Colors.white,child: Icon(Icons.check)),
//               label: Text('Add',style: GoogleFonts.roboto(color: Colors.white),),
//             ),
//           ),
//         ):Container()
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qctt/core/constants/firebase_constants.dart';
import 'package:qctt/core/utils/utils.dart';
import 'package:qctt/features/Home/screens/sqflite.dart';
import 'package:qctt/models/member_model.dart';

import '../../../core/pallette/pallete.dart';
import '../../../main.dart';
import '../../Home/screens/routing_page.dart';
import '../../Home/screens/splash_screen.dart';

class AddMemberFromEditPage extends StatefulWidget {
  final bool type;
  final String groupId;
  const AddMemberFromEditPage({Key? key, required this.type, required this.groupId}) : super(key: key);

  @override
  State<AddMemberFromEditPage> createState() => _AddMemberFromEditPageState();
}

class _AddMemberFromEditPageState extends State<AddMemberFromEditPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  TextEditingController _searchController = TextEditingController();
  List<Contact> totalContactsSearch = [];
  List<Contact> _contacts = [];
  List<Contact> selectedContacts = [];
  Set<String> addedPhoneNumbers = {};
  bool exist=false;// To store selected contacts

  Future<bool> requestContactPermission() async {
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      status = await Permission.contacts.request();
    }
    return status.isGranted;
  }
  // getContactsForadd( String number) async {
  //   print('0000000');
  //   final groupRef = await FirebaseFirestore.instance
  //       .collection(FirebaseConstants.groups)
  //       .doc(widget.groupId)
  //       .collection(FirebaseConstants.members)
  //       .get();
  //   print('111111');
  //   print(groupRef);
  //   List<String> phoneNumbers = [];
  //   for (var doc in groupRef.docs) {
  //     // Assuming the document has a 'phone' field, you can get it like this
  //     var phone = doc.data()['phone'];
  //
  //     // Add the phone number to the list if it's not null or empty
  //     if (phone != null && phone.isNotEmpty) {
  //       phoneNumbers.add(phone);
  //
  //     }
  //     print('222222');
  //     print(phoneNumbers);
  //     print(number.);
  //     print('number');
  //     if(phoneNumbers.contains(number)){
  //       exist=true;
  //       if(mounted){
  //         setState(() {
  //           print('1pppppp');
  //
  //         });
  //       }
  //     }
  //   }
  //
  // }
  Future<List<Contact>> getContacts() async {
    bool isGranted = await requestContactPermission();
    if (isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      return contacts.toList();
    } else {
      throw Exception("Contact permission not granted");
    }
  }

  Future<void> loadContacts() async {
    try {
      List<Contact> contacts = await getContacts();
      setState(() {
        _contacts = contacts;
        totalContactsSearch = contacts;
      });
    } catch (e) {
      print("Error fetching contacts: $e");
    }
  }

  void searchContacts(String txt) {
    totalContactsSearch = _contacts
        .where((contact) =>
    contact.displayName != null &&
        contact.displayName!.toLowerCase().contains(txt.toLowerCase()))
        .toList();
    setState(() {});
  }

  Future<void> saveContactsLocally(List<Contact> contacts) async {
    await _dbHelper.deleteAllContacts(); // Clear existing data
    for (Contact contact in contacts) {
      String name = contact.displayName ?? "Unknown";
      String phone = contact.phones!.isNotEmpty ? contact.phones!.first.value ?? "No Number" : "No Number";
      await _dbHelper.insertContact(name, phone);
    }
  }
  Future<void> loadContactsFromSQLite() async {
    List<Map<String, dynamic>> savedContacts = await _dbHelper.fetchContacts();
    setState(() {
      _contacts = savedContacts.map((e) {
        return Contact(
          displayName: e['name'],
          phones: [Item(label: 'mobile', value: e['phone'])],
        );
      }).toList();
      totalContactsSearch = _contacts;
    });
  }
  Future<void> fetchAndSaveContacts() async {
    try {
      List<Contact> contacts = await getContacts();
      await saveContactsLocally(contacts);
      setState(() {
        _contacts = contacts;
        totalContactsSearch = contacts;
      });
    } catch (e) {
      print("Error fetching contacts: $e");
    }
  }
  Future<void> fetchAddedPhoneNumbers() async {
    final groupRef = FirebaseFirestore.instance
        .collection(FirebaseConstants.groups)
        .doc(widget.groupId)
        .collection(FirebaseConstants.members);

    final snapshot = await groupRef.get();
    addedPhoneNumbers = snapshot.docs
        .map((doc) => doc.data()['phone'] as String)
        .toSet(); // Store all added phone numbers in a set
  }
  @override
  void initState() {
    requestContactPermission();
    // loadContacts();
    loadContactsFromSQLite(); // Load locally saved contacts
    fetchAndSaveContacts();
    fetchAddedPhoneNumbers();
    super.initState();
  }

  void toggleSelection(Contact contact) {
    setState(() {
      if (selectedContacts.contains(contact)) {
        selectedContacts.remove(contact);
      } else {
        selectedContacts.add(contact);
      }
    });
  }

  void saveAndReturn() {
    // Save selectedContacts to memberList or database
    Navigator.pop(context, selectedContacts);
  }
  void addMember() {
    // Prepare a list to hold MemberModel instances
    List<MemberModel> memberList = [];

    // Convert selectedContacts to MemberModel instances
    if (selectedContacts.isNotEmpty) {

      memberList = selectedContacts.map((member) {
        return MemberModel(
          memberName: member.displayName ?? "",
          phone: member.phones != null && member.phones!.isNotEmpty
              ? member.phones!.first.value ?? ""
              : "",
          memberId: '', // Firestore will generate an ID
          date: DateTime.now(),
          delete: false,
          email: "",
          facebook: "",
          twitter: "",
          linkedin: "",
          website: "",
          whatsapp: "",
          instagram: "",
          // Add image or other fields if necessary
        );
      }).toList();
    }

    // Save each member in Firestore
    // List numberList=[];
    // for(var abc in selectedContacts){
    //   numberList.add(abc.phones);
    //
    // }
    final groupRef = FirebaseFirestore.instance
        .collection(FirebaseConstants.groups)
        .doc(widget.groupId)
        .collection(FirebaseConstants.members);

    for (var member in memberList) {
      groupRef.add(member.toJson()); // Convert MemberModel to JSON and save to Firestore
    }
    if(mounted){
      setState(() {

      });
    }
    showSnackBar(context, 'Member added successfully');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 24),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          shadowColor: Colors.grey,
          backgroundColor: Colors.white,
          title: Text(
            'Add Member',
            style: GoogleFonts.inter(fontSize: 20),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Card(
                child: Container(

                  // width: scrWidth,
                  // height: textFormFieldHeight45,
                  width: 400,
                  height: 50,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1), // Shadow color
                          offset: Offset(0, 4), // Shadow offset
                          blurRadius: 8, spreadRadius: 8// Blur effect
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: TextFormField(
                    // cursorHeight: scrWidth * 0.055,
                    // cursorWidth: 1,
                    // cursorColor: Colors.black,
                    controller: _searchController,
                    showCursor: false,
                    onChanged: searchContacts,
                    // ((txt) {
                    //   totalContactsSearch = [];
                    //   if (_searchController.text == '') {
                    //     totalContactsSearch.addAll(_contacts);
                    //   } else {
                    //     searchContacts(_searchController.text);
                    //   }
                    // }),
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,

                    ),
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.015,
                            vertical: width * 0.015,
                          ),
                          child: Icon(Icons.search,color: primaryColor,)
                        // SvgPicture.asset('assets/icons/search.svg',
                        //     fit: BoxFit.contain, color: Color(0xff8391A1)),
                      ),
                      hintText: 'Search contacts...',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        // fontFamily: 'Urbanist',
                      ),
                      fillColor:Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.only(
                          top: width * 0.03, bottom: width * 0.03),
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: totalContactsSearch.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    :ListView.builder(
                  itemCount: totalContactsSearch.length,
                  itemBuilder: (context, index) {

                    final contact = totalContactsSearch[index];
                    final isSelected = selectedContacts.contains(contact);
                    final contactPhone = (contact.phones != null && contact.phones!.isNotEmpty)
                        ? contact.phones!.first.value ?? '0'
                        : '0';
                    final isAdded = addedPhoneNumbers.contains(contactPhone);
                    return Column(
                      children: [
                        InkWell(
                            onTap: !isAdded ? () => toggleSelection(contact) : null,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              title: Text(
                                contact.displayName ?? "No Name",
                                style: TextStyle(
                                  color: isAdded ? Colors.grey : Colors.black,
                                  // decoration: isAdded
                                  //     ? TextDecoration.lineThrough
                                  //     : null,
                                ),
                              ),
                              subtitle: Text(contactPhone.toString(),style: TextStyle(color: Colors.grey),),
                              trailing: isAdded ? Icon(Icons.radio_button_unchecked,color: Colors.grey,)
                                  : selectedContacts.contains(contact)
                                  ? Icon(Icons.circle, color: primaryColor) : Icon(Icons.radio_button_unchecked,color: Colors.grey,),
                            )

                        ),
                        Divider(color: Colors.grey.shade300), // Ad
                      ],
                    );
                  },
                )
            ),

          ],
        ),
        floatingActionButton:selectedContacts.isNotEmpty? widget.type==false?Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: width*0.12,
            width: width*0.25,
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: saveAndReturn,
              backgroundColor: primaryColor,
              icon: CircleAvatar(
                  radius: 16,
                  backgroundColor:Colors.white,child: Icon(Icons.check)),
              label: Text('Add',style: GoogleFonts.inter(color: Colors.white),),
            ),
          ),
        ):Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: width*0.12,
            width: width*0.25,
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: addMember,
              backgroundColor: primaryColor,
              icon: CircleAvatar(
                  radius: 16,
                  backgroundColor:Colors.white,child: Icon(Icons.check)),
              label: Text('Add',style: GoogleFonts.inter(color: Colors.white),),
            ),
          ),
        ):Container()
    );
  }
}

