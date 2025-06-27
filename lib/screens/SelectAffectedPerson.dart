import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectAffectedPerson extends StatefulWidget {
  const SelectAffectedPerson({super.key});

  @override
  State<SelectAffectedPerson> createState() => _SelectAffectedPersonState();
}

class _SelectAffectedPersonState extends State<SelectAffectedPerson> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  bool _isLoading = true;
  Set<Marker> _markers = {};
  MarkerId? _selectedMarkerId;
  bool _selecting = false;

  List<LatLng> _polylineCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
  final String _googleApiKey = 'AIzaSyCKhvSTYJrLl98jq-p8nB2pAae2gE2uuoY'; // Replace with your real key

  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _initLocationFlow();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _initLocationFlow() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      await _getCurrentLocation();
      await _loadAffectedPersons();
      _startLocationTracking();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    final LatLng loc = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocation = loc;
      _markers.add(Marker(
        markerId: const MarkerId("rescuer_location"),
        position: loc,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: "Your Location"),
      ));
    });

    await _updateLiveLocation("rescuer");
  }

  void _startLocationTracking() {
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final position = await Geolocator.getCurrentPosition();
      final LatLng loc = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLocation = loc;
        _markers.removeWhere((m) => m.markerId.value == "rescuer_location");
        _markers.add(Marker(
          markerId: const MarkerId("rescuer_location"),
          position: loc,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: "Your Location"),
        ));
      });
      await _updateLiveLocation("rescuer");
    });
  }

  Future<void> _updateLiveLocation(String role) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _currentLocation == null) return;

    await FirebaseFirestore.instance.collection('live_locations').doc(user.uid).set({
      'uid': user.uid,
      'name': user.displayName ?? 'Rescuer',
      'role': role,
      'latitude': _currentLocation!.latitude,
      'longitude': _currentLocation!.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _loadAffectedPersons() async {
    final snapshot = await FirebaseFirestore.instance.collection('rescue_requests').get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final id = doc.id;

      final marker = Marker(
        markerId: MarkerId(id),
        position: LatLng(data['latitude'], data['longitude']),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: "Affected Person"),
        onTap: _selecting
            ? () {
          _onSelectAffectedPerson(LatLng(data['latitude'], data['longitude']));
          setState(() {
            _selectedMarkerId = MarkerId(id);
          });
        }
            : null,
      );

      _markers.add(marker);

      // Optional: update live_locations for affected
      await FirebaseFirestore.instance.collection('live_locations').doc(id).set({
        'uid': id,
        'name': data['name'] ?? 'Affected',
        'role': 'affected',
        'latitude': data['latitude'],
        'longitude': data['longitude'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    setState(() {});
  }

  Future<void> _onSelectAffectedPerson(LatLng target) async {
    if (_currentLocation == null) return;

    _polylineCoordinates.clear();

    final result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: _googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(_currentLocation!.latitude, _currentLocation!.longitude),
        destination: PointLatLng(target.latitude, target.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      setState(() {
        _polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to draw route.")),
      );
    }
  }

  Future<void> _submitRescueSelection() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _selectedMarkerId == null || _currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select someone.")),
      );
      return;
    }

    final rescuerId = user.uid;
    final affectedId = _selectedMarkerId!.value;

    await FirebaseFirestore.instance.collection('rescue_assignments').add({
      'rescuerId': rescuerId,
      'affectedPersonId': affectedId,
      'status': 'in_progress',
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('rescue_requests').doc(affectedId).update({
      'status': 'in_progress',
    });

    await FirebaseFirestore.instance.collection('rescuers').doc(rescuerId).set({
      'status': 'in_progress',
      'assignedPerson': affectedId,
      'latitude': _currentLocation!.latitude,
      'longitude': _currentLocation!.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _updateLiveLocation("rescuer");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rescue started.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Affected Person"),
        actions: [
          if (_selectedMarkerId != null)
            TextButton.icon(
              onPressed: _submitRescueSelection,
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text("Select", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Stack(
        children: [
          if (_isLoading || _currentLocation == null)
            const Center(child: CircularProgressIndicator())
          else
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: _markers,
              polylines: {
                if (_polylineCoordinates.isNotEmpty)
                  Polyline(
                    polylineId: const PolylineId("route"),
                    color: Colors.blueAccent,
                    width: 6,
                    points: _polylineCoordinates,
                  )
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _selecting = !_selecting;
                  _selectedMarkerId = null;
                  _polylineCoordinates.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_selecting
                        ? "Tap a red marker to select an affected person."
                        : "Selection cancelled."),
                  ),
                );
              },
              label: Text(_selecting ? "Cancel" : "Start Selecting"),
              icon: Icon(_selecting ? Icons.cancel : Icons.touch_app),
            ),
          ),
        ],
      ),
    );
  }
}
