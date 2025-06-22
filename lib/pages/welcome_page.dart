import 'package:flutter/material.dart';
import 'package:food_donation_app/pages/Donor/choose_one_donor.dart';
import 'package:food_donation_app/pages/Ngo/choose_two_ngo.dart';

const Color primaryColor = Colors.white;
// Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color buttonColor = Colors.blue; // Accent color for buttons

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: primaryColor, // Set background color to white
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to ShareBites",
                style: TextStyle(
                  fontSize: 34,
                  fontFamily: 'Poppins',
                  color: secondaryColor, // Set text color to black
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Text(
                "How would you like to proceed?",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Oswald',
                  color: secondaryColor, // Set text color to black
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 55,
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => choose_two(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor, // Set button color to blue
                  ),
                  child: Text(
                    "Continue As NGO",
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
                    color: secondaryColor, // Set divider color to black
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
                        backgroundColor: buttonColor, // Set button color to blue
                      ),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: primaryColor, // Set text color to white
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
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
                      MaterialPageRoute(
                        builder: (context) => choose_one(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor, // Set button color to blue
                  ),
                  child: Text(
                    "Continue As Donor",
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
    );
  }
}