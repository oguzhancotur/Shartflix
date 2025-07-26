part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class GetMovies extends HomeEvent {
  const GetMovies();
}

class RefreshMovies extends HomeEvent {}

class ToggleFavoriteMovie extends HomeEvent {
  final String movieId;
  const ToggleFavoriteMovie({required this.movieId});
  @override
  List<Object> get props => [movieId];
}
