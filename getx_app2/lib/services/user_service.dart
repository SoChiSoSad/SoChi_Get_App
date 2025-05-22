// File: lib/services/userService.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/userModel.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

const String BASE_API = "https://jsonplaceholder.typicode.com";

class UserService {
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await http
          .get(Uri.parse('$BASE_API/users'))
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching users: $e'); // Log error for debugging
      throw Exception('Error fetching users: $e');
    }
  }
}