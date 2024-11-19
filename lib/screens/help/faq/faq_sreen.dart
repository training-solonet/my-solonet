import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mysolonet/screens/help/faq/faq_detail_screen.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<dynamic> faqs = [];
  List<dynamic> filteredFaqs = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    final response =
        await http.get(Uri.parse('https://api.connectis.my.id/faq'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        faqs = data;
        filteredFaqs = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterFaqs(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredFaqs = faqs.where((faq) {
        final questionLower = faq['pertanyaan'].toLowerCase();
        return questionLower.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'FAQ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Daftar Pertanyaan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      onChanged: _filterFaqs,
                      decoration: InputDecoration(
                        hintText: 'Cari pertanyaan...',
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.search),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: filteredFaqs.isEmpty
                        ? const Center(
                            child: Text(
                              'Pertanyaan tidak tersedia',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: filteredFaqs.length,
                            itemBuilder: (context, index) {
                              final faq = filteredFaqs[index];
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      faq['pertanyaan'],
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: const Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FaqDetailScreen(
                                            question: faq['pertanyaan'],
                                            answer: faq['jawaban'],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
