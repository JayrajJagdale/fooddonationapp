import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donation_app/pages/Ngo/HomePage_NGO.dart';
import 'login_ngo.dart';
import '../../services/auth1.dart';
import 'package:food_donation_app/pages/WaitForApprovalScreen.dart  ';

const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color buttonColor = Colors.blue; // Button color (changed to blue)

class Signupngo extends StatefulWidget {
  const Signupngo({super.key});

  @override
  State<Signupngo> createState() => _SignupngoState();
}

class _SignupngoState extends State<Signupngo> {
  bool isLoading = false;
  bool isPassword = true;

  final TextEditingController fullname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController address = TextEditingController();

  Widget buildTextField({
    required String labelText,
    bool isMultiline = false,
    bool isPasswordField = false,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: isMultiline ? null : 1,
      obscureText: isPasswordField ? isPassword : false,
      style: const TextStyle(
        color: secondaryColor,
        fontFamily: 'Poppins',
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontFamily: "Poppins",
          color: secondaryColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: buttonColor, // Blue border
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: buttonColor, // Blue border
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: isPasswordField
            ? IconButton(
          icon: Icon(
            isPassword ? Icons.visibility_off : Icons.visibility,
            color: buttonColor, // Blue icon
          ),
          onPressed: () {
            setState(() {
              isPassword = !isPassword;
            });
          },
        )
            : null,
      ),
    );
  }

  void signUpNgo() async {
    if (mobile.text.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(mobile.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 10-digit phone number")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String res = await AuthNgoServices().signUpNgo(
      email: email.text,
      password: password.text,
      name: fullname.text,
      mobile: mobile.text,
      address: address.text,

    );

    if (res == "Successfully Signed Up") {
      FirebaseFirestore.instance.collection('ngos').doc(email.text).set({
        'name': fullname.text,
        'email': email.text,
        'mobile': mobile.text,
        'address': address.text,
        'approved': false, // Set approved to false
      });

      if (mounted) {
        setState(() {
          isLoading = false;
        });
        // Navigate to the "Wait for approval" screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WaitForApprovalScreen()),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // White background
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center align all children
              children: [
                const SizedBox(height: 20), // Add spacing at the top
                const Text(
                  "NGO Sign up",
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: secondaryColor, // Black text
                  ),
                ),
                const SizedBox(height: 20), // Add spacing
                buildTextField(
                  labelText: "Name of the NGO",
                  controller: fullname,
                ),
                const SizedBox(height: 15), // Add spacing
                buildTextField(
                  labelText: "Phone Number",
                  controller: mobile,
                ),
                const SizedBox(height: 15), // Add spacing
                buildTextField(
                  labelText: "Email",
                  controller: email,
                ),
                const SizedBox(height: 15), // Add spacing
                buildTextField(
                  labelText: "Password",
                  controller: password,
                  isPasswordField: true,
                ),
                const SizedBox(height: 15), // Add spacing
                buildTextField(
                  labelText: "Address of NGO",
                  controller: address,
                  isMultiline: true,
                ),
                const SizedBox(height: 30), // Add spacing
                Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                    height: 55,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: signUpNgo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor, // Blue button
                      ),
                      child: const Text(
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
                ),
                const SizedBox(height: 20), // Add spacing
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Divider(
                      color: secondaryColor, // Black divider
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
                          backgroundColor: buttonColor, // Blue button
                        ),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: primaryColor, // White text
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Add spacing
                SizedBox(
                  height: 55,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginNgo()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor, // Blue button
                    ),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: primaryColor, // White text
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Add spacing at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}