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
  LatLng _markerLocation = LatLng(0,
      0); // Initially set to 0,0, which will be updated with the real location
  double _zoom = 13.0;
  final MapController _mapController = MapController();
  bool _isMapView = true;
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
      List<NearbyLocation> locations = [];

      for (var location in data) {
        final loc = NearbyLocation(
          name: location['name'],
          distance: double.parse(location['distance']),
          latitude: latitude,
          longitude: longitude,
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

  int _selectedLocationIndex = 0;

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
              _buildStyledButton("Petaa", () {
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
                          if (position.center != null) {}
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
                          // Marker untuk lokasi pengguna
                          Marker(
                            point: _markerLocation,
                            builder: (ctx) => const Icon(
                              Icons.person_pin_circle_sharp,
                              color: Colors.blueAccent,
                              size: 40,
                            ),
                          ),
                                 //Marker untuk lokasi terdekat yang dipilih
                          if (_nearbyLocations.isNotEmpty)
                            Marker(
                              point: LatLng(
                                _nearbyLocations[_selectedLocationIndex]
                                    .latitude,
                                _nearbyLocations[_selectedLocationIndex]
                                    .longitude,
                              ),
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
                              shadowColor: Colors.black,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  _nearbyLocations[index].name,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_nearbyLocations[index].distance} Km',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
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
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 150,
                      child: PageView.builder(
                          controller: PageController(
                            viewportFraction: 0.9,
                          ),
                          itemCount: _nearbyLocations.length,
                          onPageChanged: (index) {
                            setState(() {
                              _selectedLocationIndex = index;
                              _markerLocation = LatLng(
                                _nearbyLocations[_selectedLocationIndex]
                                    .latitude,
                                _nearbyLocations[_selectedLocationIndex]
                                    .longitude,
                              );
                              _mapController.move(_markerLocation, _zoom);
                            });
                          },
                          itemBuilder: (context, index) {
                            final location = _nearbyLocations[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  width: 400,
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      location.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        color: Colors.blue,
                                      ),
                                    ),
                                    subtitle: Text(
                                      location.address ??
                                          'Address not available',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        color: Colors.grey,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedLocationIndex =
                                            index; // Update selected index
                                        _markerLocation = LatLng(
                                          _nearbyLocations[
                                                  _selectedLocationIndex]
                                              .latitude,
                                          _nearbyLocations[
                                                  _selectedLocationIndex]
                                              .longitude,
                                        );
                                        _mapController.move(
                                            _markerLocation, _zoom);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
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

  factory NearbyLocation.fromJson(Map<String, dynamic> json) {
    return NearbyLocation(
      name: json['name'] as String,
      distance: (json['distance'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class CardItem {
  final String text;

  CardItem({required this.text});
}
