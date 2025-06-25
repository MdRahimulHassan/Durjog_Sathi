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
      padding: const EdgeInsets.all(35.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          FeatureCard(
            icon: Icons.emergency,
            label: 'Emergency SOS',
            color: Colors.redAccent,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RescueRequestScreen()),
            ),
          ),
          FeatureCard(
            icon: Icons.map_outlined,
            label: 'Map & Rescue Tracker',
            color: Colors.orangeAccent,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MapAndRescueTrackerScreen()),
            ),
          ),
          FeatureCard(
            icon: Icons.contacts,
            label: 'Emergency Contacts',
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EmergencyContactsScreen()),
            ),
          ),
          FeatureCard(
            icon: Icons.medical_services,
            label: 'Emergency Medical Info',
            color: Colors.teal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EmergencyMedicalScreen()),
            ),
          ),
          FeatureCard(
            icon: Icons.wifi_off,
            label: 'Offline Communication',
            color: Colors.brown,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OfflineCommunicationScreen()),
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
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.label,
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
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
