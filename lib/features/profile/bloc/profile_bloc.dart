import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shartflix_app/features/profile/models/profile_model.dart';
import 'package:shartflix_app/features/home/models/movie_model.dart';
import 'package:shartflix_app/core/usecases/get_profile_usecase.dart';
import 'package:shartflix_app/core/usecases/get_favorite_movies_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final GetFavoriteMoviesUseCase getFavoriteMoviesUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.getFavoriteMoviesUseCase,
  }) : super(ProfileInitial()) {
    on<GetProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getProfileUseCase();
        final favoriteMovies = await getFavoriteMoviesUseCase();
        emit(ProfileLoaded(profile: profile, favoriteMovies: favoriteMovies));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    });

    on<GetFavoriteMovies>((event, emit) async {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(ProfileLoading());
        try {
          final favoriteMovies = await getFavoriteMoviesUseCase();
          emit(
            ProfileLoaded(
              profile: currentState.profile,
              favoriteMovies: favoriteMovies,
            ),
          );
        } catch (e) {
          emit(ProfileError(message: e.toString()));
        }
      }
    });
  }
}
