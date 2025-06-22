import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color accentColor = Colors.blue; // Accent color

class MakeDonations extends StatefulWidget {
  const MakeDonations({super.key});

  @override
  State<MakeDonations> createState() => _MakeDonationsState();
}

class _MakeDonationsState extends State<MakeDonations> {
  var expirationTime = TextEditingController();
  var address = TextEditingController();
  var contactNumber = TextEditingController();
  var description = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, TextEditingController>> foodEntries = [
    {'foodName': TextEditingController(), 'servingSize': TextEditingController()}
  ];

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void addNewRow() {
    setState(() {
      foodEntries.add({'foodName': TextEditingController(), 'servingSize': TextEditingController()});
      Future.delayed(Duration(milliseconds: 100), () => FocusScope.of(context).requestFocus(_focusNode));
    });
  }

  void removeRow(int index) {
    setState(() {
      foodEntries.removeAt(index);
    });
  }

  // ✅ Method to Save Donation Data and Increment Count
  Future<void> saveDonationData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      showSnackBar(context, 'User not logged in');
      return;
    }

    if (foodEntries.any((entry) => entry['foodName']!.text.isEmpty || entry['servingSize']!.text.isEmpty) ||
        expirationTime.text.isEmpty ||
        address.text.isEmpty ||
        contactNumber.text.isEmpty ||
        description.text.isEmpty) {
      showSnackBar(context, 'Please fill all fields');
      return;
    }

    List<Map<String, String>> foodList = foodEntries
        .map((entry) => {'foodName': entry['foodName']!.text, 'servingSize': entry['servingSize']!.text})
        .toList();

    try {
      await FirebaseFirestore.instance.collection('donations').add({
        'foodEntries': foodList,
        'expirationTime': expirationTime.text,
        'address': address.text,
        'contactNumber': contactNumber.text,
        'description': description.text,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
        'status': 'pending',
      });

      // ✅ Increment donation count in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'donationCount': FieldValue.increment(1),
      });

      setState(() {
        foodEntries = [{'foodName': TextEditingController(), 'servingSize': TextEditingController()}];
      });
      expirationTime.clear();
      address.clear();
      contactNumber.clear();
      description.clear();

      showSnackBar(context, 'Your Donation is Successful !!!');
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (e) {
      showSnackBar(context, 'Error in saving data: $e');
    }
  }

  // ✅ Added the missing buildTextFormField method
  Widget buildTextFormField({required TextEditingController controller, required String hintText, FocusNode? focusNode}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(color: secondaryColor),
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(color: secondaryColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: accentColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: accentColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text(
          'Fill This Details For Donate',
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.all(15.0),
        color: primaryColor,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: List.generate(foodEntries.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: buildTextFormField(
                                  controller: foodEntries[index]['foodName']!,
                                  hintText: "Food Name",
                                  focusNode: index == foodEntries.length - 1 ? _focusNode : null,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: buildTextFormField(
                                  controller: foodEntries[index]['servingSize']!,
                                  hintText: "Serving Size",
                                ),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                onPressed: addNewRow,
                                icon: Icon(Icons.add, color: accentColor),
                              ),
                              if (foodEntries.length > 1 && index != foodEntries.length - 1)
                                IconButton(
                                  onPressed: () => removeRow(index),
                                  icon: Icon(Icons.remove, color: accentColor),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20),
                    buildTextFormField(controller: expirationTime, hintText: "Enter Expiration Time"),
                    SizedBox(height: 20),
                    buildTextFormField(controller: address, hintText: "Enter Address"),
                    SizedBox(height: 20),
                    buildTextFormField(controller: contactNumber, hintText: "Enter Contact Number"),
                    SizedBox(height: 20),
                    buildTextFormField(controller: description, hintText: "Enter Description"),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: saveDonationData,
                        style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                        child: Text("Donate", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}