import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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

  // TODO: Replace with your actual Google Maps Directions API key
  final String _googleApiKey = 'AIzaSyCKhvSTYJrLl98jq-p8nB2pAae2gE2uuoY';

  @override
  void initState() {
    super.initState();
    _initLocationFlow();
  }

  Future<void> _initLocationFlow() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      await _getCurrentLocation();
      await _loadAffectedPersons();
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
    final position = await Geolocator.getCurrentPosition();
    final rescuerLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocation = rescuerLatLng;
    });

    // Add green marker for rescuer location
    _markers.add(Marker(
      markerId: const MarkerId("rescuer_location"),
      position: rescuerLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: "Your Location"),
    ));

    // Store rescuer location in separate collection
    await FirebaseFirestore.instance.collection('rescuers_locations').add({
      'latitude': rescuerLatLng.latitude,
      'longitude': rescuerLatLng.longitude,
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
    }

    setState(() {});
  }

  Future<void> _onSelectAffectedPerson(LatLng target) async {
    if (_currentLocation == null) return;

    // Clear previous polyline
    _polylineCoordinates.clear();

    final result = await _polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(_currentLocation!.latitude, _currentLocation!.longitude),
        destination: PointLatLng(target.latitude, target.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: _googleApiKey,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Affected Person"),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                _selecting = !_selecting;
                _selectedMarkerId = null;
                _polylineCoordinates.clear();
              });
            },
            icon: const Icon(Icons.touch_app, color: Colors.white),
            label: Text(
              _selecting ? "Cancel" : "Select",
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: _isLoading || _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
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
    );
  }
}
