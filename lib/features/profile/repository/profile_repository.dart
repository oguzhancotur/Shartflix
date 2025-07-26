
import 'package:shartflix_app/features/profile/models/profile_model.dart';
import 'package:shartflix_app/features/home/models/movie_model.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
  Future<List<Movie>> getFavoriteMovies();
}
