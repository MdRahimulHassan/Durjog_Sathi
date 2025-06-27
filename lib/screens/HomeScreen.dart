import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'RescueRequestScreen.dart';
import 'MapAndRescueTrackerScreen.dart';
import 'EmergencyMedicalScreen.dart';
import 'OfflineCommunicationScreen.dart';
import 'LoginPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showFooter = false;

  final List<Map<String, String>> safetyMessages = const [
    {
      "title": "ARE YOU SAFE?",
      "subtitle": "If you need urgent help, use the Emergency SOS below immediately.",
    },
    {
      "title": "STAY CALM. STAY ALERT.",
      "subtitle": "Help is nearby. Use the SOS feature or contact your emergency group.",
    },
    {
      "title": "NEED TO BE RESCUED?",
      "subtitle": "Activate the Emergency SOS or mark your location now.",
    },
    {
      "title": "INJURED OR UNWELL?",
      "subtitle": "Go to Emergency Medical Info for immediate first aid guidance.",
    },
    {
      "title": "NO INTERNET? NO WORRIES.",
      "subtitle": "Use Offline Communication to alert rescuers or neighbors near you.",
    },
  ];

  final List<String> latestAlerts = const [
    "Severe weather warning in your area. Stay indoors.",
    "Roadblock reported near Main St., avoid if possible.",
    "Nearby shelter open for emergency accommodation.",
    "Medical supplies running low at local clinics. Donate if possible.",
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showFooter = false;
    });
  }

  List<Widget> _buildSafetySlides(double screenHeight) {
    return safetyMessages.map((msg) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF80CBC4), Color(0xFF4DB6AC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg['title']!,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              msg['subtitle']!,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _homeContent(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    final safetySlides = _buildSafetySlides(screenHeight);

    final featureCards = [
      FeatureCard(
        icon: Icons.emergency,
        label: 'Emergency SOS',
        color: const Color(0xFFFF5252),
        target: RescueRequestScreen(),
      ),
      FeatureCard(
        icon: Icons.map_outlined,
        label: 'Map & Rescue Tracker',
        color: const Color(0xFFFFEE58),
        target: MapAndRescueTrackerScreen(),
      ),
      FeatureCard(
        icon: Icons.medical_services,
        label: 'Emergency Medical Info',
        color: const Color(0xFF26C6DA),
        target: EmergencyMedicalScreen(),
      ),
      FeatureCard(
        icon: Icons.wifi_off,
        label: 'Offline Communication',
        color: const Color(0xFF8D6E63),
        target: OfflineCommunicationScreen(),
      ),
    ];

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.axis == Axis.vertical) {
          final maxScroll = scrollNotification.metrics.maxScrollExtent;
          final currentScroll = scrollNotification.metrics.pixels;
          final bool nearBottom = (maxScroll - currentScroll) <= 50;
          if (nearBottom != _showFooter) {
            setState(() {
              _showFooter = nearBottom;
            });
          }
        }
        return false;
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: screenHeight * 0.14,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                enlargeCenterPage: true,
                viewportFraction: 0.95,
              ),
              items: safetySlides,
            ),
            const SizedBox(height: 30),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
              children: featureCards,
            ),
            const SizedBox(height: 30),
            Text(
              "Latest Alerts",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 8),
            ...latestAlerts.map((alert) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.teal, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(alert, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 30),
            if (_showFooter)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                child: const Center(
                  child: Text('© 2025 Dujog Bondhu - All rights reserved', style: TextStyle(color: Colors.black54, fontSize: 12)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statisticsContent() => const Center(child: Text("Statistics Screen", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
  Widget _notificationsContent() => const Center(child: Text("Notifications Screen", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));

  Widget _profileContent() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage("assets/images/Rahimul.jpg"),
            radius: 40,
          ),
          accountName: Text("Rahimul", style: TextStyle(fontSize: 18)),
          accountEmail: Text("2021831050@student.sust.edu"),
        ),
        _buildDrawerItem(Icons.home, "Home", onTap: () {
          setState(() => _selectedIndex = 0);
          Navigator.pop(context);
        }),
        _buildDrawerItem(Icons.favorite, "Favourites"),
        _buildDrawerItem(Icons.work, "Workflow"),
        _buildDrawerItem(Icons.update, "Updates"),
        const Divider(),
        _buildDrawerItem(Icons.extension, "Plugins"),
        _buildDrawerItem(Icons.notifications, "Notifications", onTap: () {
          setState(() => _selectedIndex = 2);
          Navigator.pop(context);
        }),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.black54),
          title: const Text("Logout", style: TextStyle(fontSize: 16)),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
          },
        ),
      ],
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap ?? () => debugPrint('$title tapped'),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    switch (_selectedIndex) {
      case 1:
        bodyContent = _statisticsContent();
        break;
      case 2:
        bodyContent = _notificationsContent();
        break;
      case 3:
        bodyContent = _profileContent();
        break;
      case 0:
      default:
        bodyContent = _homeContent(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Dujog Bondhu',
          style: TextStyle(color: Colors.black,
            fontSize: 24,  // Increased font size
            fontWeight: FontWeight.bold,),

        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      drawer: Drawer(child: _profileContent()),
      body: bodyContent,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900]?.withOpacity(0.85),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistics'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Widget target;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Card(
        color: color.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => target)),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
