import 'package:flutter/material.dart';

class OfflineCommunicationScreen extends StatelessWidget {
  const OfflineCommunicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Communication')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            FeatureCard(
              icon: Icons.map,
              label: 'Offline Maps',
              color: Colors.deepPurpleAccent,
            ),
            FeatureCard(
              icon: Icons.message_outlined,
              label: 'Message Queue',
              color: Colors.teal,
            ),
            FeatureCard(
              icon: Icons.check_circle_outline,
              label: 'Alert Acknowledge',
              color: Colors.indigo,
            ),
            FeatureCard(
              icon: Icons.sms,
              label: 'SMS Location',
              color: Colors.orangeAccent,
            ),
            FeatureCard(
              icon: Icons.bluetooth,
              label: 'Bluetooth Mesh',
              color: Colors.pinkAccent,
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

  const FeatureCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Placeholder – will be implemented later
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label coming soon!')),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
