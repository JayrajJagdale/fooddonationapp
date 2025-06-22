import 'package:flutter/material.dart';
import 'package:food_donation_app/pages/Donor/signup_donor.dart';
import 'package:food_donation_app/pages/Donor/login_donor.dart';

const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color accentColor = Colors.blue; // Accent color for buttons and other elements

class choose_one extends StatelessWidget {
  const choose_one({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor, // Set background color to white
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Choose One",
                    style: TextStyle(
                      fontSize: 34,
                      fontFamily: 'Poppins',
                      color: secondaryColor, // Set text color to black
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 55,
                    width: 250,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginDonor()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor, // Set button color to #4c483c
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: primaryColor, // Set text color to white
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Poppins'),
                        )),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Divider(
                        color: secondaryColor, // Set divider color to #4c483c
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
                              backgroundColor: accentColor, // Set button color to #4c483c
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
                                  builder: (context) => Signupdonor()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor, // Set button color to #4c483c
                        ),
                        child: Text(
                          "Signup",
                          style: TextStyle(
                              color: primaryColor, // Set text color to white
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Poppins'),
                        )),
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