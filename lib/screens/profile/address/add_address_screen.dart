import 'package:flutter/material.dart';
import 'package:mysolonet/screens/home/home_screen.dart';
import 'package:mysolonet/widgets/alert/confirm_popup.dart';
import 'package:mysolonet/screens/auth/service/service.dart';
import 'package:mysolonet/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mysolonet/widgets/alert/show_message_failed.dart';
import 'package:mysolonet/widgets/alert/show_message_success.dart';

class AddAddressScreen extends StatefulWidget {
  final double lat;
  final double long;
  final String address;

  const AddAddressScreen(
      {super.key,
      required this.lat,
      required this.long,
      required this.address});

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedSubdistrict;

  int? _selectedProvinceId;
  int? _selectedCityId;
  int? _selectedDistrictId;
  int? _selectedSubdistrictId;

  bool _isLoading = false;

  List<Map<String, dynamic>> _provinces = [];
  List<String> _provinceNames = [];

  List<Map<String, dynamic>> _cities = [];
  List<String> _citiesNames = [];

  List<Map<String, dynamic>> _districts = [];
  List<String> _districtsNames = [];

  List<Map<String, dynamic>> _subdistricts = [];
  List<String> _subdistrictsNames = [];

  Future<void> _getProvinces() async {
    final url = Uri.parse('$baseUrl/provinsi');
    final authService = AuthService();
    final token = await authService.getToken();

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _provinces = List<Map<String, dynamic>>.from(data);
          _provinceNames =
              _provinces.map((e) => e['name'] as String).toSet().toList();
        });
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getCity() async {
    final url = Uri.parse('$baseUrl/kabupaten/$_selectedProvinceId');
    final authService = AuthService();
    final token = await authService.getToken();

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _cities = List<Map<String, dynamic>>.from(data);
          _citiesNames =
              _cities.map((e) => e['name'] as String).toSet().toList();
        });
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getDistrict() async {
    final url = Uri.parse('$baseUrl/kecamatan/$_selectedCityId');
    final authService = AuthService();
    final token = await authService.getToken();

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _districts = List<Map<String, dynamic>>.from(data);
          _districtsNames =
              _districts.map((e) => e['name'] as String).toSet().toList();
        });
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getSubDistrict() async {
    final url = Uri.parse('$baseUrl/kelurahan/$_selectedDistrictId');
    final authService = AuthService();
    final token = await authService.getToken();

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _subdistricts = List<Map<String, dynamic>>.from(data);
          _subdistrictsNames =
              _subdistricts.map((e) => e['name'] as String).toSet().toList();
        });
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _saveAddress(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      final token = await authService.getToken();

      final url = Uri.parse('$baseUrl/add-address');
      final body = {
        "nama": _nameController.text,
        "nik": _nikController.text,
        "provinsi_id": _selectedProvinceId,
        "kabupaten_id": _selectedCityId,
        "kecamatan_id": _selectedDistrictId,
        "kelurahan_id": _selectedSubdistrictId,
        "alamat": widget.address,
        "lat": widget.lat,
        "long": widget.long,
      };
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response =
          await http.post(url, headers: headers, body: json.encode(body));
        print(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);

        if (responseData['message'] == "Success") {
          showSuccessMessage(context, "Address saved successfully.");
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false, 
          );
        } else {
          showFailedMessage(
              context, responseData['error'] ?? "Failed to save address.");
        }
      } else {
        showFailedMessage(context, "Server error: ${response.statusCode}");
      }
    } catch (e) {
      showFailedMessage(context, "Failed to save address, please try again.");
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Tambah Alamat",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  _buildLabel("Nama"),
                  const SizedBox(height: 6.5),
                  _buildTextField(_nameController, 'Masukkan Nama Alamat..',
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Alamat tidak boleh kosong';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16.0),
                  _buildLabel("NIK"),
                  const SizedBox(height: 6.5),
                  _buildTextField(
                    _nikController,
                    'Masukkan NIK Anda..',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'NIK tidak boleh kosong';
                      } else if (value.length != 16) {
                        return 'NIK harus 16 digit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _buildLabel("Provinsi"),
                  const SizedBox(height: 6.5),
                  _buildDropdown(
                      _provinceNames, _selectedProvince, 'Pilih Provinsi',
                      (value) {
                    setState(() {
                      _selectedProvince = value;
                      _selectedCity = null;
                      _selectedDistrict = null;
                      _selectedSubdistrict = null;

                      _selectedProvinceId = _provinces.firstWhere(
                        (province) => province['name'] == _selectedProvince,
                        orElse: () => {'id': null},
                      )['id'] as int?;

                      _selectedCityId = null;
                      _selectedDistrictId = null;
                      _selectedSubdistrictId = null;

                      _getCity();
                    });
                  }, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pilih provinsi terlebih dahulu';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16.0),
                  _buildLabel("Kabupaten/Kota"),
                  const SizedBox(height: 6.5),
                  _buildDropdown(_selectedProvince != null ? _citiesNames : [],
                      _selectedCity, 'Pilih Kabupaten/Kota', (value) {
                    setState(() {
                      _selectedCity = value;
                      _selectedDistrict = null;
                      _selectedSubdistrict = null;

                      _selectedCityId = _cities.firstWhere(
                        (city) => city['name'] == _selectedCity,
                        orElse: () => {'id': null},
                      )['id'] as int?;

                      _selectedDistrictId = null;
                      _selectedSubdistrictId = null;

                      _getDistrict();
                    });
                  }, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kabupaten/Kota tidak boleh kosong';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16.0),
                  _buildLabel("Kecamatan"),
                  const SizedBox(height: 6.5),
                  _buildDropdown(_selectedCity != null ? _districtsNames : [],
                      _selectedDistrict, 'Pilih Kecamatan', (value) {
                    setState(() {
                      _selectedDistrict = value;
                      _selectedSubdistrict = null;

                      _selectedDistrictId = _districts.firstWhere(
                        (district) => district['name'] == _selectedDistrict,
                        orElse: () => {'id': null},
                      )['id'] as int?;

                      _selectedSubdistrictId = null;

                      _getSubDistrict();
                    });
                  }, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kecamatan tidak boleh kosong';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16.0),
                  _buildLabel("Kelurahan"),
                  const SizedBox(height: 6.5),
                  _buildDropdown(
                    _selectedDistrict != null ? _subdistrictsNames : [],
                    _selectedSubdistrict,
                    'Pilih Kelurahan',
                    (value) {
                      setState(() {
                        _selectedSubdistrict = value;
                        _selectedSubdistrictId = _subdistricts.firstWhere(
                          (subdistrict) =>
                              subdistrict['name'] == _selectedSubdistrict,
                          orElse: () => {'id': null},
                        )['id'] as int?;
                        print(_selectedSubdistrictId);
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kelurahan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  ElevatedButton(
                    onPressed: () {
                      confirmPopup(
                          context,
                          'Simpan Alamat',
                          'Apakah Anda yakin ingin menyimpan alamat ini?',
                          'Ya!', () {
                        _saveAddress(context);
                      });
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
                            "Save Address",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14.5,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Column _buildDropdown(
    List<String> items,
    String? selectedValue,
    String hintText,
    ValueChanged<String?>? onChanged, {
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<String>(
            isExpanded: true,
            hint: Text(
              hintText,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: onChanged,
            validator: validator,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 48,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  TextFormField _buildTextField(
    TextEditingController controller,
    String hintText, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 240, 240, 240),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
