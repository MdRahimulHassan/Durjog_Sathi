import 'package:flutter/material.dart';
import 'HomeScreen.dart' as home;
import 'RescuersScreen.dart';

class UserRolesScreen extends StatelessWidget {
  const UserRolesScreen({super.key});

  final List<Map<String, dynamic>> roles = const [
    {
      "name": "Affected Persons",
      "tagline": "Need support",
      "icon": Icons.person,
      "color": Colors.orange,
      "emoji": "❤️",
    },
    {
      "name": "Rescuers",
      "tagline": "Helping hands",
      "icon": Icons.shield,
      "color": Colors.blue,
      "emoji": "🛡️",
    },
    {
      "name": "Medical Staff",
      "tagline": "Life savers",
      "icon": Icons.medical_services,
      "color": Colors.redAccent,
      "emoji": "🚑",
    },
    {
      "name": "Volunteers",
      "tagline": "Hearts that help",
      "icon": Icons.volunteer_activism,
      "color": Colors.purple,
      "emoji": "🤝",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // 👈 Ensures background reaches the bottom
      body: Stack(
        children: [
          // 🔲 Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/role.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔲 Color overlay
          Container(
            color: Colors.black.withOpacity(0.65),
          ),

          // 🔲 Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Select Your Role",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...roles.map((role) => RoleCard(
                    roleName: role['name']!,
                    tagline: role['tagline']!,
                    icon: role['icon']!,
                    color: role['color']!,
                    emoji: role['emoji']!,
                    onTap: () {
                      if (role['name'] == "Affected Persons") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const home.HomeScreen()),
                        );
                      } else if (role['name'] == "Rescuers") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RescuersScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${role['name']} feature coming soon!"),
                            backgroundColor: Colors.black87,
                          ),
                        );
                      }
                    },
                  )),
                  const SizedBox(height: 20), // Padding to ensure last card doesn't stick to bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String roleName;
  final String tagline;
  final IconData icon;
  final Color color;
  final String emoji;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.roleName,
    required this.tagline,
    required this.icon,
    required this.color,
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.95),
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24,
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 4),
                    Text(
                      roleName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      tagline,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
