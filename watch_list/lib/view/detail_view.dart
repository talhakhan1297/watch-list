import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_list/cubits/movie_details_cubit/movie_details_cubit.dart';
import 'package:watch_list/repository/watch_list_repository.dart';
import 'package:watch_list/utils/general_api_state.dart';

class DetailView extends StatelessWidget {
  const DetailView({Key? key, required this.arg}) : super(key: key);

  final Map<String, String> arg;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailsCubit(
        repository: context.read<WatchListRepository>(),
      ),
      child: Details(arg: arg),
    );
  }
}

class Details extends StatelessWidget {
  const Details({Key? key, required this.arg}) : super(key: key);

  final Map<String, String> arg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
        buildWhen: (previous, current) =>
            previous.movieDetailsState != current.movieDetailsState,
        builder: (context, state) {
          print(state.movieDetailsState.apiCallState);
          switch (state.movieDetailsState.apiCallState) {
            case APICallState.initial:
              context
                  .read<MovieDetailsCubit>()
                  .getMovieDetails(int.parse(arg['id']!));
              return const SizedBox();
            case APICallState.loading:
              return const Center(child: CircularProgressIndicator());
            // case APICallState.loaded:
            //   return SearchLoaded(
            //     result: state.searchState.model,
            //     controller: controller,
            //   );
            case APICallState.failure:
              return Center(
                child: Text(
                  state.movieDetailsState.errorMessage ??
                      "Something went wrong",
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
