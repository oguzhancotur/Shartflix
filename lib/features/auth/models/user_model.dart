
import 'package:shartflix_app/features/auth/models/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['data']['_id'],
      name: json['data']['name'],
      email: json['data']['email'],
      token: json['data']['token'],
    );
  }
}
