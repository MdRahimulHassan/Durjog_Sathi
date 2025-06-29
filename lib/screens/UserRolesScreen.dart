import 'dart:ui';
import 'package:flutter/material.dart';
import 'HomeScreen.dart' as home;
import 'RescuersScreen.dart';

class UserRolesScreen extends StatefulWidget {
  const UserRolesScreen({super.key});

  @override
  State<UserRolesScreen> createState() => _UserRolesScreenState();
}

class _UserRolesScreenState extends State<UserRolesScreen>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  final List<Map<String, dynamic>> roles = [
    {
      "name": "Affected Persons",
      "tagline": "Emergency Support",
      "description": "Get immediate help during crisis",
      "icon": Icons.emergency_outlined,
      "color": Color(0xFFE74C3C),
      "lightColor": Color(0xFFFFEBEE),
      "emoji": "🆘",
      "status": "URGENT",
      "hasBlinking": true,
    },
    {
      "name": "Rescuers",
      "tagline": "First Responders",
      "description": "Coordinate rescue operations",
      "icon": Icons.shield_outlined,
      "color": Color(0xFF3498DB),
      "lightColor": Color(0xFFE3F2FD),
      "emoji": "🚨",
      "status": "ACTIVE",
      "hasBlinking": true,
    },
    {
      "name": "Medical\nResponse Unit",
      "tagline": "Healthcare Heroes",
      "description": "Medical assistance",
      "icon": Icons.local_hospital_outlined,
      "color": Color(0xFF27AE60),
      "lightColor": Color(0xFFE8F5E8),
      "emoji": "⚕️",
      "status": "READY",
      "hasBlinking": true,
    },
    {
      "name": "Military\nAssistance",
      "tagline": "Community Support",
      "description": "Military assistance",
      "icon": Icons.volunteer_activism_outlined,
      "color": Color(0xFF9B59B6),
      "lightColor": Color(0xFFF3E5F5),
      "emoji": "🤝",
      "status": "OPEN",
      "hasBlinking": true,
    },
  ];

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _blinkController,
        curve: Curves.easeInOut,
      ),
    );

    _blinkController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Roles List
            Expanded(
              child: _buildRolesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Emergency badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE74C3C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE74C3C).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _blinkAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _blinkAnimation.value,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE74C3C),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  "EMERGENCY RESPONSE SYSTEM",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE74C3C),
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Select Your Role",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2C3E50),
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            "Choose your role to access the appropriate dashboard",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRolesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: roles.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ProfessionalRoleCard(
            role: roles[index],
            blinkAnimation: _blinkAnimation,
            onTap: () => _handleRoleTap(roles[index]),
          ),
        );
      },
    );
  }

  void _handleRoleTap(Map<String, dynamic> role) {
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
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "${role['name']} portal is under development",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF34495E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

class ProfessionalRoleCard extends StatefulWidget {
  final Map<String, dynamic> role;
  final Animation<double> blinkAnimation;
  final VoidCallback onTap;

  const ProfessionalRoleCard({
    super.key,
    required this.role,
    required this.blinkAnimation,
    required this.onTap,
  });

  @override
  State<ProfessionalRoleCard> createState() => _ProfessionalRoleCardState();
}

class _ProfessionalRoleCardState extends State<ProfessionalRoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _pressAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _pressController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _pressController.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _pressController.reverse();
      },
      child: AnimatedBuilder(
        animation: _pressAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pressAnimation.value,
            child: Container(
              height: (widget.role['name'] == "Medical\nResponse Unit" ||
                  widget.role['name'] == "Military\nAssistance") ? 157 : 142, // Increased height for last two cards
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.role['color'].withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: _isPressed
                      ? widget.role['color'].withOpacity(0.3)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: (widget.role['name'] == "Medical\nResponse Unit" ||
                    widget.role['name'] == "Military\nAssistance")
                    ? const EdgeInsets.all(12)
                    : const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: widget.role['lightColor'],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        widget.role['icon'],
                        size: 28,
                        color: widget.role['color'],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Status and Emoji Row
                          Row(
                            children: [
                              Text(
                                widget.role['emoji'],
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 8),
                              if (widget.role['hasBlinking'])
                                AnimatedBuilder(
                                  animation: widget.blinkAnimation,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity: widget.blinkAnimation.value,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: widget.role['color'],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          widget.role['status'],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.role['color'].withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.role['status'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: widget.role['color'],
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          // Role Name
                          Text(
                            widget.role['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C3E50),
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 2),

                          // Description
                          Text(
                            widget.role['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Arrow Icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: widget.role['lightColor'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: widget.role['color'],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}