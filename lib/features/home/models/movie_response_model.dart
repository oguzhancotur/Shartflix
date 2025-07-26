
import 'package:equatable/equatable.dart';
import 'package:shartflix_app/features/home/models/movie_model.dart';

class MovieResponse extends Equatable {
  final List<Movie> movies;
  final int totalPages;
  final int currentPage;

  const MovieResponse({
    required this.movies,
    required this.totalPages,
    required this.currentPage,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final pagination = data['pagination'] as Map<String, dynamic>;
    return MovieResponse(
      movies: (data['movies'] as List)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: pagination['maxPage'] ?? 0,
      currentPage: pagination['currentPage'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [movies, totalPages, currentPage];
}
