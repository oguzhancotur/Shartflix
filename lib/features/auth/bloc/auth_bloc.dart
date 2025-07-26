import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shartflix_app/core/usecases/login_usecase.dart';
import 'package:shartflix_app/core/usecases/register_usecase.dart';
import 'package:shartflix_app/core/usecases/upload_photo_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final UploadPhotoUseCase uploadPhotoUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.uploadPhotoUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUseCase(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(const AuthFailure(error: 'Invalid credentials'));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await registerUseCase(
          event.email,
          event.name,
          event.password,
        );
        emit(AuthSuccess());
      } catch (e) {
        print('Register failed: $e');
        emit(AuthFailure(error: 'Registration failed: ${e.toString()}'));
      }
    });

    on<UploadPhotoRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final photoUrl = await uploadPhotoUseCase(event.imagePath);
        print('Photo URL: $photoUrl');
        emit(AuthSuccess());
      } catch (e) {
        print('Photo upload failed: $e');
        emit(AuthFailure(error: 'Photo upload failed: ${e.toString()}'));
      }
    });
  }
}
