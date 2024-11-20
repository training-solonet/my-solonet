import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class CoverageArea extends StatefulWidget {
  final LatLng? userLocation;
  final bool permissionGranted;
  final bool locationFetched;
  final double initialZoom;
  final MapController mapController;

  CoverageArea({
    super.key,
    required this.userLocation,
    required this.permissionGranted,
    required this.locationFetched,
    required this.initialZoom,
    required this.mapController,
  });

  @override
  _CoverageAreaState createState() => _CoverageAreaState();
}

class _CoverageAreaState extends State<CoverageArea> {
  List<LatLng> _btsLocations = []; // To store BTS locations
  double _radiusMeters = 2000; // Coverage radius in meters
  late MapController _mapController;
  late bool _locationFetched;
  late LatLng? _userLocation;
  late bool _permissionGranted;
  late double _currentZoom;

  @override
  void initState() {
    super.initState();
    _mapController = widget.mapController;
    _locationFetched = widget.locationFetched;
    _permissionGranted = widget.permissionGranted;
    _userLocation = widget.userLocation;
    _currentZoom = widget.initialZoom;

    _fetchBtsLocations();
  }

  // Fetch BTS locations from the API
  Future<void> _fetchBtsLocations() async {
    final url = 'https://api.connectis.my.id/bts-location'; // API URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<LatLng> locations = [];

        // Parse the locations from the response
        for (var location in data) {
          locations.add(LatLng(
              double.parse(location['lat']), double.parse(location['lang'])));
        }

        setState(() {
          _btsLocations = locations;
        });

        if (_btsLocations.isNotEmpty && _userLocation != null) {
          // Center map on the user's location if it's fetched, else on the first BTS location
          _mapController.move(_userLocation!, _currentZoom);
        }
      } else {
        print('Failed to load BTS locations: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching BTS locations: $e');
    }
  }

  // Calculate pixel radius based on zoom level and latitude
  double _calculatePixelRadius(double meters, double latitude, double zoom) {
    const double earthCircumference =
        40075016.686; // Earth's circumference in meters
    double metersPerPixel = earthCircumference *
        cos(latitude * pi / 180) / pow(2, zoom + 8); // Conversion formula
    return meters / metersPerPixel; // Convert meters to pixels
  }

  // Function to move map to user's location
  void _goToUserLocation() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, _currentZoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while waiting for the user's location
    if (!_permissionGranted || !_locationFetched) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: 300, // Set height of the map
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              // Ensure the map centers on the user's location once it's fetched
              center: _userLocation ?? LatLng(0, 0), // Fallback to (0, 0) if user location is null
              zoom: _currentZoom,
              interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              maxZoom: 18.0,
              minZoom: 10.0,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _currentZoom = position.zoom ?? _currentZoom;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  if (_userLocation != null)
                    Marker(
                      point: _userLocation!,
                      builder: (ctx) => Icon(
                        Icons.person_pin_circle, // Use location pin icon
                        color: Colors.blue, // Set the color to blue
                        size: 30.0, // Adjust size of the icon
                      ),
                    ),
                ],
              ),
              CircleLayer(
                circles: _btsLocations.map((location) {
                  return CircleMarker(
                    point: location,
                    borderColor: Colors.blueAccent.withOpacity(0.3),
                    borderStrokeWidth: 0.5,
                    color: Colors.blueAccent.withOpacity(0.3),
                    radius: _calculatePixelRadius(
                      _radiusMeters,
                      location.latitude,
                      _currentZoom,
                    ), // Set radius for each BTS location
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // My Location button above zoom-in button
              FloatingActionButton(
                onPressed: _goToUserLocation,
                backgroundColor: Colors.black54, // Transparent background
                foregroundColor: Colors.white, // Blue accent icon
                elevation: 0, // Remove the shadow
                child: Icon(Icons.my_location), // Using the my_location icon
                mini: true,
              ),
              SizedBox(height: 10),
              // Zoom-in button
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _currentZoom = (_currentZoom + 1).clamp(10.0, 18.0);
                    _mapController.move(_mapController.center, _currentZoom);
                  });
                },
                backgroundColor: Colors.black54, // Transparent background
                foregroundColor: Colors.white, // Blue accent icon
                elevation: 0, // Remove the shadow
                child: Icon(Icons.zoom_in),
                mini: true,
              ),
              SizedBox(height: 10),
              // Zoom-out button
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _currentZoom = (_currentZoom - 1).clamp(10.0, 18.0);
                    _mapController.move(_mapController.center, _currentZoom);
                  });
                },
                backgroundColor: Colors.black54, // Transparent background
                foregroundColor: Colors.white, // Blue accent icon
                elevation: 0, // Remove the shadow
                child: Icon(Icons.zoom_out),
                mini: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
