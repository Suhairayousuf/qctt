import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';

import '../../../core/pallette/pallete.dart';
import '../../../core/utils/utils.dart';
import '../../../models/card_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MaterialApp(
    home: AddCardDetailsPage(),
  ));
}

class AddCardDetailsPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController linkedInController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Add Card Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildTextFormField('Name', nameController),
                buildTextFormField('Phone Number', phoneController),
                buildTextFormField('Designation/Job', designationController),
                buildTextFormField('Website', websiteController),
                buildTextFormField('Email', emailController),
                buildTextFormField('WhatsApp', whatsappController),
                buildTextFormField('Facebook', facebookController),
                buildTextFormField('Twitter', twitterController),
                buildTextFormField('LinkedIn', linkedInController),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (nameController.text.isNotEmpty &&
                            phoneController.text.isNotEmpty &&
                            phoneController.text.length == 10 &&
                            whatsappController.text.isNotEmpty &&
                            whatsappController.text.length == 10 &&
                            emailController.text.isNotEmpty) {
                          // Regex to validate Gmail addresses
                          RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
                          if (emailRegex.hasMatch(emailController.text)) {
                            _showSubmitDialog(context); // All validations passed
                          } else {
                            showSnackBar(context, 'Enter a valid Gmail address');
                          }
                        } else {
                          // Check which field is invalid and show appropriate SnackBar
                          if (nameController.text.isEmpty) {
                            showSnackBar(context, 'Enter card name');
                          } else if (phoneController.text.isEmpty || phoneController.text.length != 10) {
                            showSnackBar(context, 'Enter a valid 10-digit phone number');
                          } else if (emailController.text.isEmpty) {
                            showSnackBar(context, 'Enter email ID');
                          }
                          else if (whatsappController.text.isEmpty || whatsappController.text.length != 10) {
                            showSnackBar(context, 'Enter a valid 10-digit WhatsApp number');
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                  ),


                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        keyboardType:controller== whatsappController?
        TextInputType.number:controller==phoneController?TextInputType.number:TextInputType.text,


        controller: controller,
        decoration: InputDecoration(
          hintStyle:GoogleFonts.inter(color: Colors.blue) ,

          labelText: label,

          // border: OutlineInputBorder(),
        ),
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'Please enter $label';
        //   }
        //   return null;
        // },
      ),
    );
  }

  Future<void> submitToFirebase() async {
    // Create a CardModel instance from the text controllers
    CardModel card = CardModel(
      name: nameController.text ?? "",
      phone: phoneController.text ?? "",
      designation: designationController.text ?? "",
      website: websiteController.text ?? "",
      email: emailController.text ?? "",
      whatsapp: whatsappController.text ?? "",
      facebook: facebookController.text ?? "",
      twitter: twitterController.text ?? "",
      linkedin: linkedInController.text ?? "",
      createdDate: DateTime.now(),
      cardId: '',
      delete: false,
    );

    // Reference to Firestore collection
    final CollectionReference cardsCollection =
    FirebaseFirestore.instance.collection('cards');

    // Add card data to Firestore
    await cardsCollection.add(card.toJson()).then((onValue) {
      // Update the card with its generated Firestore ID
      onValue.update({'cardId': onValue.id});
    });
  }

  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Submission',style: GoogleFonts.inter(color: primaryColor),),
          content: Text('Are you sure you want to submit the details?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: Text('Cancel',style: GoogleFonts.inter(color: Colors.grey),),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog
                await submitToFirebase();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('New card  created',)),

                );
                nameController.clear();
                phoneController.clear();
                designationController.clear();
                websiteController.clear();
                emailController.clear();
                whatsappController.clear();
                twitterController.clear();
                linkedInController.clear();
                Navigator.pop(context);
              },
              child: Text('Submit',style: GoogleFonts.inter(color: primaryColor),),
            ),
          ],
        );
      },
    );
  }
}
