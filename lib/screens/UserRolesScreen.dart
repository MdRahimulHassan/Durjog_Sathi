import 'package:flutter/material.dart';
import 'HomeScreen.dart' as home;

class UserRolesScreen extends StatefulWidget {
  const UserRolesScreen({super.key});

  @override
  State<UserRolesScreen> createState() => _UserRolesScreenState();
}

class _UserRolesScreenState extends State<UserRolesScreen> {
  final List<Map<String, dynamic>> roles = [
    {
      "name": "Affected Persons",
      "tagline": "Need support",
      "icon": Icons.person,
      "color": const Color(0xFFFF6A00),
      "emoji": "❤️",
    },
    {
      "name": "Rescuers",
      "tagline": "Helping hands",
      "icon": Icons.shield,
      "color": const Color(0xFF3888FF),
      "emoji": "🛡️",
    },
    {
      "name": "Medical Staff",
      "tagline": "Life savers",
      "icon": Icons.medical_services,
      "color": const Color(0xFFFF3D68),
      "emoji": "🚑",
    },
    {
      "name": "Volunteers",
      "tagline": "Hearts that help",
      "icon": Icons.volunteer_activism,
      "color": const Color(0xFF4A00E0),
      "emoji": "🤝",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/role_screen_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Choose your role",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      itemCount: roles.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final role = roles[index];
                        return RoleCard(
                          roleName: role['name']!,
                          tagline: role['tagline']!,
                          icon: role['icon']!,
                          color: role['color']!,
                          emoji: role['emoji']!,
                          onTap: () {
                            if (role['name'] == "Affected Persons") {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const home.HomeScreen(),
                                ),
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
                        );
                      },
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

class RoleCard extends StatefulWidget {
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
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.03), // Subtle movement
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _animation,
              child: Text(
                widget.emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 10),
            Icon(widget.icon, size: 32, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              widget.roleName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.tagline,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
