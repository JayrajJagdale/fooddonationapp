import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/pages/Donor/HomePage_Donor.dart';
import 'package:food_donation_app/pages/Donor/signup_donor.dart';
import 'package:food_donation_app/services/auth.dart';
import 'package:food_donation_app/widgets/snack_bar.dart';

const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color accentColor = Colors.blue; // Accent color for buttons

class LoginDonor extends StatefulWidget {
  const LoginDonor({super.key});

  @override
  State<LoginDonor> createState() => _LoginDonorState();
}

class _LoginDonorState extends State<LoginDonor> {
  var email = TextEditingController();
  var password = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthServices().loginUser(
      email: email.text,
      password: password.text,
    );

    if (res == "Successful Login") {
      try {
        var user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            String name = userDoc['name'];
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomepageDonor(name: name),
              ),
            );
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
            color: primaryColor, // Set background color to white
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'Poppins',
                          color: secondaryColor, // Set text color to black
                        ),
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        controller: email,
                        style: TextStyle(
                          color: secondaryColor, // Set text color to black
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle: TextStyle(
                            fontFamily: "Poppins",
                            color: secondaryColor, // Set text color to black
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: accentColor, // Set border color to blue
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: accentColor, // Set border color to blue
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: password,
                        obscureText: !isPasswordVisible,
                        style: TextStyle(
                          color: secondaryColor, // Set text color to black
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontFamily: "Poppins",
                            color: secondaryColor, // Set text color to black
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: accentColor, // Set border color to blue
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: accentColor, // Set border color to blue
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: accentColor, // Set icon color to blue
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
                      Text("Forgot Password?",
                          style: TextStyle(color: accentColor)), // Set text color to blue
                      SizedBox(height: 30),
                      Container(
                        height: 55,
                        width: 250,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor, // Set button color to blue
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  primaryColor)) // Set progress indicator color to white
                              : Text(
                            "Log In",
                            style: TextStyle(
                              color: primaryColor, // Set text color to white
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
                      Container(
                        height: 55,
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signupdonor()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor, // Set button color to blue
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: primaryColor, // Set text color to white
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