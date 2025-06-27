import 'dart:ui';
import 'package:flutter/material.dart';
import 'RescueRequestScreen.dart';
import 'MapAndRescueTrackerScreen.dart';
import 'EmergencyContactsScreen.dart';
import 'EmergencyMedicalScreen.dart';
import 'OfflineCommunicationScreen.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.95, // Slightly taller to avoid overflow
        children: const [
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
