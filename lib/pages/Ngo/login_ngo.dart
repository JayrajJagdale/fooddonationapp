import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/pages/Ngo/HomePage_NGO.dart';
import 'package:food_donation_app/pages/Ngo/SignupNgo.dart';
import 'package:food_donation_app/services/auth1.dart';
import 'package:food_donation_app/pages/WaitForApprovalScreen.dart';
import '../../widgets/snack_bar.dart';
import '../Admin/Admin.dart';

const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color accentColor = Colors.blue; // Accent color
const Color buttonColor = Colors.blue; // Button color (changed to blue)

class LoginNgo extends StatefulWidget {
  const LoginNgo({super.key});

  @override
  State<LoginNgo> createState() => _LoginNgoState();
}

class _LoginNgoState extends State<LoginNgo> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "sharebites09@gmail.com" && password == "ShareBites09") {
      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Admin()),
      );
      return;
    }

    String res = await AuthNgoServices().loginNgo(email: email, password: password);

    if (res == "Successful Login") {
      try {
        var user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('ngos') // Ensure this matches your collection name
              .doc(user.email) // Use email as the document ID
              .get();

          if (userDoc.exists) {
            bool isApproved = userDoc['approved'] ?? false; // Check if approved
            if (isApproved) {
              String name = userDoc['name'];
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomepageNgo(ngoName: name)),
              );
            } else {
              // NGO is not approved yet
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WaitForApprovalScreen()),
              );
            }
          } else {
            showSnackBar(context, "User data not found");
          }
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, "Error: $e");
      }
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor, // White background
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: secondaryColor, // Blue text
                        ),
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        controller: emailController,
                        style: TextStyle(
                          color: secondaryColor, // Black text
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle: TextStyle(
                            fontFamily: "Poppins",
                            color: secondaryColor, // Black text
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: accentColor, // Blue border
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: accentColor, // Blue border
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        style: TextStyle(
                          color: secondaryColor, // Black text
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontFamily: "Poppins",
                            color: secondaryColor, // Black text
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: accentColor, // Blue border
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: accentColor, // Blue border
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: accentColor, // Blue icon
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: accentColor, // Blue text
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        height: 55,
                        width: 250,
                        child: ElevatedButton(
                          onPressed: loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor, // Blue button
                          ),
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: primaryColor, // White text
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Divider(
                            color: secondaryColor, // Set divider color to blue
                            thickness: 1.0,
                            indent: 20,
                            endIndent: 20,
                            height: 50,
                          ),
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor, // Set button color to blue
                                ),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                      color: primaryColor, // Set text color to white
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 55,
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signupngo()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor, // Blue button
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: primaryColor, // White text
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}