import 'package:flutter/material.dart';
import 'package:food_donation_app/pages/Donor/HomePage_Donor.dart';
import 'package:food_donation_app/pages/Donor/login_donor.dart';
import 'package:food_donation_app/services/auth.dart';
import 'package:food_donation_app/widgets/snack_bar.dart';

const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color accentColor = Colors.blue; // Accent color for buttons
const Color buttonColor = Colors.blue; // Button color

class Signupdonor extends StatefulWidget {
  const Signupdonor({super.key});

  @override
  State<Signupdonor> createState() => _SignupdonorState();
}

class _SignupdonorState extends State<Signupdonor> {
  var fullname = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var phoneNumber = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    fullname.dispose();
    email.dispose();
    password.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  void signUPUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthServices().signUPUser(
      email: email.text,
      password: password.text,
      name: fullname.text,
      phone: phoneNumber.text,
    );

    if (res == "Successfully SignUp") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomepageDonor(name: fullname.text)),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: secondaryColor,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w800,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: "Poppins",
          color: secondaryColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: accentColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: accentColor,
          ),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: suffixIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor, // Set background color to white
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: 'Poppins',
                      color: secondaryColor, // Set text color to black
                    ),
                  ),
                  const SizedBox(height: 40),
                  buildTextField(
                    controller: fullname,
                    labelText: "Full Name",
                  ),
                  const SizedBox(height: 30),
                  buildTextField(
                    controller: email,
                    labelText: "Email address",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),
                  buildTextField(
                    controller: phoneNumber,
                    labelText: "Phone Number",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 30),
                  buildTextField(
                    controller: password,
                    labelText: "Password",
                    obscureText: !isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: secondaryColor, // Set icon color to black
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Forgot Password?",
                    style: TextStyle(color: accentColor), // Set text color to blue
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 55,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : signUPUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor, // Set button color to blue
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                        color: primaryColor, // Set progress indicator color to white
                      )
                          : const Text(
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 55,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginDonor()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor, // Set button color to blue
                      ),
                      child: const Text(
                        "Login",
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
    );
  }
}