
import 'package:shartflix_app/features/home/models/movie_response_model.dart';

abstract class MovieRepository {
  Future<MovieResponse> getMovies(int page);
  Future<Map<String, dynamic>> toggleFavorite(String movieId);
}
