import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:watch_list/models/movie_details.dart';
import 'package:watch_list/repository/watch_list_repository.dart';
import 'package:watch_list/utils/general_api_state.dart';

part 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  MovieDetailsCubit({required this.repository})
      : super(const MovieDetailsState());

  final WatchListRepository repository;

  Future<void> getMovieDetails(int id) async {
    await Future.delayed(Duration.zero);
    emit(
      state.copyWith(
        movieDetailsState: const GeneralApiState(
          apiCallState: APICallState.loading,
        ),
      ),
    );

    try {
      final result = await repository.getMovieDetail(id);
      final cast = await repository.getCast(id);
      emit(
        state.copyWith(
          movieDetailsState: GeneralApiState(
            model: result.copyWith(cast: cast),
            apiCallState: APICallState.loaded,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          movieDetailsState: GeneralApiState(
            apiCallState: APICallState.failure,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }
}
