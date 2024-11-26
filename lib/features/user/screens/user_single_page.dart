import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Home/screens/splash_screen.dart';



class UserSinglePage extends StatelessWidget {
  // Sample user details
  final List<Map<String, String>> userDetails = [
    {'label': 'Name', 'value': 'John Doe'},
    {'label': 'Phone', 'value': '+123 456 7890'},
    {'label': 'WhatsApp', 'value': '+123 456 7890'},
    {'label': 'Facebook', 'value': 'facebook.com/johndoe'},
    {'label': 'Instagram', 'value': 'instagram.com/johndoe'},
    {'label': 'Website', 'value': 'www.johndoe.com'},
    {'label': 'Email', 'value': 'john.doe@example.com'},
    {'label': 'LinkedIn', 'value': 'linkedin.com/in/johndoe'},
  ];

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final  String name = arguments['name'].toString();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,size: width*0.045,),
          onPressed: () {
            Navigator.pop(context); // Goes back to the previous screen
          },
        ),
        title: Text(name,style: GoogleFonts.inter(fontSize: width*0.045),),
      ),
      body: Padding(
        padding:  EdgeInsets.all(width*0.04),
        child: ListView.builder(
          itemCount: userDetails.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: width*0.01),
              title: Text(
                userDetails[index]['label'] ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(userDetails[index]['value'] ?? ''),
              trailing: IconButton(
                icon: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/EditUserDetails',
                      arguments: {

                        'label': userDetails[index]['label'],
                        'data': userDetails[index]['value'],
                        // 'members': index,
                      },
                    );
                  },
                    child: Icon(Icons.edit, color: Colors.blue)),
                onPressed: () {
                  // Handle edit action here
                  print('Edit ${userDetails[index]['label']}');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
