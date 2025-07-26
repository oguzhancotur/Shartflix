
import 'package:shartflix_app/features/auth/models/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String name, String password);
  Future<String> uploadPhoto(String filePath);
}
