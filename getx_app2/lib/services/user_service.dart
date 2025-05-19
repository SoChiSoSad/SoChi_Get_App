import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/userModel.dart';

// APIs ảo để giả lập kết nối APIs: https://jsonplaceholder.typicode.com/users
const String BASE_API = "https://jsonplaceholder.typicode.com";

class UserService {
  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('$BASE_API/users'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList(); // ✅ sửa tên class tại đây
    } else {
      throw Exception('Failed to load users');
    }
  }
}
