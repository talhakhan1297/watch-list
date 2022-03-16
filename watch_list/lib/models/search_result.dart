import 'package:equatable/equatable.dart';

class SearchResult extends Equatable {
  const SearchResult({required this.movies});

  final List<Movie>? movies;

  factory SearchResult.fromJson(Map<String, dynamic> map) {
    return SearchResult(
      movies: (map['results'] as List?)?.map((e) => Movie.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [movies];
}

class Movie extends Equatable {
  final int id;
  final String? docId;
  final String? title;
  final String? image;
  final String? poster;
  final String? overview;
  final bool watched;

  const Movie({
    required this.id,
    this.docId,
    required this.title,
    required this.image,
    required this.poster,
    required this.overview,
    required this.watched,
  });

  Movie copyWith({bool? watched}) {
    return Movie(
      id: id,
      docId: docId,
      title: title,
      image: image,
      poster: poster,
      overview: overview,
      watched: watched ?? this.watched,
    );
  }

  factory Movie.fromJson(Map<String, dynamic> map, {String? docId}) {
    return Movie(
      id: map['id'],
      docId: docId,
      title: map['title'],
      image: map['backdrop_path'],
      poster: map['poster_path'],
      overview: map['overview'],
      watched: map['watched'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'backdrop_path': image,
      'poster_path': poster,
      'overview': overview,
      'watched': watched,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        image,
        poster,
        overview,
        watched,
      ];
}
