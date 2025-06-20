import 'package:flutter/material.dart';

class MapAndRescueTrackerScreen extends StatelessWidget {
  const MapAndRescueTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mapFeatures = [
      {'icon': Icons.fireplace, 'label': 'Live Rescue Heatmap'},
      {'icon': Icons.warning, 'label': 'Flood Alert Zones'},
      {'icon': Icons.house, 'label': 'Shelter Locations'},
      {'icon': Icons.local_hospital, 'label': 'Nearby Hospitals'},
      {'icon': Icons.cloud, 'label': 'Weather Forecast'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map & Rescue Tracker'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: mapFeatures.map((feature) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(feature['icon'], size: 36, color: Colors.deepOrange),
                  const SizedBox(height: 10),
                  Text(
                    feature['label'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
