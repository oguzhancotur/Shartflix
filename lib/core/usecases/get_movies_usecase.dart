
import 'package:shartflix_app/features/home/models/movie_response_model.dart';
import 'package:shartflix_app/features/home/repository/movie_repository.dart';

class GetMoviesUseCase {
  final MovieRepository repository;

  GetMoviesUseCase(this.repository);

  Future<MovieResponse> call(int page) {
    return repository.getMovies(page);
  }
}
