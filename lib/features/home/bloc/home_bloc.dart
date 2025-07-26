import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shartflix_app/core/usecases/get_movies_usecase.dart';
import 'package:shartflix_app/core/usecases/toggle_favorite_usecase.dart';
import 'package:shartflix_app/features/home/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMoviesUseCase getMoviesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final SharedPreferences sharedPreferences;

  HomeBloc({
    required this.getMoviesUseCase,
    required this.toggleFavoriteUseCase,
    required this.sharedPreferences,
  }) : super(HomeInitial()) {
    on<GetMovies>((event, emit) async {
      print("HomeBloc: Handling GetMovies event");
      if (state is HomeLoading) {
        print("HomeBloc: Already loading, returning.");
        return;
      }

      final currentState = state;
      List<Movie> oldMovies = [];
      int currentPage = 1;
      bool hasReachedMax = false;

      if (currentState is HomeLoaded) {
        print(
          "HomeBloc: Current state is HomeLoaded. Current page: ${currentState.currentPage}, Has Reached Max: ${currentState.hasReachedMax}",
        );
        if (currentState.hasReachedMax) {
          print("HomeBloc: Already reached max, returning.");
          return;
        }
        oldMovies = currentState.movies;
        currentPage = currentState.currentPage + 1;
      }

      print(
        "HomeBloc: Emitting HomeLoading. Current Page: $currentPage, Old Movies Count: ${oldMovies.length}",
      );
      emit(
        HomeLoading(
          movies: oldMovies,
          currentPage: currentPage,
          hasReachedMax: hasReachedMax,
        ),
      );

      try {
        print("HomeBloc: Calling getMoviesUseCase for page $currentPage");
        final movieResponse = await getMoviesUseCase(currentPage);
        print(
          "HomeBloc: Fetched ${movieResponse.movies.length} movies for page ${movieResponse.currentPage}. Total pages: ${movieResponse.totalPages}",
        );
        final freshSharedPreferences = await SharedPreferences.getInstance();
        List<String> currentFavoriteIds =
            freshSharedPreferences.getStringList('favoriteMovieIds') ?? [];
        print(
          "HomeBloc: SharedPreferences - Current Favorite IDs (GetMovies): $currentFavoriteIds",
        );

        final List<Movie> newMovies = movieResponse.movies.map((movie) {
          final bool isFav = currentFavoriteIds.contains(movie.id);
          print(
            "HomeBloc: Movie ${movie.title} (ID: ${movie.id}) - isFavorite: $isFav",
          );
          return movie.copyWith(isFavorite: isFav);
        }).toList();

        emit(
          HomeLoaded(
            movies: oldMovies + newMovies,
            hasReachedMax:
                movieResponse.currentPage >= movieResponse.totalPages,
            currentPage: movieResponse.currentPage,
          ),
        );
        print(
          "HomeBloc: Emitted HomeLoaded. Total movies: ${(oldMovies + newMovies).length}, Has Reached Max: ${movieResponse.currentPage >= movieResponse.totalPages}",
        );
      } catch (e) {
        print("HomeBloc: Error fetching movies: $e");
        emit(HomeError(message: e.toString()));
      }
    });

    on<RefreshMovies>((event, emit) async {
      print("HomeBloc: Handling RefreshMovies event");
      emit(HomeLoading(movies: []));

      try {
        print("HomeBloc: Calling getMoviesUseCase for page 1 (refresh)");
        final movieResponse = await getMoviesUseCase(1);
        print("HomeBloc: Refreshed with ${movieResponse.movies.length} movies");
        final freshSharedPreferences = await SharedPreferences.getInstance();
        List<String> currentFavoriteIds =
            freshSharedPreferences.getStringList('favoriteMovieIds') ?? [];
        print(
          "HomeBloc: SharedPreferences - Current Favorite IDs (RefreshMovies): $currentFavoriteIds",
        );

        final List<Movie> refreshedMovies = movieResponse.movies.map((movie) {
          final bool isFav = currentFavoriteIds.contains(movie.id);
          print(
            "HomeBloc: Movie ${movie.title} (ID: ${movie.id}) - isFavorite: $isFav (Refresh)",
          );
          return movie.copyWith(isFavorite: isFav);
        }).toList();
        emit(
          HomeLoaded(
            movies: refreshedMovies,
            hasReachedMax:
                movieResponse.currentPage >= movieResponse.totalPages,
            currentPage: movieResponse.currentPage,
          ),
        );
        print(
          "HomeBloc: Emitted HomeLoaded state after refresh. Total movies: ${movieResponse.movies.length}",
        );
      } catch (e) {
        print("HomeBloc: Error refreshing movies: $e");
        emit(HomeError(message: e.toString()));
      }
    });

    on<ToggleFavoriteMovie>((event, emit) async {
      print(
        "HomeBloc: Handling ToggleFavoriteMovie event for movie ID: ${event.movieId}",
      );
      if (state is HomeLoaded) {
        final loadedState = state as HomeLoaded;
        final updatedMovies = List<Movie>.from(loadedState.movies);
        final movieIndex = updatedMovies.indexWhere(
          (movie) => movie.id == event.movieId,
        );

        if (movieIndex != -1) {
          final movie = updatedMovies[movieIndex];
          final updatedMovie = movie.copyWith(isFavorite: !movie.isFavorite);
          updatedMovies[movieIndex] = updatedMovie;

          print(
            "HomeBloc: Movie ${movie.title} new favorite status: ${updatedMovie.isFavorite}",
          );
          emit(loadedState.copyWith(movies: updatedMovies));
          print(
            "HomeBloc: Emitted HomeLoaded state after local favorite update.",
          );

          try {
            print(
              "HomeBloc: Calling toggleFavoriteUseCase for movie ID: ${event.movieId}",
            );
            await toggleFavoriteUseCase(event.movieId);
            print(
              "HomeBloc: Favorite toggled successfully via API for movie ID: ${event.movieId}",
            );

            // Update SharedPreferences
            List<String> favoriteMovieIds =
                sharedPreferences.getStringList('favoriteMovieIds') ?? [];
            if (updatedMovie.isFavorite) {
              if (!favoriteMovieIds.contains(updatedMovie.id)) {
                favoriteMovieIds.add(updatedMovie.id);
              }
            } else {
              favoriteMovieIds.remove(updatedMovie.id);
            }
            await sharedPreferences.setStringList(
              'favoriteMovieIds',
              favoriteMovieIds,
            );
            print(
              "HomeBloc: SharedPreferences updated for movie ID: ${updatedMovie.id}, isFavorite: ${updatedMovie.isFavorite}. Current Favorite IDs: $favoriteMovieIds",
            );
          } catch (e) {
            print(
              "HomeBloc: Error toggling favorite via API for movie ID ${event.movieId}: $e",
            );
            updatedMovies[movieIndex] = movie;
            emit(loadedState.copyWith(movies: updatedMovies));
            print("HomeBloc: Reverted favorite status due to API error.");
          }
        }
      }
    });
  }
}
