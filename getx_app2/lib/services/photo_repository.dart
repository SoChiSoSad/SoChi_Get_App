import 'dart:convert';
import 'package:getx_app2/models/photoModel.dart';
import 'package:getx_app2/services/user_service.dart';
import 'package:http/http.dart' as http;

class PhotoRepository {
  Future<List<PhotoModel>> fetchPhotos() async {
    final response = await http.get(Uri.parse('$BASE_API/photos'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PhotoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
