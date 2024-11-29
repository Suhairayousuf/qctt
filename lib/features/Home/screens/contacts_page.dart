import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qctt/features/Home/screens/splash_screen.dart';
import 'package:qctt/features/Home/screens/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/images/images.dart';
import '../../../core/pallette/pallete.dart';
import '../../group/screens/group_detailes_page.dart';
import 'navigation_page.dart';
class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  TextEditingController _searchController = TextEditingController();
  List<Contact> totalContactsSearch = [];
  List<Contact> _contacts = [];
  Future<bool> requestContactPermission() async {
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      status = await Permission.contacts.request();
    }
    return status.isGranted;
  }
  Future<List<Contact>> getContacts() async {
    // Ensure permission is granted
    bool isGranted = await requestContactPermission();
    if (isGranted) {
      // Await the result and convert to a list
      Iterable<Contact> contacts = await ContactsService.getContacts();
      return contacts.toList(); // Convert Iterable to List
    } else {
      throw Exception("Contact permission not granted");
    }
  }

  Future<void> loadContacts() async {
    try {
      List<Contact> contacts = await getContacts();
      setState(() {
        _contacts = contacts;
        totalContactsSearch=contacts;
      });
    } catch (e) {
      print("Error fetching contacts: $e");
    }
  }
  searchContacts(String txt) {
    print(totalContactsSearch.length);
    totalContactsSearch = [];
    for (int i = 0; i < _contacts.length; i++) {
      String name = _contacts[i].displayName ?? '';
      if (name.toLowerCase().contains(txt.toLowerCase())) {
        totalContactsSearch.add(_contacts[i]);
      }
    }
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
  @override
  void initState() {
    totalContactsSearch = _contacts;
    requestContactPermission();
    // getContacts();
    // loadContacts();
    loadContactsFromSQLite(); // Load locally saved contacts
    fetchAndSaveContacts();
    // TODO: implement initState
    super.initState();
  }
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          // elevation: 0, // Increase for more shadow
          shadowColor: Colors.grey,
          backgroundColor: Colors.white,

          automaticallyImplyLeading: false,
          title: Text('Contacts',style: GoogleFonts.roboto(fontSize: width*0.05),),
        ),
        body:
        totalContactsSearch.isEmpty?Center(child: CircularProgressIndicator()):
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Card(
                child: Container(

                  // width: scrWidth,
                  // height: textFormFieldHeight45,
                  width: width*0.95,
                  height: width*0.11,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: width * 0.01
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
                    onChanged: ((txt) {
                      totalContactsSearch = [];
                      if (_searchController.text == '') {
                        totalContactsSearch.addAll(_contacts);
                      } else {
                        searchContacts(_searchController.text);
                      }
                    }),
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: width * 0.03,

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
                        fontSize: width * 0.035,
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
              child:
              ListView.builder(
                itemCount: totalContactsSearch.length,
                itemBuilder: (context, index) {
                  final contact = totalContactsSearch[index];
                  return InkWell(
                    onTap: () {
                      // Handle tap
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: width * 0.018, horizontal: width * 0.03), // Adjust padding as needed
                      child: Column(
                        children: [
                          // SizedBox(height: width * 0.01,),

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
                              SizedBox(width: width * 0.03), // Space between leading and title

                              // Title and Subtitle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                                  children: [
                                    Text(
                                      contact.displayName.toString(),
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: width * 0.036,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (contact.phones != null && contact.phones!.isNotEmpty)
                                      Text(
                                        contact.phones!.first.value ?? "No Phone Number",
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                          fontSize: width * 0.032,
                                        ),
                                      ),
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
                                          'name': contact.displayName,
                                          'phNumber':contact.phones!.first.value.toString()

                                        },
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.green.shade700,
                                      child: Icon(Icons.group_sharp, color: Colors.white, size: width * 0.08),
                                    ),
                                  ),
                                  SizedBox(width: width * 0.025),
                                  InkWell(
                                    onTap: () async {
                                      String whatsappNumber = "+91" + (contact.phones!.first.value.toString() ?? "");
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
                                  SizedBox(width: width * 0.025),
                                  InkWell(
                                    onTap: () async {
                                      String phoneNumber = "+91" + (contact.phones!.first.value.toString() ?? "");
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
                          SizedBox(height: width * 0.023), // Space between items
                          Divider(color: Colors.grey.shade300), // Add divider
                        ],
                      ),
                    ),
                  );
                },
              ),

            ),
          ],

        ),




        // ListView.builder(
        //   itemCount: _contacts.length,
        //   itemBuilder: (context, index) {
        //     Contact contact = _contacts[index];
        //     return ListTile(
        //       title: Text(contact.displayName ?? "No Name"),
        //       subtitle: contact.phones!.isNotEmpty
        //           ? Text(contact.phones!.first.value ?? "No Number")
        //           : null,
        //     );
        //   },
        // ),
      ),
    );
  }
}
