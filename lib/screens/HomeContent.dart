import 'dart:ui';
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

  List<Widget> _buildSafetySlides(double screenHeight) {
    return safetyMessages.map((msg) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        padding: const EdgeInsets.all(12),
        height: screenHeight * 0.16,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF800080), Color(0xFFD147BD)],
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

    return Padding(
      padding: const EdgeInsets.all(16),
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
                viewportFraction: 0.98, // Wider width across screen
              ),
              items: _buildSafetySlides(screenHeight),
            ),
            const SizedBox(height: 20),

            // Feature Cards Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 190,
                enableInfiniteScroll: false,
                viewportFraction: 0.65,
                enlargeCenterPage: true,
                padEnds: false,
                scrollPhysics: const BouncingScrollPhysics(),
              ),
              items: featureCards.map((card) {
                return Builder(builder: (context) => card);
              }).toList(),
            ),
            const SizedBox(height: 30),

            // First Aid Tip Shortcut
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/FirstAidTips');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.local_hospital, size: 40, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Emergency Health Article: First Aid Tips",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                  ],
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
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Card(
          color: Colors.white.withOpacity(0.15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
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
                  Icon(icon, size: 40, color: color),
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
      ),
    );
  }
}
