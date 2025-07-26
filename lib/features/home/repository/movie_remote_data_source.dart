import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shartflix_app/core/constants/app_constants.dart';
import 'package:shartflix_app/features/home/models/movie_model.dart';
import 'package:shartflix_app/features/home/models/movie_response_model.dart';

class MovieRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  MovieRemoteDataSource({
    required this.client,
    required this.sharedPreferences,
  });

  Future<MovieResponse> getMovies(int page) async {
    final token = sharedPreferences.getString('token');
    if (token == null) throw Exception('No token found');

    final response = await client.get(
      Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.movieListEndpoint}?page=$page',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return MovieResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> toggleFavorite(String movieId) async {
    final token = sharedPreferences.getString('token');
    if (token == null) {
      print('MovieRemoteDataSource: No token found for toggleFavorite');
      throw Exception('No token found');
    }

    print('MovieRemoteDataSource: Toggling favorite for movie ID: $movieId');
    final response = await client.post(
      Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.movieFavoriteEndpoint}/$movieId',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(
      'MovieRemoteDataSource: Toggle Favorite API Response Status Code: ${response.statusCode}',
    );
    print(
      'MovieRemoteDataSource: Toggle Favorite API Response Body: ${response.body}',
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(
        'MovieRemoteDataSource: Failed to toggle favorite: ${response.statusCode} - ${response.body}',
      );
      throw Exception(
        'Failed to toggle favorite: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
