import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class CoverageArea extends StatefulWidget {
  @override
  _CoverageAreaState createState() => _CoverageAreaState();
}

class _CoverageAreaState extends State<CoverageArea> {
  LatLng? _userLocation; // Use nullable type to ensure it's uninitialized initially
  double _currentZoom = 13.0;
  final MapController _mapController = MapController();
  bool _permissionGranted = false;

  // Coordinates for Surakarta (Solo)
  final LatLng _surakartaLocation = LatLng(-7.5667, 110.8231);
  double _radiusMeters = 1000; // 1 km radius

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      setState(() {
        _permissionGranted = true;
      });
      await _getCurrentLocation();
    } else {
      print('Permission denied');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(_userLocation!, _currentZoom);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  double _calculatePixelRadius(double meters, double latitude, double zoom) {
    const double earthCircumference = 40075016.686; // Earth's circumference in meters
    double metersPerPixel = earthCircumference * cos(latitude * pi / 180) / 
        pow(2, zoom + 8); // Conversion formula
    return meters / metersPerPixel; // Convert meters to pixels
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionGranted || _userLocation == null) {
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
              center: _userLocation ?? _surakartaLocation,
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
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _surakartaLocation,
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2.0,
                    color: Colors.blue.withOpacity(0.2),
                    radius: _calculatePixelRadius(
                      _radiusMeters,
                      _surakartaLocation.latitude,
                      _currentZoom,
                    ), // Use dynamically calculated pixel radius
                  ),
                ],
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
