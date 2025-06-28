import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FloodAlertZonesScreen extends StatefulWidget {
  const FloodAlertZonesScreen({super.key});

  @override
  State<FloodAlertZonesScreen> createState() => _FloodAlertZonesScreenState();
}

class _FloodAlertZonesScreenState extends State<FloodAlertZonesScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          setState(() {
            _isLoading = false;
          });
        },
      ))
      ..loadRequest(Uri.parse('https://www.ffwc.gov.bd/app/home'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flood Alert Zones"),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
