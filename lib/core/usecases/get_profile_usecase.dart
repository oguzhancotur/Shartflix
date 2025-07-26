
import 'package:shartflix_app/features/profile/models/profile_model.dart';
import 'package:shartflix_app/features/profile/repository/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Profile> call() {
    return repository.getProfile();
  }
}
