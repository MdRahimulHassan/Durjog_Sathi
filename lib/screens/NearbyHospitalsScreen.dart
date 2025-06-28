import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class NearbyHospitalsScreen extends StatefulWidget {
  const NearbyHospitalsScreen({super.key});

  @override
  State<NearbyHospitalsScreen> createState() => _NearbyHospitalsScreenState();
}

class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
  LatLng? _userLocation;
  GoogleMapController? _mapController;
  bool _isLoading = true;
  Set<Marker> _markers = {};
  BitmapDescriptor? _hospitalIcon;

  final String _googleApiKey = 'AIzaSyCKhvSTYJrLl98jq-p8nB2pAae2gE2uuoY'; // Replace with your API key

  @override
  void initState() {
    super.initState();
    _initCustomAndLocation();
  }

  Future<void> _initCustomAndLocation() async {
    _hospitalIcon = await createCustomMarkerBitmap();
    await _initLocationFlow();
  }

  Future<void> _initLocationFlow() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      await _getUserLocation();
      await _fetchNearbyHospitals();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getUserLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });

    _markers.add(Marker(
      markerId: const MarkerId('user_location'),
      position: _userLocation!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Your Location'),
    ));
  }

  Future<void> _fetchNearbyHospitals() async {
    if (_userLocation == null) return;

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${_userLocation!.latitude},${_userLocation!.longitude}'
        '&radius=20000'
        '&type=hospital'
        '&key=$_googleApiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      for (var place in data['results']) {
        final lat = place['geometry']['location']['lat'];
        final lng = place['geometry']['location']['lng'];
        final name = place['name'];

        _markers.add(
          Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(lat, lng),
            icon: _hospitalIcon!,
            infoWindow: InfoWindow(title: name),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load hospitals: ${data['status']}")),
      );
    }

    setState(() {});
  }

  Future<BitmapDescriptor> createCustomMarkerBitmap() async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    const double size = 70;

    final Paint paint = Paint()..color = Colors.red;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);

    final TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: '+',
        style: TextStyle(
          fontSize: 90,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    final ui.Image img = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Hospitals")),
      body: _isLoading || _userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _userLocation!,
          zoom: 13,
        ),
        markers: _markers,
        onMapCreated: (controller) => _mapController = controller,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
