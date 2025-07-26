import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shartflix_app/features/auth/models/user_model.dart';

class AuthRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSource({required this.client, required this.sharedPreferences});

  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('https://caseapi.servicelabs.tech/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final userModel = UserModel.fromJson(jsonDecode(response.body));
      sharedPreferences.setString('token', userModel.token);
      return userModel;
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<UserModel> register(String email, String name, String password) async {
    final response = await client.post(
      Uri.parse('https://caseapi.servicelabs.tech/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'name': name, 'password': password}),
    );

    print('Register API Response Status Code: ${response.statusCode}');
    print('Register API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final userModel = UserModel.fromJson(jsonDecode(response.body));
      sharedPreferences.setString('token', userModel.token);
      return userModel;
    } else {
      throw Exception(
        'Failed to register: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<Map<String, dynamic>> uploadPhoto(String filePath) async {
    final token = sharedPreferences.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://caseapi.servicelabs.tech/user/upload_photo'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print('Upload Photo API Response: $responseBody');
      return jsonDecode(responseBody);
    } else {
      throw Exception('Failed to upload photo: ${response.statusCode}');
    }
  }
}
