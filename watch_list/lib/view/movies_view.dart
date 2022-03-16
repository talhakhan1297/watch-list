import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_list/cubit/watch_list_cubit.dart';
import 'package:watch_list/widgets/movie_item.dart';

class MoviesView extends StatelessWidget {
  const MoviesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchListCubit, WatchListState>(
      buildWhen: (previous, current) =>
          previous.movieState != current.movieState,
      builder: (context, state) {
        if (state.movieState.model == null || state.movieState.model!.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Text("No movies found")),
          );
        }
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 2 / 3,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return MovieItem(movie: state.movieState.model![index]);
            },
            childCount: state.movieState.model!.length,
          ),
        );
      },
    );
  }
}
