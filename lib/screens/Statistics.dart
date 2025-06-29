import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Emergency Management Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with current status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'All Systems Operational',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Last Updated: ${DateTime.now().toString().substring(0, 16)}',
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

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
    );
  }



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
}