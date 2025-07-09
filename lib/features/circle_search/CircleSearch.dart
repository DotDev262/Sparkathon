// lib/features/circle_search/circle_search_page.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class CircleSearchPage extends StatefulWidget {
  const CircleSearchPage({super.key});

  @override
  State<CircleSearchPage> createState() => _CircleSearchPageState();
}

class _CircleSearchPageState extends State<CircleSearchPage> {
  List<Map<String, dynamic>> _results = [];
  bool _loading = true;
  String? _error;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _startSearch();
  }

  Future<void> _startSearch() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      setState(() {
        _error = "No image selected.";
        _loading = false;
      });
      return;
    }

    _pickedImage = File(pickedFile.path);
    logger.d("Picked image path: ${_pickedImage!.path}");

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'http://11.12.2.41:8000/circle_search',
        ), // Replace with your FastAPI host
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', _pickedImage!.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final results = (data['results'] as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        setState(() {
          _results = results;
          _loading = false;
        });
      } else {
        setState(() {
          _error = "Server error: ${response.statusCode}";
          _loading = false;
        });
      }
    } catch (e, st) {
      logger.e("Request failed", error: e, stackTrace: st);
      setState(() {
        _error = "Failed to connect to server.";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Circle Search")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : Column(
              children: [
                if (_pickedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Selected Image",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _pickedImage!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(thickness: 1),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Top 5 Similar Products",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final item = _results[index];
                      final imageUrl =
                          item["image_url"]
                              ?.toString()
                              .replaceAll('"', '')
                              .trim() ??
                          "";

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              logger.e(
                                "Image load failed: $error\nURL: $imageUrl",
                              );
                              return const Icon(Icons.broken_image);
                            },
                          ),
                          title: Text(item["name"] ?? "Unnamed"),
                          subtitle: Text("₹${item["price"]}"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
