part of 'movie_details_cubit.dart';

class MovieDetailsState extends Equatable {
  const MovieDetailsState({
    this.movieDetailsState = const GeneralApiState(),
  });

  final GeneralApiState<MovieDetails> movieDetailsState;

  MovieDetailsState copyWith({
    GeneralApiState<MovieDetails>? movieDetailsState,
  }) {
    return MovieDetailsState(
      movieDetailsState: movieDetailsState ?? this.movieDetailsState,
    );
  }

  @override
  List<Object> get props => [movieDetailsState];
}
