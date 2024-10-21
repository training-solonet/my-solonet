import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NearestServiceScreen extends StatefulWidget {
  @override
  _NearestServiceScreenState createState() => _NearestServiceScreenState();
}

class _NearestServiceScreenState extends State<NearestServiceScreen> {
  LatLng _markerLocation = LatLng(0, 0);
  double _zoom = 13.0;
  final MapController _mapController = MapController();
  Timer? _debounce;
  bool _isMapView = true; // State to manage view type

  @override
  void initState() {
    super.initState();
    // Initialize to a default location or implement current location fetch if needed
    _markerLocation = LatLng(-6.200000, 106.816666); // Example: Jakarta
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
            // Back Button
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
            // Help Button
            IconButton(
              icon: const Icon(Icons.help, color: Colors.blueAccent),
              onPressed: () {
                // Show help dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Help"),
                      content: const Text("This is where you can find help."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
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
          // Buttons for view selection styled similarly
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStyledButton("Peta", () {
                setState(() {
                  _isMapView = true; // Show map view
                });
              }, isActive: _isMapView),
              _buildStyledButton("Daftar Posisi", () {
                setState(() {
                  _isMapView = false; // Show list view
                });
              }, isActive: !_isMapView),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              color: Colors.white, // Set background color to white
              child: Stack(
                children: [
                  if (_isMapView) // Show map if map view is selected
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: _markerLocation,
                        zoom: _zoom,
                        rotation: 0,
                        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        onPositionChanged: (position, hasGesture) {
                          setState(() {
                            if (position.center != null) {
                              _markerLocation = position.center!;
                              // Cancel previous timer if exists
                              if (_debounce?.isActive ?? false) _debounce!.cancel();
                              // Set a new timer for 300 ms
                              _debounce = Timer(const Duration(milliseconds: 300), () {
                                // You can update anything needed when the map moves here
                              });
                            }
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                      ],
                    )
                  else // Show list if list view is selected
                    ListView.builder(
                      itemCount: 10, // Example: number of positions
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Posisi ${index + 1}'), // Example position name
                          onTap: () {
                            // Handle position selection
                            print('Selected Posisi ${index + 1}');
                          },
                        );
                      },
                    ),
                  // Show zoom controls only if map view is selected
                  if (_isMapView)
                    Positioned(
                      bottom: 90,
                      right: 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
          ),
        ],
      ),
    );
  }

  // Method to build styled buttons with underline effect
  Widget _buildStyledButton(String title, VoidCallback onPressed, {required bool isActive}) {
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
            width: 50, // Width of the underline
            color: isActive ? Colors.blueAccent : Colors.transparent,
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
