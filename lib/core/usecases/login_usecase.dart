
import 'package:shartflix_app/features/auth/models/user.dart';
import 'package:shartflix_app/features/auth/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
