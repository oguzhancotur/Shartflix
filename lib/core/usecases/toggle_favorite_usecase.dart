
import 'package:shartflix_app/features/home/repository/movie_repository.dart';

class ToggleFavoriteUseCase {
  final MovieRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Map<String, dynamic>> call(String movieId) {
    return repository.toggleFavorite(movieId);
  }
}
