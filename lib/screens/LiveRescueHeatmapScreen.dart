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
  final String _googleApiKey = 'AIzaSyCKhvSTYJrLl98jq-p8nB2pAae2gE2uuoY'; // Replace with your actual Google Maps API key

  StreamSubscription<DocumentSnapshot>? rescuerStream;
  LatLng? rescuerLatLng;
  LatLng? affectedLatLng;

  bool _loading = true;

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

    // Fetch rescue request for this user where status = in_progress
    final requestDoc = await FirebaseFirestore.instance
        .collection('rescue_requests')
        .doc(user.uid)
        .get();

    if (!requestDoc.exists) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No active rescue request found.")),
        );
      }
      setState(() => _loading = false);
      return;
    }

    final request = requestDoc.data();
    if (request == null || request['status'] != 'in_progress') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rescue request not in progress.")),
        );
      }
      setState(() => _loading = false);
      return;
    }

    final rescuerId = request['rescuerId'];
    if (rescuerId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No rescuer assigned yet.")),
        );
      }
      setState(() => _loading = false);
      return;
    }

    // Load affected person's location once
    final affectedDoc = await FirebaseFirestore.instance
        .collection('live_locations')
        .doc(user.uid)
        .get();

    if (!affectedDoc.exists) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Your location not found.")),
        );
      }
      setState(() => _loading = false);
      return;
    }

    affectedLatLng = LatLng(
      affectedDoc['latitude'],
      affectedDoc['longitude'],
    );

    // Listen to rescuer location live updates
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

      await _drawRoute(rescuerPos, affectedLatLng!);
      setState(() => _loading = false);
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
        rescuer.latitude < affected.latitude ? rescuer.latitude : affected.latitude,
        rescuer.longitude < affected.longitude ? rescuer.longitude : affected.longitude,
      ),
      northeast: LatLng(
        rescuer.latitude > affected.latitude ? rescuer.latitude : affected.latitude,
        rescuer.longitude > affected.longitude ? rescuer.longitude : affected.longitude,
      ),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Rescue Tracker")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: affectedLatLng ?? const LatLng(23.777176, 90.399452), // Dhaka default
          zoom: 13,
        ),
        markers: _markers,
        polylines: {
          if (_polylineCoords.isNotEmpty)
            Polyline(
              polylineId: const PolylineId("route"),
              points: _polylineCoords,
              color: Colors.blue,
              width: 6,
            ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
