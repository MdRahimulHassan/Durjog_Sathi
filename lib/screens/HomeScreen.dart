import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginPage.dart';

// Screens
import 'HomeContent.dart';
import 'StatisticsScreen.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Screens for each bottom nav item
  final List<Widget> _screens = [
    const HomeContent(),         // Grid-based Home screen
    const StatisticsScreen(),    // Statistics placeholder
    const ProfileScreen(),       // Profile placeholder
  ];

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ✅ AppBar shown on every tab
      appBar: AppBar(
        title: const Text('Durjog Bondhu', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ✅ Drawer shown on every tab
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/Rahimul.png"),
                radius: 40,
              ),
              accountName: const Text("Rahimul", style: TextStyle(fontSize: 18)),
              accountEmail: const Text("2021831050@student.sust.edu"),
            ),
            _buildDrawerItem(Icons.home, "Home"),
            _buildDrawerItem(Icons.favorite, "Favourites"),
            _buildDrawerItem(Icons.work, "Workflow"),
            _buildDrawerItem(Icons.update, "Updates"),
            const Divider(),
            _buildDrawerItem(Icons.extension, "Plugins"),
            _buildDrawerItem(Icons.notifications, "Notifications"),
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

      // ✅ Active screen shown based on selected index
      body: _screens[_selectedIndex],

      // ✅ Bottom Navigation Bar (stays always)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistics'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () => Navigator.pop(context),
    );
  }
}
