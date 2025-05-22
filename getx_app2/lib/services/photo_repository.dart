import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getx_app2/models/photoModel.dart';
import 'package:getx_app2/services/user_service.dart';
import 'package:http/http.dart' as http;

class PhotoRepository {
  Future<List<PhotoModel>> fetchPhotos() async {
    try {
      final response = await http
          .get(Uri.parse('$BASE_API/photos'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timed out');
            },
          );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.take(20).map((json) => PhotoModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching photos: $e'); // Log lỗi
      throw Exception('Error fetching photos: $e');
    }
  }
}
