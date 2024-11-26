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
  TextEditingController _textController = TextEditingController();

  void _showBottomSheet(BuildContext context,String label) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to take more space
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: width*1, // 50% of the screen height
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   'Edit Details',
              //   style: TextStyle(
              //     fontSize: 18,
              //     // fontWeight: FontWeight.bold,
              //   ),
              // ),
              SizedBox(height: 10),
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: GoogleFonts.roboto(color: Colors.grey)
                  // border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,

                  ),
                  // onPressed: () {
                  //   // Handle the submission of the new value
                  //   // String newValue = _textController.text;
                  //   // print('New Value: $newValue'); // Replace this with your logic
                  //   Navigator.pop(context); // Close the bottom sheet
                  // },
                  child: Center(child: Text('Submit',style: GoogleFonts.roboto(
                    color: Colors.white
                  ),)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  String memberId = '';
  String groupId = '';
  MemberModel? member;

  @override
  void didChangeDependencies() {
    final arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    groupId = arguments['groupId'].toString();
    memberId = arguments['memberId'].toString();
    member = arguments['memberModel'];
    super.didChangeDependencies();
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
          member?.memberName ?? 'Loading...',
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
                '090909090',
                style: GoogleFonts.roboto(),
              ),
              subtitle: Text('WhatsApp',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'WhatsApp Number');
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
                'facebook.com/johndoe',
                style: GoogleFonts.roboto(),
              ),
              subtitle: Text('Facebook',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Facebook Id');

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
                'john.doe@example.com',
                  style: GoogleFonts.roboto(),
              ),
              subtitle: Text('Email',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Email Id');

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
                '@johndoe',
                style: GoogleFonts.roboto(),              ),
              subtitle: Text('Twitter',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Twitter');
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
                'linkedin.com/in/johndoe',
                style: GoogleFonts.roboto(),              ),
              subtitle: Text('Linkedin',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Linkedin Id');

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
                'instagram.com/johndoe',
                style: GoogleFonts.roboto(),              ),
              subtitle: Text('Instagram',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Instagram Id');

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
                'www.johndoe.com',
                style: GoogleFonts.roboto(),              ),
              subtitle: Text('Website',style: GoogleFonts.roboto(color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showBottomSheet(context,'Website');

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




