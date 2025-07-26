part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  final List<Movie> movies;
  final int currentPage;
  final bool hasReachedMax;

  const HomeLoading({
    this.movies = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [movies, currentPage, hasReachedMax];
}

class HomeLoaded extends HomeState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final int currentPage;
  const HomeLoaded({
    required this.movies,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  HomeLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return HomeLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [movies, hasReachedMax, currentPage];
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});
  @override
  List<Object> get props => [message];
}
