import 'package:flutter/material.dart';
import 'FirstAidTips.dart';

class EmergencyMedicalScreen extends StatelessWidget {
  const EmergencyMedicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        'icon': Icons.healing,
        'title': 'First Aid Tips',
        'subtitle': 'Essential emergency care techniques',
        'route': const FirstAidTips(),
        'color': const Color(0xFF4CAF50),
      },
      {
        'icon': Icons.monitor_heart,
        'title': 'Symptoms to Watch',
        'subtitle': 'Critical warning signs guide',
        'color': const Color(0xFFE53935),
      },
      {
        'icon': Icons.local_hospital,
        'title': 'Nearby Hospitals',
        'subtitle': 'Find closest medical facilities',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': Icons.medication_liquid,
        'title': 'Emergency Medications',
        'subtitle': 'Quick reference medication guide',
        'color': const Color(0xFFFF9800),
      },
      {
        'icon': Icons.bloodtype,
        'title': 'Blood Donation Info',
        'subtitle': 'Donation centers and information',
        'color': const Color(0xFF9C27B0),
      },
      {
        'icon': Icons.health_and_safety,
        'title': 'Injury Types',
        'subtitle': 'Common injuries and treatments',
        'color': const Color(0xFF795548),
      },
      {
        'icon': Icons.menu_book,
        'title': 'Medical Resources',
        'subtitle': 'Educational materials and guides',
        'color': const Color(0xFF607D8B),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2C3E50),
        title: const Text(
          "Emergency Medical Information",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        color: Color(0xFF1976D2),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Access Medical Resources',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Essential medical information at your fingertips',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Options List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (option.containsKey('route')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => option['route'],
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${option['title']} coming soon!'),
                              backgroundColor: const Color(0xFF2C3E50),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: option['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                option['icon'],
                                color: option['color'],
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    option['subtitle'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.shade400,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}