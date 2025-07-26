import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shartflix_app/core/usecases/get_favorite_movies_usecase.dart';
import 'package:shartflix_app/core/usecases/get_profile_usecase.dart';
import 'package:shartflix_app/features/home/models/movie_model.dart';
import 'package:shartflix_app/features/profile/bloc/profile_bloc.dart';
import 'package:shartflix_app/features/profile/repository/profile_remote_data_source.dart';
import 'package:shartflix_app/features/profile/repository/profile_repository_impl.dart';
import 'package:shartflix_app/features/profile/screens/limited_offer_dialog.dart';
import 'package:shartflix_app/l10n/app_localizations.dart';
import 'package:shartflix_app/core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final ValueChanged<int> onItemTapped;

  const ProfileScreen({super.key, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final sharedPreferences = snapshot.data!;

        return BlocProvider(
          create: (_) => ProfileBloc(
            getProfileUseCase: GetProfileUseCase(
              ProfileRepositoryImpl(
                remoteDataSource: ProfileRemoteDataSource(
                  client: http.Client(),
                  sharedPreferences: sharedPreferences,
                ),
              ),
            ),
            getFavoriteMoviesUseCase: GetFavoriteMoviesUseCase(
              ProfileRepositoryImpl(
                remoteDataSource: ProfileRemoteDataSource(
                  client: http.Client(),
                  sharedPreferences: sharedPreferences,
                ),
              ),
            ),
          )..add(GetProfile()),
          child: Scaffold(
            backgroundColor: AppColors.darkBackground,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfileError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: AppTextStyles.bodyText1.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    );
                  } else if (state is ProfileLoaded) {
                    final movies = state.favoriteMovies;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.015,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: screenWidth * 0.11,
                                height: screenWidth * 0.11,
                                decoration: BoxDecoration(
                                  color: AppColors.white12,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white.withOpacity(0.2),
                                    width: 1.0,
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.white,
                                  ),
                                  onPressed: () => onItemTapped(0),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  loc.profileDetails,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.profileDetailTitle
                                      .copyWith(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        const LimitedOfferModal(),
                                  );
                                },
                                child: Container(
                                  width: screenWidth * 0.30,
                                  height: screenHeight * 0.045,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03,
                                    vertical: screenHeight * 0.007,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryRed,
                                    borderRadius: BorderRadius.circular(53),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/teklif.png',
                                        width: screenWidth * 0.04,
                                        height: screenWidth * 0.04,
                                        color: AppColors.white,
                                      ),
                                      SizedBox(width: screenWidth * 0.01),
                                      Text(
                                        loc.limitedOffer,
                                        style: AppTextStyles.limitedOfferText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.018),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: screenWidth * 0.09,
                                backgroundImage: NetworkImage(
                                  state.profile.photoUrl.isNotEmpty
                                      ? state.profile.photoUrl
                                      : 'https://via.placeholder.com/150?text=No+Photo',
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.profile.name,
                                      style: AppTextStyles.profileDetailTitle
                                          .copyWith(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Text(
                                      "ID: ${state.profile.id}",
                                      style: AppTextStyles.profileDetailId
                                          .copyWith(
                                            fontSize: screenWidth * 0.03,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/upload_photo');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: Size(
                                    screenWidth * 0.28,
                                    screenHeight * 0.045,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03,
                                    vertical: screenHeight * 0.012,
                                  ),
                                  side: BorderSide(
                                    color: AppColors.white.withOpacity(0.4),
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  loc.addPhoto,
                                  style: AppTextStyles.addPhotoButtonText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                          ),
                          child: Text(
                            loc.favoriteMovies,
                            style: AppTextStyles.favoriteMoviesHeader,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                            child: GridView.builder(
                              itemCount: movies.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.65,
                                  ),
                              itemBuilder: (context, index) {
                                final movie = movies[index];
                                String imageUrl = movie.posterUrl;

                                if (imageUrl.contains('..jpg')) {
                                  imageUrl = imageUrl.replaceAll(
                                    '..jpg',
                                    '.jpg',
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.41,
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.26,

                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                height: screenHeight * 0.22,
                                                color: AppColors.mediumGrey,
                                                child: const Icon(Icons.error),
                                              );
                                            },
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Flexible(
                                      child: Text(
                                        movie.title,
                                        style: AppTextStyles.favoriteMovieTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        movie.country,
                                        style: AppTextStyles
                                            .favoriteMovieDescription,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
