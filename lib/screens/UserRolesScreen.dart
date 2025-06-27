import 'dart:ui';
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
      extendBody: true,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/role.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Semi-transparent overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Your Role",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: roles.length,
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const home.HomeScreen()),
                              );
                            } else if (role['name'] == "Rescuers") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const RescuersScreen()),
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
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) => _controller.reverse();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _controller.reverse,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(widget.icon, size: 28, color: widget.color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 4),
                        Text(
                          widget.roleName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.tagline,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white54),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
