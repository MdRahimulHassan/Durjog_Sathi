import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FloodAlertZonesScreen extends StatefulWidget {
  const FloodAlertZonesScreen({super.key});

  @override
  _FloodAlertZonesScreenState createState() => _FloodAlertZonesScreenState();
}

class _FloodAlertZonesScreenState extends State<FloodAlertZonesScreen> {
  @override
  void initState() {
    super.initState();
    _launchFloodAlertWebsite();
  }

  void _launchFloodAlertWebsite() async {
    final Uri url = Uri.parse('https://www.ffwc.gov.bd/app/home');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      // Optionally close the screen after launching URL:
      // Navigator.of(context).pop();
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flood Alert Zones"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text("Opening flood alert website..."),
      ),
    );
  }
}