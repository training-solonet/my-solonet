import 'dart:async'; // Import Timer
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mysolonet/profile/address/add_address_screen.dart';

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

  Timer? _debounce;
  bool _isLoading = false; // Variable for debounce timer

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
      _mapController.move(
          _markerLocation, _zoom); // Move map to current location
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
        _currentAddress =
            '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
        _detailsController.text =
            _currentAddress; // Fill the TextField with the full address
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
        title: const Text('Set Your Location',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10.0), 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        12.0), // Set the border radius here
                    border: Border.all(color: Colors.transparent, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        15.0), // Ensure the corners are rounded
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: _markerLocation,
                        zoom: _zoom,
                        rotation: 0, // Disable rotation
                        interactiveFlags: InteractiveFlag.all &
                            ~InteractiveFlag.rotate, // Disable map rotation
                        onPositionChanged: (position, hasGesture) {
                          setState(() {
                            if (position.center != null) {
                              _markerLocation = position.center!;

                              // Cancel previous timer if exists
                              if (_debounce?.isActive ?? false)
                                _debounce!.cancel();

                              // Set a new timer for 300 ms
                              _debounce =
                                  Timer(const Duration(milliseconds: 300), () {
                                _updateAddress(
                                    _markerLocation); // Update address after 300 ms
                              });
                            }
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: _markerLocation,
                              builder: (ctx) => const Icon(Icons.location_pin,
                                  color: Colors.red, size: 50),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 70, // Adjusted from 70 to 90
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        backgroundColor: Colors.blue, // Background color
                        onPressed: _goToCurrentLocation,
                        child: const Icon(Icons.my_location,
                            color: Colors.white), // White icon
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        backgroundColor: Colors.blue, // Background color
                        onPressed: () {
                          setState(() {
                            if (_zoom < 18.0) {
                              _zoom++;
                              _mapController.move(_markerLocation, _zoom);
                            }
                          });
                        },
                        child: const Icon(Icons.add,
                            color: Colors.white), // White icon
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        backgroundColor: Colors.blue, // Background color
                        onPressed: () {
                          setState(() {
                            if (_zoom > 1.0) {
                              _zoom--;
                              _mapController.move(_markerLocation, _zoom);
                            }
                          });
                        },
                        child: const Icon(Icons.remove,
                            color: Colors.white), // White icon
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                  style:
                      TextStyle(fontFamily: 'Poppins'), // Set text field font
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                  style:
                      TextStyle(fontFamily: 'Poppins'), // Set text field font
                  maxLines: 2,
                ),

                const SizedBox(height: 16), // Add spacing here

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddAddressScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Set Location",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
