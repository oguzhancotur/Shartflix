import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String photoUrl;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return Profile(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, email, photoUrl];
}
