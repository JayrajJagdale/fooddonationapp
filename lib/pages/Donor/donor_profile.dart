import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color accentColor = Colors.blue; // Accent color for buttons and highlights

class DonorProfile extends StatefulWidget {
  @override
  _DonorProfileState createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {
  bool isEditing = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDonorDetails();
  }

  void fetchDonorDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Use UID instead of email for document ID
            .get();

        if (doc.exists) {
          setState(() {
            nameController.text = doc['name'] ?? '';
            emailController.text = doc['email'] ?? '';
            phoneController.text = doc['phone'] ?? '';
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch profile: $e")),
        );
      }
    }
  }

  void updateDonorDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Use UID instead of email for document ID
            .set({
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text, // Ensure email is also updated if needed
        }, SetOptions(merge: true)); // Merge existing data without overwriting other fields

        setState(() {
          isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // Set background color to white
      appBar: AppBar(
        title: Text("Donor Profile", style: TextStyle(fontWeight: FontWeight.bold, color: secondaryColor)), // Set text color to black
        centerTitle: true,
        backgroundColor: primaryColor, // Set app bar background color to white
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300], // Light grey background
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.grey[600], // Dark grey icon color
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: primaryColor, // Set card background color to white
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isEditing) ...[
                      buildTextField("Full Name", nameController),
                      buildTextField("Phone", phoneController),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: updateDonorDetails,
                        child: Text("Save", style: TextStyle(fontSize: 16, color: primaryColor)), // Set text color to white
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor, // Set button color to blue
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                      ),
                    ] else ...[
                      buildProfileInfo("Full Name", nameController.text),
                      buildProfileInfo("Email", emailController.text),
                      buildProfileInfo("Phone", phoneController.text),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => isEditing = true);
                        },
                        child: Text("Edit", style: TextStyle(fontSize: 16, color: primaryColor)), // Set text color to white
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor, // Set button color to blue
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: secondaryColor), // Set label text color to black
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: accentColor), // Set border color to blue
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: accentColor), // Set focused border color to blue
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        style: TextStyle(color: secondaryColor), // Set text color to black
      ),
    );
  }

  Widget buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: secondaryColor)), // Set text color to black
          Text(value, style: TextStyle(fontSize: 16, color: secondaryColor)), // Set text color to black
        ],
      ),
    );
  }
}