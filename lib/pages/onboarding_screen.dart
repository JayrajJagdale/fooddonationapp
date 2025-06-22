import 'package:flutter/material.dart';
import 'package:food_donation_app/pages/welcome_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const Color primaryColor = Color(0xFF4c483c); // Replaced white with #4c483c
const Color secondaryColor = Colors.black; // Text and icon color
const Color buttonColor = Colors.yellow; // Accent color for buttons

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          children: [
            Screens(
              title1: "Food",
              title2: "Donation",
              subtitle1Part1: "Alone",
              subtitle1Part2: "we can do so little",
              subtitle2Part1: "together",
              subtitle2Part2: "we can do so much...",
              imagePath: "assets/images/img1.jpg",
            ),
            Screens(
              title1: "Give",
              title2: "Love",
              subtitle1Part1: "Every",
              subtitle1Part2: "meal counts for",
              subtitle2Part1: "someone",
              subtitle2Part2: "in need...",
              imagePath: "assets/images/img2.jpg",
            ),
            Screens(
              title1: "Join",
              title2: "Mission",
              subtitle1Part1: "Your",
              subtitle1Part2: "donation can fill",
              subtitle2Part1: "Someone's",
              subtitle2Part2: "plate...",
              imagePath: "assets/images/img3.jpg",
              isLastPage: true,
              onButtonPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Welcome()));
              },
            )
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        height: 80,
        color: primaryColor, // Set background color to white
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => controller.jumpToPage(2),
              child: Text(
                'SKIP',
                style: TextStyle(color: secondaryColor), // Set text color to black
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  spacing: 16,
                  dotColor: buttonColor.withOpacity(0.5), // Set inactive dot color to lighter blue
                  activeDotColor: buttonColor, // Set active dot color to blue
                ),
                onDotClicked: (index) => controller.animateToPage(index,
                    duration: Duration(microseconds: 500),
                    curve: Curves.easeInOut),
              ),
            ),
            TextButton(
              onPressed: () => controller.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut),
              child: Text(
                'NEXT',
                style: TextStyle(color: secondaryColor), // Set text color to black
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Screens extends StatelessWidget {
  final String? title1;
  final String? title2;
  final String? subtitle1Part1;
  final String? subtitle1Part2;
  final String? subtitle2Part1;
  final String? subtitle2Part2;
  final String? imagePath;
  final bool isLastPage;
  final VoidCallback? onButtonPressed;

  const Screens({
    super.key,
    this.title1,
    this.title2,
    this.subtitle1Part1,
    this.subtitle1Part2,
    this.subtitle2Part1,
    this.subtitle2Part2,
    this.imagePath,
    this.isLastPage = false,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: imagePath != null
                  ? DecorationImage(
                image: AssetImage(imagePath!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.7), // Overlay for better text visibility
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title1 ?? "",
                        style: const TextStyle(
                          fontSize: 36,
                          fontFamily: 'Poppins',
                          color: Colors.white, // Set text color to white
                          letterSpacing: 6,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        title2 ?? "",
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'Poppins',
                          color: buttonColor, // Set text color to blue
                          letterSpacing: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      subtitle1Part1 ?? "",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Oswald',
                        color: buttonColor, // Set text color to blue
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      subtitle1Part2 ?? "",
                      style: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'Oswald',
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      subtitle2Part1 ?? "",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Oswald',
                        color: buttonColor, // Set text color to blue
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      subtitle2Part2 ?? "",
                      style: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'Oswald',
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isLastPage)
                  ElevatedButton(
                    onPressed: onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor, // Set button color to blue
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(
                      "Get Started",
                      style: TextStyle(color: secondaryColor), // Set text color to white
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}