/*import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'RescueRequestScreen.dart';
import 'MapAndRescueTrackerScreen.dart';
import 'EmergencyContactsScreen.dart';
import 'EmergencyMedicalScreen.dart';
import 'OfflineCommunicationScreen.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

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

  List<Widget> _buildSafetySlides(double screenHeight) {
    return safetyMessages.map((msg) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        padding: const EdgeInsets.all(12),
        height: screenHeight * 0.16,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF80CBC4), Color(0xFF4DB6AC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: 15,
              right: 15,
              child: Container(
                height: 20,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellowAccent,
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 25,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink.withOpacity(0.6),
                ),
              ),
            ),
            // Message content
            Column(
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
          ],
        ),
      );
    }).toList();
  }

  final List<Widget> featureCards = const [
    FeatureCard(
      icon: Icons.emergency,
      label: 'Emergency SOS',
      color: Colors.redAccent,
      target: RescueRequestScreen(),
    ),
    FeatureCard(
      icon: Icons.map_outlined,
      label: 'Map & Rescue Tracker',
      color: Colors.orangeAccent,
      target: MapAndRescueTrackerScreen(),
    ),
    FeatureCard(
      icon: Icons.contacts,
      label: 'Emergency Contacts',
      color: Colors.green,
      target: EmergencyContactsScreen(),
    ),
    FeatureCard(
      icon: Icons.medical_services,
      label: 'Emergency Medical Info',
      color: Colors.teal,
      target: EmergencyMedicalScreen(),
    ),
    FeatureCard(
      icon: Icons.wifi_off,
      label: 'Offline Communication',
      color: Colors.brown,
      target: OfflineCommunicationScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Safety App'),
        backgroundColor: const Color(0xFF00796B), // Soft teal
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Safety Messages Carousel
                    CarouselSlider(
                      options: CarouselOptions(
                        height: screenHeight * 0.18,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        enlargeCenterPage: true,
                        viewportFraction: 0.98,
                      ),
                      items: _buildSafetySlides(screenHeight),
                    ),
                    const SizedBox(height: 20),

                    // Feature Cards Carousel
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.65,
                        enlargeCenterPage: true,
                        padEnds: false,
                        scrollPhysics: const BouncingScrollPhysics(),
                      ),
                      items: featureCards.map((card) {
                        return Builder(
                          builder: (context) => SizedBox(
                            width: 220,
                            height: 170,
                            child: card,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),

                    // Latest Alerts Section
                    Text(
                      "Latest Alerts",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
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
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.teal,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                alert,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                    const SizedBox(height: 30),

                    // First Aid Tip Shortcut
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/FirstAidTips');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB2DFDB).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.local_hospital, size: 40, color: Color(0xFF004D40)),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Emergency Health Article: First Aid Tips",
                                style: TextStyle(
                                  color: Color(0xFF004D40),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, color: Color(0xFF004D40), size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '© 2025 Emergency Safety App - All rights reserved',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
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
        color: color.withOpacity(0.95), // Solid soft color background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 6,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => target),
          ),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 12),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
*/