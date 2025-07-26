
import 'package:shartflix_app/features/auth/repository/auth_remote_data_source.dart';
import 'package:shartflix_app/features/auth/models/user.dart';
import 'package:shartflix_app/features/auth/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String name, String password) {
    return remoteDataSource.register(email, name, password);
  }

  @override
  Future<String> uploadPhoto(String filePath) async {
    final response = await remoteDataSource.uploadPhoto(filePath);
    return response['data']['photoUrl'];
  }
}
