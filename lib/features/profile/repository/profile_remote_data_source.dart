import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shartflix_app/core/constants/app_constants.dart';
import 'package:shartflix_app/features/profile/models/profile_model.dart';
import 'package:shartflix_app/features/home/models/movie_model.dart';

class ProfileRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  ProfileRemoteDataSource({
    required this.client,
    required this.sharedPreferences,
  });

  Future<Profile> getProfile() async {
    final token = sharedPreferences.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.profileEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Profile API Response Status Code: ${response.statusCode}');
    print('Profile API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to load profile: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<Movie>> getFavoriteMovies() async {
    final token = sharedPreferences.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await client.get(
      Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.favoriteMoviesEndpoint}',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Favorite Movies API Response Status Code: ${response.statusCode}');
    print('Favorite Movies API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> movieJsonList = jsonResponse['data'] ?? [];
      return movieJsonList.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load favorite movies: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
