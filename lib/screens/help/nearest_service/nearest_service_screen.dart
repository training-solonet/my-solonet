import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class NearestServiceScreen extends StatefulWidget {
  @override
  _NearestServiceScreenState createState() => _NearestServiceScreenState();
}

class _NearestServiceScreenState extends State<NearestServiceScreen> {
  LatLng _userLocation = LatLng(0, 0);
  LatLng _selectedLocation = LatLng(0, 0);
  double _currentZoom = 11.0;
  final MapController _mapController = MapController();
  List<NearbyLocation> _nearbyLocations = [];

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
      await _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _userLocation;
        _mapController.move(_userLocation, _currentZoom);
      });
      await _fetchNearbyLocations(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchNearbyLocations(double latitude, double longitude) async {
    final url = 'https://api.connectis.my.id/nearLocation';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'lat': latitude.toString(), 'long': longitude.toString()}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<NearbyLocation> locations = [];

      for (var location in data) {
        final loc = NearbyLocation(
          name: location['name'],
          distance: double.parse(location['distance']),
          latitude: double.parse(location['lat']),
          longitude: double.parse(location['long']),
        );

        loc.address = await _getAddressFromLatLng(loc.latitude, loc.longitude);
        locations.add(loc);
      }

      setState(() {
        _nearbyLocations = locations;
        _nearbyLocations.sort((a, b) => a.distance.compareTo(b.distance));
      });
    } else {
      print('Failed to load nearby locations: ${response.reasonPhrase}');
    }
  }

  Future<String> _getAddressFromLatLng(
      double latitude, double longitude) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['display_name'] ?? 'Unknown location';
      } else {
        return 'Address not found';
      }
    } catch (e) {
      print('Error during reverse geocoding: $e');
      return 'Error fetching address';
    }
  }

  void _zoomIn() {
    setState(() {
      if (_currentZoom < 18) {
        _currentZoom++;
        _mapController.move(_mapController.center, _currentZoom);
      }
    });
  }

  void _zoomOut() {
    setState(() {
      if (_currentZoom > 3) {
        _currentZoom--;
        _mapController.move(_mapController.center, _currentZoom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        title: const Text(
          'Lokasi Solonet Terdekat',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _userLocation,
              zoom: _currentZoom,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              onPositionChanged: (MapPosition position, bool hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _currentZoom = position.zoom ?? _currentZoom;
                  });
                }
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
                    point: _userLocation,
                    builder: (ctx) => const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blueAccent,
                      size: 40,
                    ),
                  ),
                  ..._nearbyLocations.map((location) {
                    return Marker(
                      point: LatLng(location.latitude, location.longitude),
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
          Positioned(
            top: 540,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  mini: true,
                  backgroundColor: Colors.black54, // Black background with opacity
                  foregroundColor: Colors.white, // White icon color
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  mini: true,
                  backgroundColor: Colors.black54, // Black background with opacity
                  foregroundColor: Colors.white, // White icon color
                  child: const Icon(Icons.zoom_out),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  mini: true,
                  backgroundColor: Colors.black54, // Black background with opacity
                  foregroundColor: Colors.white, // White icon color
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: _nearbyLocations.isNotEmpty
                ? Container(
                    height: 130,
                    child: PageView.builder(
                      itemCount: _nearbyLocations.length,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedLocation = LatLng(
                              _nearbyLocations[index].latitude,
                              _nearbyLocations[index].longitude);
                        });
                        _mapController.move(_selectedLocation, _currentZoom);
                      },
                      itemBuilder: (context, index) {
                        final location = _nearbyLocations[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${location.name} (${location.distance.toStringAsFixed(2)} km)',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    location.address ?? 'Loading...',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

class NearbyLocation {
  final String name;
  final double distance;
  final double latitude;
  final double longitude;
  String? address;

  NearbyLocation({
    required this.name,
    required this.distance,
    required this.latitude,
    required this.longitude,
    this.address,
  });
}
