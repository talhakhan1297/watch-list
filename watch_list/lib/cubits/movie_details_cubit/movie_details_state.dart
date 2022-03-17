part of 'movie_details_cubit.dart';

class MovieDetailsState extends Equatable {
  const MovieDetailsState({
    this.movieDetailsState = const GeneralApiState(),
    this.castState = const GeneralApiState(),
  });

  final GeneralApiState<MovieDetails> movieDetailsState;
  final GeneralApiState<CastList> castState;

  MovieDetailsState copyWith({
    GeneralApiState<MovieDetails>? movieDetailsState,
    GeneralApiState<CastList>? castState,
  }) {
    return MovieDetailsState(
      movieDetailsState: movieDetailsState ?? this.movieDetailsState,
      castState: castState ?? this.castState,
    );
  }

  @override
  List<Object> get props => [movieDetailsState, castState];
}
