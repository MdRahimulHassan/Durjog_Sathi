import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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
  final String _googleApiKey = 'AIzaSyCKhvSTYJrLl98jq-p8nB2pAae2gE2uuoY';

  LatLng? _currentLatLng;
  final LatLng _destinationLatLng = LatLng(23.7772, 90.3995);

  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) return;

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(distanceFilter: 10),
    ).listen((Position position) {
      final currentPos = LatLng(position.latitude, position.longitude);
      _drawRoute(currentPos, _destinationLatLng);
    });
  }

  Future<void> _drawRoute(LatLng origin, LatLng destination) async {
    final result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: _googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(origin.latitude, origin.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isEmpty) return;

    final newRoute = result.points.map((point) => LatLng(point.latitude, point.longitude)).toList();

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId("origin"),
        position: origin,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: "Your Location"),
      ),
      Marker(
        markerId: const MarkerId("destination"),
        position: destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: "Target Location"),
      ),
    };

    // Add 10 nearby "rescuer" markers around Dhaka
    final List<LatLng> rescuerLocations = [
      LatLng(23.7801, 90.4005),
      LatLng(23.7792, 90.3983),
      LatLng(23.7785, 90.4021),
      LatLng(23.7777, 90.3970),
      LatLng(23.7769, 90.4010),
      LatLng(23.7758, 90.4001),
      LatLng(23.7799, 90.3967),
      LatLng(23.7810, 90.3999),
      LatLng(23.7780, 90.4032),
      LatLng(23.7770, 90.3955),
    ];

    for (int i = 0; i < rescuerLocations.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId("rescuer_$i"),
          position: rescuerLocations[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: "Rescuer ${i + 1}"),
        ),
      );
    }

    setState(() {
      _currentLatLng = origin;
      _markers = markers;
      _polylineCoords = newRoute;
    });

    _moveCamera(origin, destination);
  }

  void _moveCamera(LatLng origin, LatLng destination) {
    final bounds = LatLngBounds(
      southwest: LatLng(
        origin.latitude < destination.latitude ? origin.latitude : destination.latitude,
        origin.longitude < destination.longitude ? origin.longitude : destination.longitude,
      ),
      northeast: LatLng(
        origin.latitude > destination.latitude ? origin.latitude : destination.latitude,
        origin.longitude > destination.longitude ? origin.longitude : destination.longitude,
      ),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Navigation to Target")),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: _currentLatLng ?? const LatLng(23.777176, 90.399452),
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
