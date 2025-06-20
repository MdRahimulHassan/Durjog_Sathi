import 'package:flutter/material.dart';
import 'HomeScreen.dart' as home;

class UserRolesScreen extends StatelessWidget {
  const UserRolesScreen({super.key});

  final List<Map<String, dynamic>> roles = const [
    {
      "name": "Affected Persons",
      "tagline": "Need support",
      "icon": Icons.person,
      "color": Color(0xFFFF6A00),
    },
    {
      "name": "Rescuers",
      "tagline": "Helping hands",
      "icon": Icons.shield,
      "color": Color(0xFF3888FF),
    },
    {
      "name": "Medical Staff",
      "tagline": "Life savers",
      "icon": Icons.medical_services,
      "color": Color(0xFFFF3D68),
    },
    {
      "name": "Volunteers",
      "tagline": "Hearts that help",
      "icon": Icons.volunteer_activism,
      "color": Color(0xFF4A00E0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Choose Your Role"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: roles.map((role) {
            return RoleCard(
              roleName: role['name']!,
              tagline: role['tagline']!,
              icon: role['icon']!,
              color: role['color']!,
              onTap: () {
                if (role['name'] == "Affected Persons") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const home.HomeScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${role['name']} feature coming soon!")),
                  );
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String roleName;
  final String tagline;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.roleName,
    required this.tagline,
    required this.icon,
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
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.7),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Text(
              roleName,
              style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              tagline,
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
