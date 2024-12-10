import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/pallette/pallete.dart';
import '../../../core/utils/utils.dart';
import '../../../main.dart';
import '../../Home/screens/routing_page.dart';
import '../../Home/screens/splash_screen.dart';

class EditUserDetails extends StatefulWidget {
  @override
  _EditUserDetailsState createState() => _EditUserDetailsState();
}

class _EditUserDetailsState extends State<EditUserDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dataController = TextEditingController();
  String label = "User Data"; // Example label, replace with actual dynamic label if needed

  @override
  void initState() {
    super.initState();

    // Initialize the controller with existing data
    dataController.text = "Sample Data"; // Replace with actual user data
  }

  @override
  void dispose() {
    // Dispose controller to free resources
    dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    String label = arguments['label'].toString();
    dataController.text = arguments['data'].toString();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,size: width*0.045,),
          onPressed: () {
            Navigator.pop(context); // Goes back to the previous screen
          },
        ),
        title: Text("Edit User Details",style: GoogleFonts.inter(fontSize: width*0.045),),
      ),
      body: Padding(
        padding:  EdgeInsets.all(width*0.03),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: width*0.07),

              TextFormField(
                controller: dataController, // Use the controller for input
                decoration: InputDecoration(
                  labelText: label,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the data";
                  }
                  return null;
                },
              ),
              SizedBox(height: width*0.07),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor:primaryColor, // Text color
                  padding: EdgeInsets.symmetric(horizontal: width*0.035, vertical: width*0.035),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),

                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool? confirmed = await EditUserDataPopup.show(
                      context: context,
                      title: "Save changes",
                      content: "Are you sure you want to Change?",
                      primaryColor:primaryColor, // Use app's primary color
                    );

                    if (confirmed == true) {
                      // Perform the delete action
                      setState(() {
                        // items.removeAt(index); // Example: remove the item from the list
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Details updated successfully!")),
                    );
                    Navigator.pop(context);

                    // Access the updated value
                    print("Updated Data: ${dataController.text}");
                  }
                },
                child: Text("Save Changes",style: GoogleFonts.inter(),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
