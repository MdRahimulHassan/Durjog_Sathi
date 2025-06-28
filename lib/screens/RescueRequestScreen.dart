import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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
  List<LatLng> _polylineCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
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
      await _handleRescueRequest();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied")),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final LatLng loc = LatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          _userLocation = loc;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to get location")),
        );
      }
    }
  }

  Future<void> _handleRescueRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _userLocation == null) return;

    final docRef = FirebaseFirestore.instance.collection('rescue_requests').doc(user.uid);
    final docSnapshot = await docRef.get();

    DocumentSnapshot requestDoc;

    if (!docSnapshot.exists) {
      // No existing request, create a new one
      await docRef.set({
        'uid': user.uid,
        'latitude': _userLocation!.latitude,
        'longitude': _userLocation!.longitude,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rescue request sent")),
        );
      }

      requestDoc = await docRef.get();
    } else {
      requestDoc = docSnapshot;
    }

    // Show user location marker
    _rescueMarkers = {
      Marker(
        markerId: const MarkerId('user'),
        position: _userLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'You'),
      ),
    };

    final requestData = requestDoc.data() as Map<String, dynamic>;

    if (requestData['status'] == 'in_progress' && requestData.containsKey('rescuerId')) {
      final rescuerId = requestData['rescuerId'];

      final rescuerDoc = await FirebaseFirestore.instance
          .collection('rescuers')
          .doc(rescuerId)
          .get();

      if (rescuerDoc.exists) {
        final rescuerData = rescuerDoc.data()!;
        final LatLng rescuerLocation = LatLng(
          rescuerData['latitude'],
          rescuerData['longitude'],
        );

        _rescueMarkers.add(
          Marker(
            markerId: MarkerId(rescuerId),
            position: rescuerLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: 'Rescuer'),
          ),
        );

        await _drawRoute(_userLocation!, rescuerLocation);
      }
    }

    if (mounted) setState(() {});
  }

  Future<void> _drawRoute(LatLng from, LatLng to) async {
    final result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: _googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(from.latitude, from.longitude),
        destination: PointLatLng(to.latitude, to.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      if (mounted) {
        setState(() {
          _polylineCoordinates = result.points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to draw route")),
        );
      }
    }
  }

  void _deleteRescueRequest() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('rescue_requests').doc(user.uid).delete();

      if (mounted) {
        setState(() {
          _userLocation = null;
          _rescueMarkers.clear();
          _polylineCoordinates.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rescue request deleted")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting: $e")),
        );
      }
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
        polylines: _polylineCoordinates.isNotEmpty
            ? {
          Polyline(
            polylineId: const PolylineId("route"),
            color: Colors.blue,
            width: 6,
            points: _polylineCoordinates,
          ),
        }
            : {},
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
