import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:watch_list/models/movie.dart';
import 'package:watch_list/models/search_result.dart';
import 'package:watch_list/repository/watch_list_repository.dart';
import 'package:watch_list/utils/general_api_state.dart';

part 'watch_list_state.dart';

class WatchListCubit extends Cubit<WatchListState> {
  WatchListCubit({required this.repository}) : super(const WatchListState()) {
    _movieSubscription = repository.streamMovies().listen(updatedMovies);
  }

  final WatchListRepository repository;
  late final StreamSubscription<List<Movie>> _movieSubscription;

  @override
  Future<void> close() {
    _movieSubscription.cancel();
    return super.close();
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchState: const GeneralApiState(
            apiCallState: APICallState.initial,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          searchState: const GeneralApiState(
            apiCallState: APICallState.loading,
          ),
        ),
      );

      try {
        final result = await repository.searchMovies(query);
        emit(
          state.copyWith(
            searchState: GeneralApiState(
              model: result,
              apiCallState: APICallState.loaded,
            ),
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            searchState: GeneralApiState(
              apiCallState: APICallState.failure,
              errorMessage: e.toString(),
            ),
          ),
        );
      }
    }
  }

  void updatedMovies(List<Movie> movies) {
    emit(
      state.copyWith(
        movieState: GeneralApiState(
          apiCallState: APICallState.loaded,
          model: movies,
        ),
      ),
    );
  }

  Future<void> addMovie(Movie movie) async {
    try {
      await repository.addMovie(movie);
    } catch (e) {
      emit(
        state.copyWith(
          movieState: GeneralApiState(
            apiCallState: APICallState.failure,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> updateMovie(Movie movie) async {
    try {
      await repository.updateMovie(movie.docId!, movie);
    } catch (e) {
      emit(
        state.copyWith(
          movieState: GeneralApiState(
            apiCallState: APICallState.failure,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> deleteMovie(String docId) async {
    try {
      await repository.deleteMovie(docId);
    } catch (e) {
      emit(
        state.copyWith(
          movieState: GeneralApiState(
            apiCallState: APICallState.failure,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }
}
