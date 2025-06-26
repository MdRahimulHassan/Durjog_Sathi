import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RescueRequestScreen extends StatefulWidget {
  const RescueRequestScreen({super.key});

  @override
  State<RescueRequestScreen> createState() => _RescueRequestScreenState();
}

class _RescueRequestScreenState extends State<RescueRequestScreen> {
  LatLng? _userLocation;
  GoogleMapController? _mapController;
  bool _isLoading = true;
  Set<Marker> _rescueMarkers = {};

  @override
  void initState() {
    super.initState();
    _initLocationFlow();
  }

  Future<void> _initLocationFlow() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      await _getCurrentLocation();
      await _fetchRescueRequests();
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
      final LatLng loc = LatLng(position.latitude, position.longitude);

      setState(() {
        _userLocation = loc;
      });

      await FirebaseFirestore.instance.collection('rescue_requests').add({
        'latitude': loc.latitude,
        'longitude': loc.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rescue request sent")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to get location")),
      );
    }
  }

  Future<void> _fetchRescueRequests() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('rescue_requests').get();

    final markers = snapshot.docs.map((doc) {
      final data = doc.data();
      return Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(data['latitude'], data['longitude']),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    }).toSet();

    setState(() {
      _rescueMarkers = markers;
    });
  }

  void _deleteRescueRequest() async {
    try {
      // Find the user's marker and delete it
      final snapshot = await FirebaseFirestore.instance
          .collection('rescue_requests')
          .where('latitude', isEqualTo: _userLocation?.latitude)
          .where('longitude', isEqualTo: _userLocation?.longitude)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        _userLocation = null;
        _rescueMarkers.removeWhere((marker) =>
        marker.position.latitude == _userLocation?.latitude &&
            marker.position.longitude == _userLocation?.longitude);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rescue request deleted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting: $e")),
      );
    }
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
        markers: _rescueMarkers,
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
