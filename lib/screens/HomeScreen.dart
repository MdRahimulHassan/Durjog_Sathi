import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';

import 'RescueRequestScreen.dart';
import 'MapAndRescueTrackerScreen.dart';
import 'EmergencyMedicalScreen.dart';
import 'OfflineCommunicationScreen.dart';
import 'LoginPage.dart';
import 'UserRolesScreen.dart';

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

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showFooter = false;
    });
    _animationController.reset();
    _animationController.forward();
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

  Widget _statisticsContent() {
    // Professional emergency management statistics
    final totalIncidents = 247;
    final activeIncidents = 18;
    final resolvedIncidents = 229;
    final totalPersonnel = 156;
    final deployedPersonnel = 42;
    final availablePersonnel = 114;
    final responseTime = 8.5; // minutes average
    final successRate = 94.7; // percentage

    // Weekly incident data (last 7 days)
    final incidentData = [
      {'day': 'Mon', 'reported': 35, 'resolved': 32, 'ongoing': 3},
      {'day': 'Tue', 'reported': 28, 'resolved': 26, 'ongoing': 2},
      {'day': 'Wed', 'reported': 42, 'resolved': 38, 'ongoing': 4},
      {'day': 'Thu', 'reported': 31, 'resolved': 29, 'ongoing': 2},
      {'day': 'Fri', 'reported': 39, 'resolved': 35, 'ongoing': 4},
      {'day': 'Sat', 'reported': 45, 'resolved': 41, 'ongoing': 4},
      {'day': 'Sun', 'reported': 33, 'resolved': 30, 'ongoing': 3},
    ];

    // Response type distribution
    final responseTypes = [
      PieChartSectionData(
        color: const Color(0xFF0293EE),
        value: 35,
        title: 'Medical\n35%',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: const Color(0xFFF8B250),
        value: 28,
        title: 'Fire\n28%',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: const Color(0xFF845EC2),
        value: 22,
        title: 'Rescue\n22%',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: const Color(0xFF4E9F3D),
        value: 15,
        title: 'Other\n15%',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];

    return Container(
      color: const Color(0xFFF5F7FA),
      child: Column(
        children: [
          // Top App Bar
          Container(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.analytics_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statistics Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Real-time emergency data analysis',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Quick stats in app bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$activeIncidents Active',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content below app bar
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100), // Added bottom padding for floating nav
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Stats Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Incidents',
                          totalIncidents.toString(),
                          Icons.report_problem_outlined,
                          const Color(0xFF3B82F6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Success Rate',
                          '${successRate.toStringAsFixed(1)}%',
                          Icons.check_circle_outline,
                          const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Avg Response',
                          '${responseTime.toStringAsFixed(1)} min',
                          Icons.timer_outlined,
                          const Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Personnel',
                          '$deployedPersonnel/$totalPersonnel',
                          Icons.people_outline,
                          const Color(0xFF8B5CF6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Charts Section
                  const Text(
                    'Weekly Incident Analysis',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                  ),
                  const SizedBox(height: 16),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Incident Reports vs Resolution Rate',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Success Rate: ${successRate.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        AspectRatio(
                          aspectRatio: 1.6,
                          child: BarChart(
                            BarChartData(
                              maxY: 50,
                              backgroundColor: Colors.transparent,
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      if (value < 0 || value >= incidentData.length) return const Text('');
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          incidentData[value.toInt()]['day'] as String,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 10,
                                    getTitlesWidget: (value, _) => Text(
                                      '${value.toInt()}',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                                drawVerticalLine: false,
                                horizontalInterval: 10,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.grey.withOpacity(0.2),
                                  strokeWidth: 1,
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: List.generate(incidentData.length, (index) {
                                final data = incidentData[index];
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: (data['reported'] as int).toDouble(),
                                      width: 8,
                                      color: const Color(0xFF3B82F6),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                    BarChartRodData(
                                      toY: (data['resolved'] as int).toDouble(),
                                      width: 8,
                                      color: const Color(0xFF10B981),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                  ],
                                  barsSpace: 3,
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLegendItem('Reported', const Color(0xFF3B82F6)),
                            const SizedBox(width: 24),
                            _buildLegendItem('Resolved', const Color(0xFF10B981)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Incident Type Distribution
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Incident Type Distribution',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Current month breakdown',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        AspectRatio(
                          aspectRatio: 1.3,
                          child: PieChart(
                            PieChartData(
                              sections: responseTypes,
                              centerSpaceRadius: 40,
                              sectionsSpace: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Helper method for stat cards
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

// Helper method for legend items
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
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
          : const Color(0xFF9CA3AF),
    ),
          child: Text(
            label,
            key: ValueKey(isSelected),
          ),
        ),
              ],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _homeContent(context),
      _statisticsContent(),
      _notificationsContent(),
      _profileContent(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Main content
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: pages[_selectedIndex],
                ),
              );
            },
          ),

          // Floating Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
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
                    label: 'Alerts',
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => target),
        );
      },
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ),
    );
  }
}