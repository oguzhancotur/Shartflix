import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shartflix_app/features/auth/bloc/auth_bloc.dart';
import 'package:shartflix_app/l10n/app_localizations.dart';
import 'package:shartflix_app/core/theme/app_theme.dart';

class UploadPhotoView extends StatefulWidget {
  const UploadPhotoView({super.key});

  @override
  State<UploadPhotoView> createState() => _UploadPhotoViewState();
}

class _UploadPhotoViewState extends State<UploadPhotoView> {
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Photo Upload Failed: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Center(
                  child: Lottie.asset(
                    'assets/lottie/loading_animation.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        Text(
                          loc.profileDetails, // Localized string
                          style: AppTextStyles.favoriteMovieTitle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          loc.uploadPhotos, // Localized string
                          style: AppTextStyles.headline1.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          loc.uploadPhotosSlogan, // Localized string
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyText1.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 32),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: AppColors.grey900,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: _imageFile == null
                                ? const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: AppColors.white38,
                                      size: 50,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      File(_imageFile!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _imageFile == null
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                  UploadPhotoRequested(
                                    imagePath: _imageFile!.path,
                                  ),
                                );
                              },
                        child: Text(
                          loc.continueButton, // Localized string
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
