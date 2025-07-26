
import 'package:shartflix_app/features/profile/models/profile_model.dart';
import 'package:shartflix_app/features/profile/repository/profile_remote_data_source.dart';
import 'package:shartflix_app/features/profile/repository/profile_repository.dart';
import 'package:shartflix_app/features/home/models/movie_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Profile> getProfile() {
    return remoteDataSource.getProfile();
  }

  @override
  Future<List<Movie>> getFavoriteMovies() {
    return remoteDataSource.getFavoriteMovies();
  }
}
