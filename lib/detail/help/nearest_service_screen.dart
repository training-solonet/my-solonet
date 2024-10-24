import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class NearestServiceScreen extends StatefulWidget {
  @override
  _NearestServiceScreenState createState() => _NearestServiceScreenState();
}

class _NearestServiceScreenState extends State<NearestServiceScreen> {
  LatLng _markerLocation = LatLng(0, 0);
  double _zoom = 13.0;
  final MapController _mapController = MapController();
  Timer? _debounce;
  bool _isMapView = true;
  List<NearbyLocation> _nearbyLocations = [];

  @override
  void initState() {
    super.initState();
    _markerLocation = LatLng(-6.200000, 106.816666); // Example: Jakarta
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
        _markerLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(_markerLocation, _zoom);
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
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'lat': latitude.toString(),
        'long': longitude.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _nearbyLocations = data.map((location) {
          return NearbyLocation(
            name: location['name'],
            distance: double.parse(location['distance']),
            latitude: latitude, // Set latitude
            longitude: longitude, // Set longitude
          );
        }).toList();

        // Sort the locations by distance
        _nearbyLocations.sort((a, b) => a.distance.compareTo(b.distance));
      });
    } else {
      print('Failed to load nearby locations: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.help, color: Colors.blueAccent),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Help"),
                      content: const Text("This is where you can find help."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(32.5, 10.0, 0, 30),
            alignment: Alignment.topLeft,
            child: Text(
              'Lokasi Solonet Terdekat',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStyledButton("Peta", () {
                setState(() {
                  _isMapView = true;
                });
              }, isActive: _isMapView),
              _buildStyledButton("Daftar Posisi", () {
                setState(() {
                  _isMapView = false;
                });
              }, isActive: !_isMapView),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                if (_isMapView)
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: _markerLocation,
                      zoom: _zoom,
                      rotation: 0,
                      interactiveFlags:
                          InteractiveFlag.all & ~InteractiveFlag.rotate,
                      onPositionChanged: (position, hasGesture) {
                        setState(() {
                          if (position.center != null) {
                            _markerLocation = position.center!;
                            if (_debounce?.isActive ?? false)
                              _debounce!.cancel();
                            _debounce =
                                Timer(const Duration(milliseconds: 300), () {
                              // Additional map-related updates can be done here.
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
                            point: _markerLocation,
                            builder: (ctx) => const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  _nearbyLocations.isEmpty
                      ? Center(child: Text("No nearby locations found."))
                      : ListView.builder(
                          itemCount: _nearbyLocations.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: ListTile(
                                title: Text(_nearbyLocations[index].name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${_nearbyLocations[index].distance} meters'),
                                  ],
                                ),
                                onTap: () {
                                  print(
                                      'Selected: ${_nearbyLocations[index].name}');
                                },
                              ),
                            );
                          },
                        ),
                if (_isMapView)
                  Positioned(
                    bottom: 160,
                    right: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          heroTag: 'my_location',
                          mini: true,
                          backgroundColor: Colors.blue,
                          onPressed: _goToMyLocation,
                          child: const Icon(Icons.my_location,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton(
                          heroTag: null,
                          mini: true,
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            setState(() {
                              if (_zoom < 18.0) {
                                _zoom++;
                                _mapController.move(_markerLocation, _zoom);
                              }
                            });
                          },
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton(
                          heroTag: null,
                          mini: true,
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            setState(() {
                              if (_zoom > 1.0) {
                                _zoom--;
                                _mapController.move(_markerLocation, _zoom);
                              }
                            });
                          },
                          child: const Icon(Icons.remove, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledButton(String title, VoidCallback onPressed,
      {required bool isActive}) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.blueAccent : Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 50,
            color: isActive ? Colors.blueAccent : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Future<void> _goToMyLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

class NearbyLocation {
  final String name;
  final double distance;
  final double latitude;
  final double longitude;

  NearbyLocation({
    required this.name,
    required this.distance,
    required this.latitude,
    required this.longitude,
  });

  factory NearbyLocation.fromJson(Map<String, dynamic> json) {
    return NearbyLocation(
      name: json['name'] as String,
      distance: (json['distance'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
