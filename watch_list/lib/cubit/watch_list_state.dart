part of 'watch_list_cubit.dart';

class WatchListState extends Equatable {
  const WatchListState({
    this.searchState = const GeneralApiState(),
    this.movieState = const GeneralApiState(),
  });

  final GeneralApiState<SearchResult> searchState;
  final GeneralApiState<List<Movie>> movieState;

  WatchListState copyWith({
    GeneralApiState<SearchResult>? searchState,
    GeneralApiState<List<Movie>>? movieState,
  }) {
    return WatchListState(
      searchState: searchState ?? this.searchState,
      movieState: movieState ?? this.movieState,
    );
  }

  @override
  List<Object> get props => [searchState, movieState];
}
