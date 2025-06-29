import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'RescueRequestScreen.dart';
import 'MapAndRescueTrackerScreen.dart';
import 'EmergencyMedicalScreen.dart';
import 'OfflineCommunicationScreen.dart';
import 'LoginPage.dart';
import 'UserRolesScreen.dart';
import 'Statistics.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showFooter = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  void _onTabTapped(int index) async {
    if (index == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StatisticsScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
        _showFooter = false;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  List<Widget> _buildSafetySlides(double screenHeight) {
    return safetyMessages.map((msg) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1565C0).withOpacity(0.9),
              const Color(0xFF0D47A1).withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              msg['title']!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              msg['subtitle']!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
                height: 1.3,
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
        color: const Color(0xFFE53E3E),
        target: RescueRequestScreen(),
      ),
      FeatureCard(
        icon: Icons.map_outlined,
        label: 'Map & Rescue Tracker',
        color: const Color(0xFF3182CE),
        target: MapAndRescueTrackerScreen(),
      ),
      FeatureCard(
        icon: Icons.medical_services,
        label: 'Emergency Medical Info',
        color: const Color(0xFF38A169),
        target: EmergencyMedicalScreen(),
      ),
      FeatureCard(
        icon: Icons.wifi_off,
        label: 'Offline Communication',
        color: const Color(0xFF805AD5),
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
      child: Container(
        color: const Color(0xFFF8FAFC),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Added bottom padding for floating nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: Color(0xFF1565C0),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stay Safe, Stay Connected',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your safety companion is here to help',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Safety Messages Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: screenHeight * 0.14,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  enlargeCenterPage: true,
                  viewportFraction: 0.92,
                ),
                items: safetySlides,
              ),

              const SizedBox(height: 32),

              // Quick Actions Section
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A202C),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: featureCards,
              ),
              const SizedBox(height: 32),

              // Latest Alerts Section
              const Text(
                'Latest Alerts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A202C),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: latestAlerts.asMap().entries.map((entry) {
                    int index = entry.key;
                    String alert = entry.value;
                    bool isLast = index == latestAlerts.length - 1;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: !isLast ? Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade100,
                            width: 1,
                          ),
                        ) : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFED7D7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFE53E3E),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              alert,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2D3748),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),

              if (_showFooter)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Center(
                    child: Text(
                      '© 2025 Dujog Bondhu - All rights reserved',
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationsContent() => Container(
    color: const Color(0xFFF8FAFC),
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Color(0xFF718096),
          ),
          SizedBox(height: 16),
          Text(
            "No Notifications Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "You're all caught up!",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _profileContent() {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/Rahimul.jpg"),
                  radius: 40,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  "Rahimul",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "2021831050@student.sust.edu",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildModernDrawerItem(Icons.home_outlined, "Home", onTap: () {
            setState(() => _selectedIndex = 0);
            Navigator.pop(context);
          }),
          _buildModernDrawerItem(Icons.favorite_outline, "Favourites"),
          _buildModernDrawerItem(Icons.work_outline, "Workflow"),
          _buildModernDrawerItem(Icons.update, "Updates"),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 8),
          _buildModernDrawerItem(Icons.extension_outlined, "Plugins"),
          _buildModernDrawerItem(Icons.notifications_outlined, "Notifications", onTap: () {
            setState(() => _selectedIndex = 2);
            Navigator.pop(context);
          }),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.logout, size: 20),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFFE53E3E),
                backgroundColor: const Color(0xFFFED7D7),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 100), // Added padding for floating nav
        ],
      ),
    );
  }

  Widget _buildModernDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4A5568), size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap ?? () => debugPrint('$title tapped'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildFloatingNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1565C0).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected
                    ? const Color(0xFF1565C0)
                    : const Color(0xFF718096),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF1565C0)
                    : const Color(0xFF718096),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavigationBar() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: const Color(0xFF1565C0).withOpacity(0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFloatingNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    index: 0,
                    onTap: () => _onTabTapped(0),
                  ),
                  _buildFloatingNavItem(
                    icon: Icons.bar_chart_outlined,
                    activeIcon: Icons.bar_chart,
                    label: 'Statistics',
                    index: 1,
                    onTap: () => _onTabTapped(1),
                  ),
                  _buildFloatingNavItem(
                    icon: Icons.notifications_outlined,
                    activeIcon: Icons.notifications,
                    label: 'Notifications',
                    index: 2,
                    onTap: () => _onTabTapped(2),
                  ),
                  _buildFloatingNavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    index: 3,
                    onTap: () => _onTabTapped(3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    switch (_selectedIndex) {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserRolesScreen()),
            );
          },
        ),
        title: const Text(
          'Dujog Bondhu',
          style: TextStyle(
            color: Color(0xFF1A202C),
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      drawer: Drawer(
        child: _profileContent(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      body: Stack(
        children: [
          bodyContent,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildFloatingNavigationBar(),
          ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => target),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}