import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LiveRescueHeatmapScreen extends StatefulWidget {
  const LiveRescueHeatmapScreen({super.key});

  @override
  State<LiveRescueHeatmapScreen> createState() => _LiveRescueHeatmapScreenState();
}

class _LiveRescueHeatmapScreenState extends State<LiveRescueHeatmapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  List<LatLng> _polylineCoords = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
  final String _googleApiKey = 'YOUR_GOOGLE_API_KEY'; // Replace with real key

  StreamSubscription<DocumentSnapshot>? rescuerStream;
  LatLng? rescuerLatLng;
  LatLng? affectedLatLng;

  @override
  void initState() {
    super.initState();
    _initLiveTracking();
  }

  @override
  void dispose() {
    rescuerStream?.cancel();
    super.dispose();
  }

  Future<void> _initLiveTracking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final assignmentSnap = await FirebaseFirestore.instance
        .collection('rescue_assignments')
        .where('affectedPersonId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'in_progress')
        .get();

    if (assignmentSnap.docs.isEmpty) return;

    final assignment = assignmentSnap.docs.first.data();
    final rescuerId = assignment['rescuerId'];

    // Listen for rescuer location updates
    rescuerStream = FirebaseFirestore.instance
        .collection('live_locations')
        .doc(rescuerId)
        .snapshots()
        .listen((rescuerDoc) async {
      if (!rescuerDoc.exists) return;

      final rescuerPos = LatLng(
        rescuerDoc['latitude'],
        rescuerDoc['longitude'],
      );

      // Load affected location once
      if (affectedLatLng == null) {
        final affectedDoc = await FirebaseFirestore.instance
            .collection('live_locations')
            .doc(user.uid)
            .get();

        if (!affectedDoc.exists) return;

        affectedLatLng = LatLng(
          affectedDoc['latitude'],
          affectedDoc['longitude'],
        );
      }

      // Update route and markers
      await _drawRoute(rescuerPos, affectedLatLng!);
    });
  }

  Future<void> _drawRoute(LatLng rescuer, LatLng affected) async {
    final result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: _googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(rescuer.latitude, rescuer.longitude),
        destination: PointLatLng(affected.latitude, affected.longitude),
        mode: TravelMode.driving,
      ),
    );

    final newRoute = result.points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    final markers = {
      Marker(
        markerId: const MarkerId("rescuer"),
        position: rescuer,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: "Rescuer"),
      ),
      Marker(
        markerId: const MarkerId("affected"),
        position: affected,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: "You"),
      ),
    };

    setState(() {
      rescuerLatLng = rescuer;
      _markers = markers;
      _polylineCoords = newRoute;
    });

    _moveCamera(rescuer, affected);
  }

  void _moveCamera(LatLng rescuer, LatLng affected) {
    final bounds = LatLngBounds(
      southwest: LatLng(
        (rescuer.latitude < affected.latitude)
            ? rescuer.latitude
            : affected.latitude,
        (rescuer.longitude < affected.longitude)
            ? rescuer.longitude
            : affected.longitude,
      ),
      northeast: LatLng(
        (rescuer.latitude > affected.latitude)
            ? rescuer.latitude
            : affected.latitude,
        (rescuer.longitude > affected.longitude)
            ? rescuer.longitude
            : affected.longitude,
      ),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Rescue Tracker")),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: const CameraPosition(
          target: LatLng(23.777176, 90.399452),
          zoom: 12,
        ),
        markers: _markers,
        polylines: {
          if (_polylineCoords.isNotEmpty)
            Polyline(
              polylineId: const PolylineId("route"),
              points: _polylineCoords,
              color: Colors.blue,
              width: 6,
            )
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
