
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String name;
  final String password;

  const RegisterRequested({required this.email, required this.name, required this.password});

  @override
  List<Object> get props => [email, name, password];
}

class UploadPhotoRequested extends AuthEvent {
  final String imagePath;

  const UploadPhotoRequested({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}
