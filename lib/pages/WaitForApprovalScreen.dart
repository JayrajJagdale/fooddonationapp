import 'package:flutter/material.dart';

class WaitForApprovalScreen extends StatelessWidget {
  const WaitForApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer, // Timer icon
                size: 80,
                color: Colors.blue, // Blue icon
              ),
              const SizedBox(height: 20),
              const Text(
                "Your request is pending approval",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black text
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Please wait for the admin to approve your request.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54, // Semi-transparent black text
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the login screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue button
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  "Back to Login",
                  style: TextStyle(
                    color: Colors.white, // White text
                    fontSize: 16,
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