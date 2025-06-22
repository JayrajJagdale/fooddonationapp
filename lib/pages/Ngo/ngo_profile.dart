import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color accentColor = Colors.blue; // Accent color

class NgoProfile extends StatefulWidget {
  @override
  _NgoProfileState createState() => _NgoProfileState();
}

class _NgoProfileState extends State<NgoProfile> {
  bool isEditing = false;
  late Future<DocumentSnapshot?> futureNgoData;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureNgoData = fetchNgoDetails();
  }

  Future<DocumentSnapshot?> fetchNgoDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('ngos').doc(user.email).get();
      if (doc.exists) {
        nameController.text = doc['name'] ?? '';
        emailController.text = doc['email'] ?? '';
        phoneController.text = doc['mobile'] ?? '';
        addressController.text = doc['address'] ?? '';
        return doc;
      }
    }
    return null;
  }

  void updateNgoDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('ngos').doc(user.email).update({
          'name': nameController.text,
          'mobile': phoneController.text,
          'address': addressController.text,
        });

        setState(() {
          isEditing = false;
          futureNgoData = fetchNgoDetails(); // Refresh updated data
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "NGO Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: secondaryColor, // Black text
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor, // White background
      ),
      body: FutureBuilder<DocumentSnapshot?>(
        future: futureNgoData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: accentColor), // Blue loading indicator
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                "No data found.",
                style: TextStyle(color: secondaryColor), // Black text
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.apartment, size: 50, color: Colors.grey.shade600),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: primaryColor, // White background
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isEditing) ...[
                          buildTextField("NGO Name", nameController),
                          buildTextField("Phone", phoneController),
                          buildTextField("Address", addressController),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: updateNgoDetails,
                            child: Text(
                              "Save",
                              style: TextStyle(fontSize: 16, color: primaryColor), // White text
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor, // Blue button
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            ),
                          ),
                        ] else ...[
                          buildProfileInfo("NGO Name", nameController.text),
                          buildProfileInfo("Email", emailController.text),
                          buildProfileInfo("Phone", phoneController.text),
                          buildProfileInfo("Address", addressController.text),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() => isEditing = true);
                            },
                            child: Text(
                              "Edit",
                              style: TextStyle(fontSize: 16, color: primaryColor), // White text
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor, // Blue button
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
          );
        },
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: secondaryColor), // Black text
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: secondaryColor), // Black text
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: accentColor), // Blue border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: accentColor), // Blue border
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  Widget buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: secondaryColor), // Black text
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: secondaryColor), // Black text
          ),
        ],
      ),
    );
  }
}