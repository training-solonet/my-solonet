import 'dart:async'; // Import Timer
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mysolonet/screens/profile/address/add_address_screen.dart';
import 'package:http/http.dart' as http;

class LocationAddressScreen extends StatefulWidget {
  const LocationAddressScreen({super.key});

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
  final bool _isLoading = false; // Variable for debounce timer
  List<Location> _locationSuggestions = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get current location on initialization
  }

  double _calculateDistance(LatLng loc1, LatLng loc2) {
    final double distanceInMeters = Geolocator.distanceBetween(
        loc1.latitude, loc1.longitude, loc2.latitude, loc2.longitude);

    return distanceInMeters / 2000;
  }

  Future<bool> _validateLocation(BuildContext context) async {
    try {
      final double userLat = _markerLocation.latitude;
      final double userLng = _markerLocation.longitude;

      final response = await http.get(
        Uri.parse('https://api.connectis.my.id/bts-location'),
        headers: {'Content-Type': 'application/json'},
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Parsing JSON dengan penanganan yang lebih aman
        final dynamic responseData = jsonDecode(response.body);

        // Validasi struktur response
        if (responseData is! Map) {
          _showErrorDialog(context, "Format respons tidak valid");
          return false;
        }

        // Pengecekan kunci dengan null-aware
        final status = responseData['status'];
        final data = responseData['data'];

        // Validasi status
        if (status != 'success') {
          _showErrorDialog(context, "Validasi lokasi gagal");
          return false;
        }

        // Validasi data
        if (data is! Map) {
          _showErrorDialog(context, "Data lokasi tidak valid");
          return false;
        }

        // Konversi koordinat dengan penanganan yang aman
        final double? referenceLat = _parseDouble(data['latitude']);
        final double? referenceLng = _parseDouble(data['longitude']);

        // Validasi koordinat
        if (referenceLat == null || referenceLng == null) {
          _showErrorDialog(context, "Koordinat referensi tidak valid");
          return false;
        }

        final LatLng userLocation = LatLng(userLat, userLng);
        final LatLng referenceLocation = LatLng(referenceLat, referenceLng);

        double distance = _calculateDistance(userLocation, referenceLocation);

        print("Jarak: $distance km");

        if (distance <= 2.0) {
          return true;
        } else {
          _showLocationOutOfRangeDialog(context);
          return false;
        }
      } else {
        _showErrorDialog(context, "Gagal mengambil data lokasi");
        return false;
      }
    } catch (e) {
      print("Error validasi lokasi: $e");
      _showErrorDialog(context, "Terjadi kesalahan: $e");
      return false;
    }
  }

// Fungsi parsing double yang aman
  double? _parseDouble(dynamic value) {
    if (value == null) return null;

    // Konversi ke string terlebih dahulu
    String strValue = value.toString();

    // Coba parsing
    return double.tryParse(strValue);
  }

// Fungsi dialog terpisah untuk kemudahan
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showLocationOutOfRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Lokasi di Luar Cakupan"),
        content: Text(
            "Lokasi Anda tidak berada dalam cakupan 2 km dari titik referensi."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _searchLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      setState(() {
        _locationSuggestions = locations; // Simpan hasil pencarian
      });
      if (locations.isNotEmpty) {
        final Location location = locations.first;
        final LatLng newLocation =
            LatLng(location.latitude, location.longitude);
        setState(() {
          _markerLocation = newLocation;
          _mapController.move(newLocation, _zoom);
          _updateAddress(newLocation);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lokasi tidak ditemukan")),
        );
      }
    } catch (e) {
      debugPrint("Error while searching location: $e");
    }
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
                      horizontal: 15.0, vertical: 10.0),
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
                              if (_debounce?.isActive ?? false) {
                                _debounce!.cancel();
                              }

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
                          subdomains: const ['a', 'b', 'c'],
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
                  style: const TextStyle(fontFamily: 'Poppins'),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) {
                      _debounce!.cancel();
                    }
                    _debounce = Timer(const Duration(milliseconds: 300), () {
                      if (value.isNotEmpty) {
                        _searchLocation(
                            value); // Panggil fungsi pencarian lokasi
                      } else {
                        setState(() {
                          _locationSuggestions
                              .clear(); // Bersihkan hasil jika input kosong
                        });
                      }
                    });
                  },
                ),
                const SizedBox(height: 8),
                if (_locationSuggestions.isNotEmpty)
                  Container(
                    constraints:
                        const BoxConstraints(maxHeight: 200), // Maksimal tinggi
                    child: ListView.builder(
                      shrinkWrap: true, // Sesuaikan dengan konten
                      itemCount: _locationSuggestions.length,
                      itemBuilder: (context, index) {
                        final location = _locationSuggestions[index];
                        return ListTile(
                          title: Text(
                            '${location.latitude}, ${location.longitude}',
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                          subtitle: FutureBuilder<List<Placemark>>(
                            future: placemarkFromCoordinates(
                                location.latitude, location.longitude),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                final place = snapshot.data!.first;
                                return Text(
                                  '${place.street}, ${place.locality}, ${place.country}',
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                );
                              }
                              return const Text('Loading address...');
                            },
                          ),
                          onTap: () {
                            final LatLng selectedLocation =
                                LatLng(location.latitude, location.longitude);
                            setState(() {
                              _markerLocation = selectedLocation;
                              _mapController.move(selectedLocation, _zoom);
                              _updateAddress(
                                  selectedLocation); // Update address
                              _locationSuggestions.clear(); // Clear suggestions
                            });
                          },
                        );
                      },
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
                  style: const TextStyle(
                      fontFamily: 'Poppins'), // Set text field font
                  maxLines: 2,
                ),

                const SizedBox(height: 16), // Add spacing here

                ElevatedButton(
                  onPressed: () async {
                    bool isValid = await _validateLocation(context);
                    if (isValid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddAddressScreen()),
                      );
                    }
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
