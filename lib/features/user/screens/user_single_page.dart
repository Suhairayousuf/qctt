import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qctt/core/constants/images/images.dart';

import '../../../models/member_model.dart';
import '../../Home/screens/splash_screen.dart';


// class UserSinglePage extends StatefulWidget {
//   @override
//   State<UserSinglePage> createState() => _UserSinglePageState();
// }
//
// class _UserSinglePageState extends State<UserSinglePage> {
//   final List<Map<String, String>> userDetails = [
//     {'label': 'Name', 'value': 'John Doe'},
//     {'label': 'Phone', 'value': '+123 456 7890'},
//     {'label': 'WhatsApp', 'value': '+123 456 7890'},
//     {'label': 'Facebook', 'value': 'facebook.com/johndoe'},
//     {'label': 'Instagram', 'value': 'instagram.com/johndoe'},
//     {'label': 'Website', 'value': 'www.johndoe.com'},
//     {'label': 'Email', 'value': 'john.doe@example.com'},
//     {'label': 'LinkedIn', 'value': 'linkedin.com/in/johndoe'},
//   ];
//
//   final Map<String, IconData> iconMap = {
//     'Name': Icons.person,
//     'Phone': Icons.phone,
//     'WhatsApp': Icons.chat,
//     'Facebook': Icons.facebook,
//     'Instagram': Icons.camera_alt,
//     'Website': Icons.language,
//     'Email': Icons.email,
//     'LinkedIn': Icons.work,
//   };
//
//   String memberId = '';
//   String groupId = '';
//   MemberModel? member;
//
//   @override
//   void didChangeDependencies() {
//     final arguments =
//     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
//     groupId = arguments['groupId'].toString();
//     memberId = arguments['memberId'].toString();
//     member = arguments['memberModel'];
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios,
//             size: MediaQuery.of(context).size.width * 0.045,
//           ),
//           onPressed: () {
//             Navigator.pop(context); // Goes back to the previous screen
//           },
//         ),
//         title: Text(
//           member?.memberName ?? 'Loading...',
//           style: GoogleFonts.inter(
//             fontSize: MediaQuery.of(context).size.width * 0.045,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
//         child: ListView.builder(
//           itemCount: userDetails.length,
//           itemBuilder: (context, index) {
//             final label = userDetails[index]['label'] ?? '';
//             final value = userDetails[index]['value'] ?? '';
//             return ListTile(
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: MediaQuery.of(context).size.width * 0.01,
//               ),
//               leading:
//               title: Text(
//                 label,
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(value),
//               trailing: IconButton(
//                 icon: InkWell(
//                   onTap: () {
//                     Navigator.pushNamed(
//                       context,
//                       '/EditUserDetails',
//                       arguments: {
//                         'label': label,
//                         'data': value,
//                       },
//                     );
//                   },
//                   child: Icon(Icons.edit, color: Colors.blue),
//                 ),
//                 onPressed: () {
//                   print('Edit $label');
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
class UserSinglePage extends StatefulWidget {
  @override
  State<UserSinglePage> createState() => _UserSinglePageState();
}


class _UserSinglePageState extends State<UserSinglePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future<void> getContact() async {
    try {
      // Fetch document from Firestore
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('contacts')
          .doc(phno)
          .get();

      if (doc.exists) {
        // Document exists, extract data
        var data = doc.data() as Map<String, dynamic>;

        setState(() {
          whatsappNo = data['whatsappNo'] ?? ''; // Default to empty string if null
          instaId = data['instaId'] ?? '';
          facebookId = data['facebookId'] ?? '';
          twitterId = data['twitter'] ?? '';
          website = data['website'] ?? '';
          LinkdnId = data['linkdn'] ?? '';
          emailId = data['email'] ?? '';
        });

        print("Document exists: $data");
      } else {
        // Document does not exist, create a new one with initial data
        await FirebaseFirestore.instance.collection('contacts').doc(phno).set({
          'whatsappNo': phno, // Default value as phone number
          'instaId': instaId ?? '', // Default empty string
          'facebookId': facebookId ?? '',
          'twitter': twitterId ?? '',
          'website': website ?? '',
          'email': emailId ?? '',
          'linkdn': LinkdnId ?? '',
          'createdAt': DateTime.now(), // Add timestamp
        });

        print("New document created for phone number $phno");
      }
    } catch (e) {
      // Handle errors gracefully
      print("Error fetching or creating document: $e");
    }
  }


  TextEditingController _textController = TextEditingController();

  void _showBottomSheet(BuildContext context, String label, int type, String data) {
    _textController.text = data; // Set the existing value before showing the sheet

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to take more space
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: width,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: GoogleFonts.roboto(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  try {
                    // Ensure the input is not empty
                    final newValue = _textController.text.trim();
                    if (newValue.isEmpty) {
                      print("Input cannot be empty");
                      return;
                    }

                    // Update the Firestore document
                    await FirebaseFirestore.instance.collection('contacts').doc(phno).update({
                      if (type == 0) 'whatsappNo': newValue,
                      if (type == 1) 'facebookId': newValue,
                      if (type == 2) 'email': newValue,
                      if (type == 3) 'twitter': newValue,
                      if (type == 4) 'linkdn': newValue,
                      if (type == 5) 'instaId': newValue,
                      if (type == 6) 'website': newValue,
                    });

                    if (mounted) {
                      setState(() {
                        // Optionally, update the local state with the new value
                        if (type == 0) whatsappNo = newValue;
                        if (type == 1) facebookId = newValue;
                        if (type == 2) emailId = newValue;
                        if (type == 3) twitterId = newValue;
                        if (type == 4) LinkdnId = newValue;
                        if (type == 5) instaId = newValue;
                        if (type == 6) website = newValue;
                      });
                    }

                    // Clear the text field
                    _textController.text = "";

                    // Close the bottom sheet
                    Navigator.pop(context);
                  } catch (e) {
                    print("Error updating document: $e");
                  }
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: GoogleFonts.roboto(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  String memberId = '';
  String whatsappNo = '';
  String instaId = '';
  String facebookId = '';
  String LinkdnId = '';
  String website = '';
  String twitterId = '';
  String emailId = '';
  String phno = '';
  String groupId = '';
  // MemberModel? member;
  String member='';

  @override
  void didChangeDependencies() {
    final arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    // groupId = arguments['groupId'].toString();
    // memberId = arguments['memberId'].toString();
     member = arguments['name'];
    phno = arguments['phNumber'];
    super.didChangeDependencies();
    getContact();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0, // Increase for more shadow
        shadowColor: Colors.grey,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: MediaQuery.of(context).size.width * 0.045,
          ),
          onPressed: () {
            Navigator.pop(context); // Goes back to the previous screen
          },
        ),
        title: Text(
          member.toString() ?? 'Loading...',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,

            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: ListView(
          children: [
            // WhatsApp
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.01,
              ),
              leading: Image.asset(ImageConstants.whatsapp,color: Colors.grey,height: 20,width: 20,),
              title: Text(
                whatsappNo==""?phno:whatsappNo,
                style: GoogleFonts.roboto(),
              ),
              subtitle: Text('WhatsApp',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'WhatsApp Number',0,whatsappNo);
                  // Handle edit action
                },
              ),
            ),
            // Facebook
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.01,
              ),
              leading: Icon(Icons.facebook,color: Colors.grey),
              title: Text(
                facebookId==""?'--':facebookId,
                style: GoogleFonts.roboto(),
              ),
              subtitle: Text('Facebook',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Facebook Id',1,facebookId);

                  // Handle edit action
                },
              ),
            ),
            // Email
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.01,
              ),
              leading: Icon(Icons.email,color: Colors.grey),
              title: Text(
                emailId==""?'--':emailId,
                style: GoogleFonts.roboto(),
              ),
              subtitle: Text('Email',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Email Id',2,emailId);

                  // Handle edit action
                },
              ),
            ),
            // Twitter
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.01,
              ),
              leading: Image.asset(ImageConstants.twitter,width: 20,height: 20,color: Colors.grey,),
              title: Text(
                twitterId==""?'--':twitterId,
                style: GoogleFonts.roboto(),
              ),
              subtitle: Text('Twitter',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Twitter',3,twitterId);
                  // Handle edit action
                },
              ),
            ),
            // LinkedIn
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.01,
              ),
              leading: Image.asset(ImageConstants.linkedinIcon,color: Colors.grey,height: 20,width: 20,),
              title: Text(
                LinkdnId==""?'--':LinkdnId,
                style: GoogleFonts.roboto(),
              ),
              subtitle: Text('Linkedin',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Linkedin Id',4,LinkdnId);

                  // Handle edit action
                },
              ),
            ),
            // Instagram
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.01,
              ),
              leading: Image.asset(ImageConstants.instaIcon,color: Colors.grey,height: 20,width: 20,),
              title: Text(
                instaId==""?'--':instaId,
                style: GoogleFonts.roboto(),
              ),
              subtitle: Text('Instagram',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Instagram Id',5,instaId);

                  // Handle edit action
                },
              ),
            ),
            // Website
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.01,
              ),
              leading:Icon(Icons.language,color: Colors.grey),
              title: Text(
                website==""?'--':website,
                style: GoogleFonts.roboto(),
              ),
              subtitle: Text('Website',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Website',6,website);

                  // Handle edit action
                },
              ),
            ),
          ],
        )

      ),
    );
  }

}




