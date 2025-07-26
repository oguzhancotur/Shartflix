import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shartflix_app/features/auth/repository/auth_remote_data_source.dart';
import 'package:shartflix_app/features/auth/repository/auth_repository_impl.dart';
import 'package:shartflix_app/core/usecases/login_usecase.dart';
import 'package:shartflix_app/core/usecases/register_usecase.dart';
import 'package:shartflix_app/core/usecases/upload_photo_usecase.dart';
import 'package:shartflix_app/features/auth/bloc/auth_bloc.dart';
import 'package:shartflix_app/features/auth/screens/upload_photo/upload_photo_view.dart';

class UploadPhotoScreen extends StatelessWidget {
  const UploadPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/loading_animation.json',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final sharedPreferences = snapshot.data!;
        return BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: LoginUseCase(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSource(
                  client: http.Client(),
                  sharedPreferences: sharedPreferences,
                ),
              ),
            ),
            registerUseCase: RegisterUseCase(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSource(
                  client: http.Client(),
                  sharedPreferences: sharedPreferences,
                ),
              ),
            ),
            uploadPhotoUseCase: UploadPhotoUseCase(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSource(
                  client: http.Client(),
                  sharedPreferences: sharedPreferences,
                ),
              ),
            ),
          ),
          child: const UploadPhotoView(),
        );
      },
    );
  }
}
