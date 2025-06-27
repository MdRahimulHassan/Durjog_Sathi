import 'package:flutter/material.dart';
import 'LiveRescueHeatmapScreen.dart';
import 'FloodAlertZoneScreen.dart';
import 'ShelterLocationsScreen.dart';
import 'NearbyHospitalsScreen.dart';
import 'UserSafeRouteScreen.dart';
import 'RescueRequestsMapScreen.dart';
import 'WeatherForecastScreen.dart';

class MapAndRescueTrackerScreen extends StatelessWidget {
  const MapAndRescueTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mapFeatures = [
      {
        'icon': Icons.fireplace,
        'label': 'Live Rescue Heatmap',
        'screen': LiveRescueHeatmapScreen()
      },
      {
        'icon': Icons.warning,
        'label': 'Flood Alert Zones',
        'screen': const FloodAlertZonesScreen()
      },
      {
        'icon': Icons.house,
        'label': 'Shelter Locations',
        'screen': const Shelter_Locations_Screen()
      },
      {
        'icon': Icons.local_hospital,
        'label': 'Nearby Hospitals',
        'screen': const NearbyHospitalsScreen()
      },
      {
        'icon': Icons.cloud,
        'label': 'Weather Forecast',
        'screen': const WeatherForecastScreen()
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map & Rescue Tracker'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: mapFeatures.map((feature) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => feature['screen']),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade100, // Darker card color
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepOrange.shade200.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(feature['icon'], size: 40, color: Colors.deepOrange.shade700),
                    const SizedBox(height: 12),
                    Text(
                      feature['label'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
