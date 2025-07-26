
import 'package:shartflix_app/features/auth/repository/auth_repository.dart';

class UploadPhotoUseCase {
  final AuthRepository repository;

  UploadPhotoUseCase(this.repository);

  Future<String> call(String filePath) {
    return repository.uploadPhoto(filePath);
  }
}
