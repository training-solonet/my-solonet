import 'package:flutter/material.dart';

class ChangeProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubah Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins', // Font Poppins
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
          color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Simpan perubahan
            },
            child: const Text(
              'SIMPAN',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins', // Font Poppins
              ),
            ),
          ),
        ],
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007bff),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      'KA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins', // Font Poppins
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anda belum mengatur foto profile. Abaikan jika tidak ingin mengubahnya.',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 11,
                          fontFamily: 'Poppins', // Font Poppins
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Ubah foto',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins', // Font Poppins
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Form Input Section
            _buildFormGroup('Nama', 'Kevin Andra.', true),
            const SizedBox(height: 20),
            _buildPhoneInputGroup('Nomor HP', '+62 83825757229', true),
            const SizedBox(height: 20),
            _buildFormGroup('Email', 'kevinandranugroho448@gmail.com', true),
          ],
        ),
      ),
    );
  }

  Widget _buildFormGroup(String label, String value, bool required) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ${required ? '*' : ''}',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins', // Font Poppins
          ),
        ),
        const SizedBox(height: 6.5),
        TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(10),
          ),
          style: const TextStyle(
            fontFamily: 'Poppins', // Font Poppins
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInputGroup(String label, String value, bool required) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ${required ? '*' : ''}',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins', // Font Poppins
          ),
        ),
        const SizedBox(height: 6.5),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(text: value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(10),
                ),
                style: const TextStyle(
                  fontFamily: 'Poppins', // Font Poppins
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
