import 'package:flutter/material.dart';
import 'package:food_donation_app/pages/Ngo/SignupNgo.dart';
import 'package:food_donation_app/pages/Ngo/login_ngo.dart';

const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color accentColor = Colors.blue; // Accent color

class choose_two extends StatelessWidget {
  const choose_two({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: primaryColor,
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
                    color: secondaryColor, // Use buttonColor for the text
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
                        MaterialPageRoute(builder: (context) => LoginNgo()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor, // Button color is now blue
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: primaryColor, // White text
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
                      color: secondaryColor,
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
                          backgroundColor: accentColor, // Button color is now blue
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
                const SizedBox(height: 20),
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
                      backgroundColor: accentColor, // Button color is now blue
                    ),
                    child: Text(
                      "Signup",
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
    );
  }
}