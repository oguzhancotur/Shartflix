import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shartflix_app/features/home/bloc/home_bloc.dart';
import 'package:shartflix_app/l10n/app_localizations.dart';
import 'package:shartflix_app/core/theme/app_theme.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeInitial ||
            (state is HomeLoading && state.movies.isEmpty)) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/loading_animation.json',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          );
        } else if (state is HomeError) {
          return Center(
            child: Text(
              state.message,
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.white),
            ),
          );
        } else if (state is HomeLoaded || state is HomeLoading) {
          final movies = state is HomeLoaded
              ? state.movies
              : (state as HomeLoading).movies;
          final hasReachedMax = state is HomeLoaded
              ? state.hasReachedMax
              : false;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(RefreshMovies());
            },
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: hasReachedMax ? movies.length : movies.length + 1,
              onPageChanged: (index) {
                final bloc = context.read<HomeBloc>();
                final state = bloc.state;

                if (state is HomeLoaded && !state.hasReachedMax) {
                  if (index >= state.movies.length - 2) {
                    bloc.add(const GetMovies());
                  }
                }
              },
              itemBuilder: (context, index) {
                if (index >= movies.length) {
                  return Center(
                    child: Lottie.asset(
                      'assets/lottie/loading_animation.json',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  );
                }

                final movie = movies[index];
                String imageUrl = movie.posterUrl;
                if (imageUrl.contains('..jpg')) {
                  imageUrl = imageUrl.replaceAll('..jpg', '.jpg');
                }

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: AppColors.darkBackground);
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: size.height * 0.25,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, AppColors.black],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: size.width * 0.04,
                      right: size.width * 0.04,
                      bottom: size.height * 0.037,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width * 0.11,
                            height: size.width * 0.11,
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed,
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image: AssetImage('assets/images/N.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: AppTextStyles.movieTitle,
                                ),
                                SizedBox(
                                  height: size.height * 0.005,
                                ), // 4px responsive
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: movie.description.length > 60
                                            ? movie.description.substring(0, 60)
                                            : movie.description,
                                        style: AppTextStyles.movieDescription,
                                      ),
                                      TextSpan(
                                        text: loc.more,
                                        style: AppTextStyles.movieDescription
                                            .copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          GestureDetector(
                            onTap: () {
                              context.read<HomeBloc>().add(
                                ToggleFavoriteMovie(movieId: movie.id),
                              );
                            },
                            child: Container(
                              width: size.width * 0.13,
                              height: size.height * 0.09,
                              decoration: BoxDecoration(
                                color: AppColors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(
                                  size.width * 0.1,
                                ),
                                border: Border.all(color: AppColors.white24),
                              ),
                              child: Icon(
                                movie.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
