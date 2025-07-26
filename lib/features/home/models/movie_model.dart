import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String country;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.country,
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    String url = (json['Poster'] ?? '').trim();

    url = url.replaceAll('..jpg', '.jpg');

    if (url.startsWith('http://')) {
      url = url.replaceFirst('http://', 'https://');
    }

    return Movie(
      id: json['id'] ?? '',
      title: json['Title'] ?? '',
      description: json['Plot'] ?? '',
      posterUrl: url,
      country: json['Country'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    posterUrl,
    country,
    isFavorite,
  ];

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    String? country,
    bool? isFavorite,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      country: country ?? this.country,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
