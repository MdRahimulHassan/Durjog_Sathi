import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'EmergencyMedicalScreen.dart';
import 'MapAndRescueTrackerScreen.dart';
//import 'WeatherForecastScreen.dart';

//import 'AffectedZonesScreen.dart';
import 'EmergencyContactsScreen.dart';
//import 'profile.dart';
import 'RescueRequestScreen.dart';
//import 'FloodAlertsScreen.dart';
import 'LoginPage.dart';
//import 'ShelterLocationsScreen.dart';
import 'OfflineCommunicationScreen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // AppBar with hamburger menu
      appBar: AppBar(
        title: const Text('Durjog Bondhu', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Navigation Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/Rahimul.png"),
                radius: 40,
              ),
              accountName: const Text("Rahimul", style: TextStyle(fontSize: 18)),
              accountEmail: const Text("2021831050@student.sust.edu"),
            ),
            _buildDrawerItem(Icons.home, "Home", context),
            _buildDrawerItem(Icons.favorite, "Favourites", context),
            _buildDrawerItem(Icons.work, "Workflow", context),
            _buildDrawerItem(Icons.update, "Updates", context),
            const Divider(),
            _buildDrawerItem(Icons.extension, "Plugins", context),
            _buildDrawerItem(Icons.notifications, "Notifications", context),

            // 🔒 Logout Item
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black54),
              title: const Text("Logout", style: TextStyle(fontSize: 16)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),

      // Body Grid View
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            FeatureCard(
              icon: Icons.emergency,
              label: 'Emergency SOS',
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RescueRequestScreen()),
                );
              },
            ),
            FeatureCard(
              icon: Icons.map_outlined,
              label: 'Map & Rescue Tracker',
              color: Colors.orangeAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapAndRescueTrackerScreen()),
                );
              },
            ),

            FeatureCard(
              icon: Icons.contacts,
              label: 'Emergency Contacts',
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmergencyContactsScreen()),
              ),
            ),
            FeatureCard(
              icon: Icons.medical_services,
              label: 'Emergency Medical Info',
              color: Colors.teal,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmergencyMedicalScreen()),
              ),
            ),
            FeatureCard(
              icon: Icons.wifi_off,
              label: 'Offline Communication',
              color: Colors.brown,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OfflineCommunicationScreen(),
                  ),
                );
              },
            ),


          ],
        ),
      ),
    );
  }

  // Drawer Item Builder
  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

// ✅ FeatureCard Widget
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const FeatureCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}