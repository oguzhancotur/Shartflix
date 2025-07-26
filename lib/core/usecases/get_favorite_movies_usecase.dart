
import 'package:shartflix_app/features/home/models/movie_model.dart';
import 'package:shartflix_app/features/profile/repository/profile_repository.dart';

class GetFavoriteMoviesUseCase {
  final ProfileRepository repository;

  GetFavoriteMoviesUseCase(this.repository);

  Future<List<Movie>> call() {
    return repository.getFavoriteMovies();
  }
}
