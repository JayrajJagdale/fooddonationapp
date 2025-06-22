import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donation_app/pages/welcome_page.dart';

const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color accentColor = Colors.blue; // Accent color

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentIndex = 0; // Index for bottom navigation bar

  // Bottom navigation bar tabs
  final List<Widget> _tabs = [
    RequestsTab(), // Requests Tab
    FeedbackTab(), // Feedback Tab
    DonorsTab(), // Donors Tab
    NGOsTab(), // NGOs Tab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor, // White background
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: secondaryColor), // Black icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Welcome()),
              );
            },
          ),
        ],
        title: const Text(
          'Admin',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: secondaryColor, // Black text
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _tabs[_currentIndex], // Display the selected tab
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: secondaryColor,
        unselectedItemColor: secondaryColor.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Donors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'NGOs',
          ),
        ],
      ),
    );
  }
}

// Requests Tab: Displays pending NGO requests
class RequestsTab extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void approveNgo(String ngoId) {
    _firestore.collection('ngos').doc(ngoId).update({
      'approved': true,
    });
  }

  void declineNgo(String ngoId) {
    _firestore.collection('ngos').doc(ngoId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('ngos').where('approved', isEqualTo: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: accentColor), // Blue loading indicator
          );
        }

        var ngos = snapshot.data!.docs;
        if (ngos.isEmpty) {
          return const Center(
            child: Text(
              "No pending NGO requests",
              style: TextStyle(color: secondaryColor), // Black text
            ),
          );
        }

        return ListView.builder(
          itemCount: ngos.length,
          itemBuilder: (context, index) {
            var ngo = ngos[index];
            var ngoData = ngo.data() as Map<String, dynamic>;

            return Card(
              color: primaryColor, // White background
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListTile(
                title: Text(
                  ngoData['name'],
                  style: const TextStyle(color: secondaryColor), // Black text
                ),
                subtitle: Text(
                  ngoData['email'],
                  style: TextStyle(color: secondaryColor.withOpacity(0.6)), // Semi-transparent black text
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green), // Green icon
                      onPressed: () => approveNgo(ngo.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red), // Red icon
                      onPressed: () => declineNgo(ngo.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Feedback Tab: Displays feedback provided by NGOs
// Feedback Tab: Displays feedback provided by NGOs along with donor details
class FeedbackTab extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('donations').where('feedback', isNotEqualTo: null).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: accentColor), // Blue loading indicator
          );
        }

        var donations = snapshot.data!.docs;
        if (donations.isEmpty) {
          return const Center(
            child: Text(
              "No feedback available",
              style: TextStyle(color: secondaryColor), // Black text
            ),
          );
        }

        return ListView.builder(
          itemCount: donations.length,
          itemBuilder: (context, index) {
            var donation = donations[index];
            var donationData = donation.data() as Map<String, dynamic>;

            // Handle null feedback
            String feedback = donationData['feedback'] ?? 'No feedback provided';
            String acceptedBy = donationData['acceptedBy'] ?? 'Unknown NGO';
            String donorId = donationData['userId'] ?? '';

            return FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('users').doc(donorId).get(),
              builder: (context, donorSnapshot) {
                if (!donorSnapshot.hasData) {
                  return const ListTile(
                    title: Text("Loading donor details..."),
                  );
                }

                var donorData = donorSnapshot.data!.data() as Map<String, dynamic>? ?? {};
                String donorName = donorData['name'] ?? 'Unknown Donor';
                String donorEmail = donorData['email'] ?? 'N/A';

                return Card(
                  color: primaryColor, // White background
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ExpansionTile(
                    title: Text(
                      "Feedback by $acceptedBy",
                      style: const TextStyle(color: secondaryColor), // Black text
                    ),
                    subtitle: Text(
                      "To: $donorName",
                      style: TextStyle(color: secondaryColor.withOpacity(0.6)), // Semi-transparent black text
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Feedback: $feedback",
                              style: const TextStyle(color: secondaryColor), // Black text
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Donor Details:",
                              style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Name: $donorName",
                              style: const TextStyle(color: secondaryColor), // Black text
                            ),
                            Text(
                              "Email: $donorEmail",
                              style: const TextStyle(color: secondaryColor), // Black text
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// Donors Tab: Displays a list of donors and top donations
class DonorsTab extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to clear donation count for a donor
  void clearDonationCount(String donorId) {
    _firestore.collection('users').doc(donorId).update({
      'donationCount': 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: accentColor), // Blue loading indicator
          );
        }

        var donors = snapshot.data!.docs;
        if (donors.isEmpty) {
          return const Center(
            child: Text(
              "No donors found",
              style: TextStyle(color: secondaryColor), // Black text
            ),
          );
        }

        return ListView.builder(
          itemCount: donors.length,
          itemBuilder: (context, index) {
            var donor = donors[index];
            var donorData = donor.data() as Map<String, dynamic>;

            return Card(
              color: primaryColor, // White background
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ExpansionTile(
                title: Text(
                  donorData['name'],
                  style: const TextStyle(color: secondaryColor), // Black text
                ),
                subtitle: Text(
                  "Donations: ${donorData['donationCount'] ?? 0}",
                  style: TextStyle(color: secondaryColor.withOpacity(0.6)), // Semi-transparent black text
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email: ${donorData['email'] ?? 'N/A'}",
                          style: const TextStyle(color: secondaryColor), // Black text
                        ),
                        Text(
                          "Phone: ${donorData['phone'] ?? 'N/A'}",
                          style: const TextStyle(color: secondaryColor), // Black text
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => clearDonationCount(donor.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Red button
                          ),
                          child: const Text(
                            "Clear Donation Count",
                            style: TextStyle(color: Colors.white), // White text
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// NGOs Tab: Displays a list of approved NGOs
class NGOsTab extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('ngos').where('approved', isEqualTo: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: accentColor), // Blue loading indicator
          );
        }

        var ngos = snapshot.data!.docs;
        if (ngos.isEmpty) {
          return const Center(
            child: Text(
              "No approved NGOs",
              style: TextStyle(color: secondaryColor), // Black text
            ),
          );
        }

        return ListView.builder(
          itemCount: ngos.length,
          itemBuilder: (context, index) {
            var ngo = ngos[index];
            var ngoData = ngo.data() as Map<String, dynamic>;

            return Card(
              color: primaryColor, // White background
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ExpansionTile(
                title: Text(
                  ngoData['name'],
                  style: const TextStyle(color: secondaryColor), // Black text
                ),
                subtitle: Text(
                  ngoData['email'],
                  style: TextStyle(color: secondaryColor.withOpacity(0.6)), // Semi-transparent black text
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mobile: ${ngoData['mobile'] ?? 'N/A'}",
                          style: const TextStyle(color: secondaryColor), // Black text
                        ),
                        Text(
                          "Address: ${ngoData['address'] ?? 'N/A'}",
                          style: const TextStyle(color: secondaryColor), // Black text
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}