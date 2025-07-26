
import 'package:shartflix_app/features/auth/models/user.dart';
import 'package:shartflix_app/features/auth/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call(String email, String name, String password) {
    return repository.register(email, name, password);
  }
}
