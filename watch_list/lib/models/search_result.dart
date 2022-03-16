import 'package:equatable/equatable.dart';
import 'package:watch_list/models/movie.dart';

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
