
import 'package:shartflix_app/features/home/models/movie_response_model.dart';
import 'package:shartflix_app/features/home/repository/movie_remote_data_source.dart';
import 'package:shartflix_app/features/home/repository/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MovieResponse> getMovies(int page) {
    return remoteDataSource.getMovies(page);
  }

  @override
  Future<Map<String, dynamic>> toggleFavorite(String movieId) {
    return remoteDataSource.toggleFavorite(movieId);
  }
}
