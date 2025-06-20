import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Import your FirstAidTips screen here
import 'FirstAidTips.dart';  // Adjust the path according to your project structure

class EmergencyMedicalScreen extends StatelessWidget {
  const EmergencyMedicalScreen({super.key});

  // Method to launch dialer
  void _callEmergencyNumber() async {
    final Uri url = Uri.parse('tel:999'); // Replace with local emergency number
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Could not launch dialer');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {'icon': Icons.healing, 'title': 'First Aid Tips', 'route': FirstAidTips()},
      {'icon': Icons.monitor_heart, 'title': 'Symptoms to Watch'},
      {'icon': Icons.local_hospital, 'title': 'Nearby Hospitals'},
      {'icon': Icons.medication_liquid, 'title': 'Emergency Medications'},
      {'icon': Icons.bloodtype, 'title': 'Blood Donation Info'},
      {'icon': Icons.health_and_safety, 'title': 'Injury Types'},
      {'icon': Icons.phone_in_talk, 'title': 'Call 999', 'action': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Medical Info"),
        backgroundColor: Colors.teal,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(35),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: options.map((option) {
          return GestureDetector(
            onTap: () {
              if (option['action'] == true) {
                _callEmergencyNumber();
              } else if (option.containsKey('route')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => option['route']),
                );
              } else {
                // Add other navigation or logic for other options here if needed
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(option['icon'], size: 36, color: Colors.teal),
                  const SizedBox(height: 10),
                  Text(
                    option['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
