import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OfflineCommunicationScreen extends StatefulWidget {
  const OfflineCommunicationScreen({super.key});

  @override
  State<OfflineCommunicationScreen> createState() => _OfflineCommunicationScreenState();
}

class _OfflineCommunicationScreenState extends State<OfflineCommunicationScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Method to call emergency number
  void _callEmergencyNumber(BuildContext context) async {
    final Uri url = Uri.parse('tel:999');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Text('Could not launch dialer'),
            ],
          ),
          backgroundColor: Color(0xFFE74C3C),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2C3E50),
        title: const Text(
          'Offline Communication',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Emergency Call Section
            _buildEmergencySection(),

            const SizedBox(height: 10),

            // Communication Tools Section
            _buildCommunicationTools(),

            const SizedBox(height: 32),

            // Offline Features Section
            _buildOfflineFeatures(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencySection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16), // Reduced padding from 24 to 16
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE74C3C).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emergency,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'EMERGENCY HOTLINE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12), // Reduced spacing from 20 to 12

          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: GestureDetector(
                  onTap: () => _callEmergencyNumber(context),
                  child: Container(
                    width: 90, // Reduced from 120 to 90
                    height: 90, // Reduced from 120 to 90
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          size: 28, // Reduced from 32 to 28
                          color: Color(0xFFE74C3C),
                        ),
                        SizedBox(height: 2), // Reduced from 4 to 2
                        Text(
                          '999',
                          style: TextStyle(
                            fontSize: 20, // Reduced from 24 to 20
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFE74C3C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 10), // Reduced spacing from 16 to 10

          const Text(
            'Tap to call emergency services',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunicationTools() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Communication Tools',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C3E50),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildToolButton(
                  'SMS\nLocation',
                  Icons.location_on_outlined,
                  const Color(0xFFFF9500),
                  'Send GPS coordinates via SMS',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildToolButton(
                  'Message\nQueue',
                  Icons.queue_outlined,
                  const Color(0xFF17A2B8),
                  'Store messages for later delivery',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildToolButton(
                  'Voice\nRecorder',
                  Icons.mic_outlined,
                  const Color(0xFF28A745),
                  'Record emergency voice messages',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildToolButton(
                  'Alert\nBeacon',
                  Icons.wifi_tethering_outlined,
                  const Color(0xFF6F42C1),
                  'Broadcast emergency signal',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(String title, IconData icon, Color color, String description) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.construction, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text('$title feature in development')),
              ],
            ),
            backgroundColor: const Color(0xFF34495E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      },
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineFeatures() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Offline Capabilities',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C3E50),
            ),
          ),

          const SizedBox(height: 16),

          _buildOfflineFeatureItem(
            'Offline Maps & Navigation',
            'Access downloaded maps and GPS navigation',
            Icons.map_outlined,
            const Color(0xFF8E44AD),
            true,
          ),

          _buildOfflineFeatureItem(
            'Bluetooth Mesh Network',
            'Connect with nearby devices for communication',
            Icons.bluetooth_connected_outlined,
            const Color(0xFF3498DB),
            false,
          ),

          _buildOfflineFeatureItem(
            'Emergency Contacts Cache',
            'Pre-stored emergency contact information',
            Icons.contacts_outlined,
            const Color(0xFFE67E22),
            true,
          ),

          _buildOfflineFeatureItem(
            'Survival Guide Library',
            'Offline emergency response procedures',
            Icons.library_books_outlined,
            const Color(0xFF27AE60),
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineFeatureItem(
      String title,
      String description,
      IconData icon,
      Color color,
      bool isAvailable,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? const Color(0xFF27AE60).withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isAvailable ? 'Ready' : 'Beta',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isAvailable
                              ? const Color(0xFF27AE60)
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title ${isAvailable ? "ready to use" : "in development"}'),
                  backgroundColor: const Color(0xFF34495E),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}