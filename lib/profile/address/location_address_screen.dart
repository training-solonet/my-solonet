import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationAddressScreen extends StatefulWidget {
  @override
  _LocationAddressScreenState createState() => _LocationAddressScreenState();
}

class _LocationAddressScreenState extends State<LocationAddressScreen> {
  LatLng _markerLocation = LatLng(0, 0); 
  double _zoom = 13.0; 
  final MapController _mapController = MapController(); 

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String _currentAddress = ''; // To store current address details

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get current location on initialization
  }

  Future<void> _getCurrentLocation() async {
    // Request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // If permission is denied, request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // If the user denies permission
        return;
      }
    }

    // If permission is granted, get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _markerLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_markerLocation, _zoom); // Move map to current location
      _updateAddress(_markerLocation); // Update address on initialization
    });
  }

  Future<void> _updateAddress(LatLng location) async {
    // Get address details from the location
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    if (placemarks.isNotEmpty) {
      setState(() {
        // Concatenate the complete address
        Placemark place = placemarks.first;
        _currentAddress = '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
        _detailsController.text = _currentAddress; // Fill the TextField with the full address
      });
    }
  }

  Future<void> _goToCurrentLocation() async {
    // Call function to get current location
    await _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your Location', style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0), // Set the border radius here
                    border: Border.all(color: Colors.transparent, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0), // Ensure the corners are rounded
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: _markerLocation,
                        zoom: _zoom,
                        onPositionChanged: (position, hasGesture) {
                          setState(() {
                            if (position.center != null) {
                              _markerLocation = position.center!;
                              _updateAddress(_markerLocation); // Update address when map moves
                            }
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: _markerLocation,
                              builder: (ctx) => const Icon(Icons.location_pin, color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        onPressed: _goToCurrentLocation,
                        child: const Icon(Icons.my_location),
                      ),
                      const SizedBox(height: 18),
                      FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        onPressed: () {
                          setState(() {
                            if (_zoom < 18.0) {
                              _zoom++;
                              _mapController.move(_markerLocation, _zoom);
                            }
                          });
                        },
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 18),
                      FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        onPressed: () {
                          setState(() {
                            if (_zoom > 1.0) {
                              _zoom--;
                              _mapController.move(_markerLocation, _zoom);
                            }
                          });
                        },
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cari Lokasi',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Cari nama jalan, kelurahan, dsb',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontFamily: 'Poppins'), // Set text field font
                  onSubmitted: (value) {
                    // Implement location search here
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alamat Lengkap',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _detailsController,
                  decoration: InputDecoration(
                    labelText: 'Location Now',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontFamily: 'Poppins'), // Set text field font
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
