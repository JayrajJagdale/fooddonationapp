import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/widgets/snack_bar.dart';
import 'ngo_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color accentColor = Colors.blue; // Accent color

class HomepageNgo extends StatefulWidget {
  final String ngoName;

  const HomepageNgo({required this.ngoName, Key? key}) : super(key: key);

  @override
  State<HomepageNgo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomepageNgo> {
  int _bottomNavIndex = 0;
  final List<Widget> _pages = [
    const Page1(),
    Page2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor, // White background
        title: Text(
          'Welcome, ${widget.ngoName}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: secondaryColor, // Black text
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: secondaryColor, size: 28), // Black profile icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NgoProfile()), // Navigate to profile page
              );
            },
          ),
        ],
      ),
      body: _pages[_bottomNavIndex],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
          Icons.history,
        ],
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        backgroundColor: primaryColor, // White background
        activeColor: secondaryColor, // Blue active icon
        inactiveColor: secondaryColor.withOpacity(0.5), // Black inactive icon
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final _donationRef = FirebaseFirestore.instance.collection('donations');

  void updateDonationStatus(String donationId, String status) async {
    User? ngoUser = FirebaseAuth.instance.currentUser;
    if (ngoUser == null) {
      showSnackBar(context, "NGO not logged in");
      return;
    }
    DocumentSnapshot ngoSnapshot = await FirebaseFirestore.instance
        .collection('NgoUsers')
        .doc(ngoUser.uid)
        .get();

    String ngoName = ngoSnapshot.exists ? ngoSnapshot['name'] ?? "Unknown NGO" : "Unknown NGO";

    await _donationRef.doc(donationId).update({
      'status': status,
      'acceptedBy': status == 'accepted' ? ngoName : null,
      'acceptedByEmail': status == 'accepted' ? ngoUser.email ?? "Unknown Email" : null,
      'acceptedTime': status == 'accepted' ? FieldValue.serverTimestamp() : null,
    });
  }

  Stream<QuerySnapshot> getDonationsStream() {
    return _donationRef.where('status', isEqualTo: 'pending').orderBy('expirationTime', descending: false).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // White background
      body: StreamBuilder<QuerySnapshot>(
        stream: getDonationsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: accentColor)); // Blue loading indicator
          }
          final donations = snapshot.data!.docs;
          if (donations.isEmpty) {
            return Center(
              child: Text(
                "No pending donations available.",
                style: TextStyle(color: secondaryColor), // Black text
              ),
            );
          }
          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];
              final donationId = donation.id;
              final data = donation.data() as Map<String, dynamic>? ?? {};

              List<String> foodItems = [];
              if (data.containsKey('foodEntries') && data['foodEntries'] is List) {
                for (var entry in (data['foodEntries'] as List)) {
                  if (entry is Map<String, dynamic>) {
                    String foodName = entry['foodName'] ?? 'Unknown';
                    String servingSize = entry['servingSize'] ?? 'Unknown';
                    foodItems.add("$foodName ($servingSize)");
                  }
                }
              }
              String foodText = foodItems.isNotEmpty ? foodItems.join(', ') : 'Not Available';

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4,
                color: primaryColor, // White background
                child: ListTile(
                  title: Text(
                    foodText,
                    style: TextStyle(color: secondaryColor), // Black text
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Address: ${data['address'] ?? 'Unknown'}",
                        style: TextStyle(color: secondaryColor), // Black text
                      ),
                      Text(
                        "Contact: ${data['contactNumber'] ?? 'Unknown'}",
                        style: TextStyle(color: secondaryColor), // Black text
                      ),
                      Text(
                        "Expires: ${data['expirationTime'] ?? 'Unknown'}",
                        style: TextStyle(color: secondaryColor), // Black text
                      ),
                      Text(
                        "Description: ${data['description'] ?? 'No description'}",
                        style: TextStyle(color: secondaryColor), // Black text
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => updateDonationStatus(donationId, 'accepted'),
                        icon: Icon(Icons.check_circle, color: Colors.green), // Blue icon
                      ),
                      IconButton(
                        onPressed: () => updateDonationStatus(donationId, 'rejected'),
                        icon: Icon(Icons.cancel, color: Colors.red), // Black icon
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  final CollectionReference _donationRef = FirebaseFirestore.instance.collection('donations');

  Page2({super.key});

  // Function to show feedback dialog
  void _showFeedbackDialog(BuildContext context, String donationId) {
    TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Provide Feedback"),
          content: TextFormField(
            controller: feedbackController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Enter your feedback about the food...",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (feedbackController.text.isNotEmpty) {
                  // Save feedback to Firestore
                  await _donationRef.doc(donationId).update({
                    'feedback': feedbackController.text,
                    'feedbackTimestamp': FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter feedback")),
                  );
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Center(
        child: Text(
          "NGO not logged in",
          style: TextStyle(color: secondaryColor), // Black text
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryColor, // White background
      body: StreamBuilder<QuerySnapshot>(
        stream: _donationRef
            .where('status', isEqualTo: 'accepted')
            .where('acceptedByEmail', isEqualTo: currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: accentColor), // Blue loading indicator
            );
          }
          final donations = snapshot.data!.docs;
          if (donations.isEmpty) {
            return Center(
              child: Text(
                'No Donations Accepted Yet !!!',
                style: TextStyle(color: secondaryColor), // Black text
              ),
            );
          }
          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];
              final data = donation.data() as Map<String, dynamic>? ?? {};

              List<String> foodItems = [];
              if (data.containsKey('foodEntries') && data['foodEntries'] is List) {
                for (var entry in (data['foodEntries'] as List)) {
                  if (entry is Map<String, dynamic>) {
                    String foodName = entry['foodName'] ?? 'Unknown';
                    String servingSize = entry['servingSize'] ?? 'Unknown';
                    foodItems.add("$foodName ($servingSize)");
                  }
                }
              }
              String foodText = foodItems.isNotEmpty ? foodItems.join(', ') : 'Not Available';

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4,
                color: primaryColor, // White background
                child: ListTile(
                  title: Text(
                    foodText,
                    style: TextStyle(color: secondaryColor), // Black text
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Accepted Donations",
                        style: TextStyle(color: secondaryColor), // Black text
                      ),
                      Text(
                        "Address: ${data['address'] ?? 'Unknown'}",
                        style: TextStyle(color: secondaryColor), // Black text
                      ),
                      Text(
                        "Contact: ${data['contactNumber'] ?? 'Unknown'}",
                        style: TextStyle(color: secondaryColor), // Black text
                      ),
                      Text(
                        "Expires: ${data['expirationTime'] ?? 'Unknown'}",
                        style: TextStyle(color: secondaryColor), // Black text
                      ),
                      Text(
                        "Description: ${data['description'] ?? 'No description'}",
                        style: TextStyle(color: secondaryColor), // Black text
                      ),
                      if (data['feedback'] != null) // Display feedback if available
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              "Feedback: ${data['feedback']}",
                              style: TextStyle(
                                color: Colors.green, // Green text for feedback
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Feedback Date: ${data['feedbackTimestamp'] != null ? DateTime.fromMillisecondsSinceEpoch(data['feedbackTimestamp'].millisecondsSinceEpoch).toLocal().toString().split(' ')[0] : 'Unknown'}",
                              style: TextStyle(
                                color: Colors.grey, // Grey text for feedback date
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                        onPressed: () {
                          final phone = data['contactNumber'] ?? '';
                          final msg = "Hello, we accepted your donation request.";
                          final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(msg)}';
                          launchUrl(Uri.parse(url));
                        },
                      ),
                      if (data['feedback'] == null)
                        IconButton(
                          icon: Icon(Icons.feedback, color: accentColor),
                          onPressed: () => _showFeedbackDialog(context, donation.id),
                        ),
                    ],
                  ),
                  // Hide feedback button if feedback is already provided
                ),
              );
            },
          );
        },
      ),
    );
  }
}