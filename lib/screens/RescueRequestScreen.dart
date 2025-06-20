import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class RescueRequestScreen extends StatefulWidget {
  const RescueRequestScreen({super.key});

  @override
  State<RescueRequestScreen> createState() => _RescueRequestScreenState();
}

class _RescueRequestScreenState extends State<RescueRequestScreen> {
  LatLng? _userLocation;
  GoogleMapController? _mapController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initLocationFlow();
  }

  Future<void> _initLocationFlow() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      await _getCurrentLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to get location")),
      );
    }
  }

  void _deleteRescueRequest() {
    setState(() {
      _userLocation = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rescue request deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Rescue')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userLocation == null
          ? const Center(child: Text("No rescue request active."))
          : GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: _userLocation!,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("rescue_location"),
            position: _userLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: _userLocation != null && !_isLoading
          ? SizedBox(
        height: 45,
        child: FloatingActionButton.extended(
          onPressed: _deleteRescueRequest,
          label: const Text("Delete", style: TextStyle(fontSize: 14)),
          icon: const Icon(Icons.delete, size: 18),
          backgroundColor: Colors.redAccent,
        ),
      )
          : null,
    );
  }
}
