import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'donor_profile.dart';
import 'make_donations.dart'; // Assuming this is the correct import for MakeDonations

const Color primaryColor = Colors.white; // Background color
const Color secondaryColor = Colors.black; // Text and icon color
const Color accentColor = Colors.blue; // Accent color for buttons and highlights

class HomepageDonor extends StatefulWidget {
  final String name;

  const HomepageDonor({required this.name, Key? key}) : super(key: key);

  @override
  State<HomepageDonor> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomepageDonor> {
  int _bottomNavIndex = 0;
  final List<Widget> _pages = [
    Page1(),
    Page2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // Set background color to white
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.person, color: secondaryColor), // Set icon color to black
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonorProfile()),
                );
              },
            ),
          ),
        ],
        title: Text(
          'Welcome, ${widget.name}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: secondaryColor), // Set text color to black
        ),
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor, // Set button color to blue
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MakeDonations()));
        },
        child: Icon(Icons.add, color: primaryColor), // Set icon color to white
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [
          Icons.home,
          Icons.history,
        ],
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        backgroundColor: primaryColor, // Set background color to white
        activeColor: secondaryColor, // Set active icon color to blue
        inactiveColor: secondaryColor.withOpacity(0.5), // Set inactive icon color to lighter blue
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
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw 'Could not launch $url';
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: RadialGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  center: Alignment.center,
                  radius: 0.8,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    top: 20,
                    child: Text(
                      'Share Your Love\nwith food donation',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MakeDonations()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Donate Now",
                        style: TextStyle(color: accentColor),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Lottie.asset(
                      'assets/lottie/donate.json',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '🏆 Top Donors',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .orderBy('donationCount', descending: true)
                .limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(Icons.emoji_people, size: 60, color: Colors.grey),
                      Text('Be the first to donate and appear here!'),
                    ],
                  ),
                );
              }

              var donors = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: donors.length,
                itemBuilder: (context, index) {
                  var donor = donors[index].data() as Map<String, dynamic>;

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                      backgroundColor: accentColor,
                    ),
                    title: Text(donor['name'] ?? 'Unknown'),
                    subtitle: Text('Donations: ${donor['donationCount'] ?? 0}'),
                  );
                },
              );
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Other Donations',
              style: TextStyle(fontFamily: "Poppins"),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _launchURL("https://www.developafrica.org/donate-clothing-and-shoes-children-need"),
                    child: Image.asset(
                      'assets/images/cloth.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _launchURL("https://www.booksforafrica.org/donate/donate-books.html"),
                    child: Image.asset(
                      'assets/images/book.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _launchURL("https://www.unicefusa.org/?form=donate"),
                    child: Image.asset(
                      'assets/images/money.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _launchURL("https://www.friends2support.org/"),
                    child: Image.asset(
                      'assets/images/blood.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '🍲 Food Safety Guidelines',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text(
                      'Ensure food is freshly cooked and properly packed.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.warning, color: Colors.orange),
                    title: Text(
                      'Avoid donating expired or spoiled food.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.cleaning_services, color: Colors.blue),
                    title: Text(
                      'Use clean containers for packing food.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.label, color: Colors.purple),
                    title: Text(
                      'Label food items with preparation date and allergens.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.sanitizer, color: Colors.teal),
                    title: Text(
                      'Maintain hygiene while preparing and packing food.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('donations')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No donations found'));
        }

        var donations = snapshot.data!.docs;

        return ListView.builder(
          itemCount: donations.length,
          itemBuilder: (context, index) {
            var data = donations[index].data() as Map<String, dynamic>;

            // Extract food names and serving sizes
            List<String> foodEntries = [];
            List<String> servingSizes = [];

            if (data.containsKey('foodEntries') && data['foodEntries'] is List) {
              for (var entry in (data['foodEntries'] as List)) {
                if (entry is Map<String, dynamic>) {
                  foodEntries.add(entry['foodName'].toString());
                  servingSizes.add(entry['servingSize'].toString());
                }
              }
            }

            // Format food with serving size like "roti (10)"
            List<String> foodWithServing = [];
            for (int i = 0; i < foodEntries.length; i++) {
              foodWithServing.add("${foodEntries[i]} (${servingSizes[i]})");
            }

            String foodText = foodWithServing.isNotEmpty ? foodWithServing.join(', ') : 'Not Available';

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.white, // Set background color to light blue
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🍽️ Food: $foodText",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Status: ${data['status'] == 'accepted' ? 'Accepted by ${data['acceptedBy'] ?? 'Unknown NGO'} \nPhone: ${data['contactNumber'] ?? 'N/A'}' : data['status']}",
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey[700]),
                    ),
                    if (data['feedback'] != null) // Display feedback if available
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
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
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "📅 Date: ${data['timestamp'] != null ? DateTime.fromMillisecondsSinceEpoch(data['timestamp'].millisecondsSinceEpoch).toLocal().toString().split(' ')[0] : 'Unknown'}",
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Icon(Icons.fastfood, color: Colors.orangeAccent),
                      ],
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