import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Shelter_Locations_Screen extends StatefulWidget {
  const Shelter_Locations_Screen({super.key});

  @override
  State<Shelter_Locations_Screen> createState() => _ShelterLocationsScreenState();
}

class _ShelterLocationsScreenState extends State<Shelter_Locations_Screen> {
  late GoogleMapController _mapController;
  bool _isAddingShelter = false;
  final Set<Marker> _markers = {};
  final List<Map<String, dynamic>> _shelters = [];

  static const LatLng _initialCenter = LatLng(23.777176, 90.399452);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTapped(LatLng position) {
    if (_isAddingShelter) {
      _showAddShelterDialog(position);
    }
  }

  void _showAddShelterDialog(LatLng position) {
    final nameController = TextEditingController();
    final capacityController = TextEditingController();
    final freeSpaceController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Shelter"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Shelter Name"),
              ),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: "Capacity"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: freeSpaceController,
                decoration: const InputDecoration(labelText: "Free Space"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isAddingShelter = false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  capacityController.text.isNotEmpty &&
                  freeSpaceController.text.isNotEmpty) {
                _addShelter(position, nameController.text, capacityController.text, freeSpaceController.text);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields")),
                );
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _addShelter(LatLng position, String name, String capacity, String freeSpace) {
    final id = name + position.toString();

    final marker = Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      onTap: () => _showShelterDetails(id),
    );

    setState(() {
      _markers.add(marker);
      _shelters.add({
        'id': id,
        'name': name,
        'location': position,
        'capacity': capacity,
        'freeSpace': freeSpace,
      });
      _isAddingShelter = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Shelter added!")),
    );
  }

  void _showShelterDetails(String id) {
    final shelter = _shelters.firstWhere((s) => s['id'] == id);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(shelter['name']),
        content: Text(
          "Capacity: ${shelter['capacity']}\n"
              "Free Space: ${shelter['freeSpace']}\n"
              "Location: ${shelter['location']}",
        ),
        actions: [
          TextButton(
            onPressed: () {
              _removeShelter(id);
              Navigator.pop(context);
            },
            child: const Text("Remove Shelter", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _removeShelter(String id) {
    setState(() {
      _shelters.removeWhere((shelter) => shelter['id'] == id);
      _markers.removeWhere((marker) => marker.markerId.value == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Shelter removed!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shelter Locations")),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onTap: _onMapTapped,
            markers: _markers,
            initialCameraPosition: const CameraPosition(
              target: _initialCenter,
              zoom: 13,
            ),
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                setState(() => _isAddingShelter = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tap on map to add a shelter")),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
