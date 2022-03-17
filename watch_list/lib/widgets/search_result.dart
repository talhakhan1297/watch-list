import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_list/cubits/watch_list_cubit/watch_list_cubit.dart';
import 'package:watch_list/models/search_result.dart';
import 'package:watch_list/utils/general_api_state.dart';

class SearchResultView extends StatelessWidget {
  const SearchResultView({Key? key, required this.controller})
      : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchListCubit, WatchListState>(
      buildWhen: (previous, current) =>
          previous.searchState != current.searchState,
      builder: (context, state) {
        switch (state.searchState.apiCallState) {
          case APICallState.loading:
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(),
              ),
            );
          case APICallState.loaded:
            return SearchLoaded(
              result: state.searchState.model,
              controller: controller,
            );
          case APICallState.failure:
            return Center(
              child: Text(
                state.searchState.errorMessage ?? "Something went wrong",
              ),
            );
          case APICallState.initial:
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class SearchLoaded extends StatelessWidget {
  const SearchLoaded({
    Key? key,
    required this.result,
    required this.controller,
  }) : super(key: key);

  final SearchResult? result;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    if (result == null || result!.movies == null || result!.movies!.isEmpty) {
      return const Text("No movies found");
    }
    return Card(
      child: SizedBox(
        height: 300,
        child: ListView.builder(
          itemCount: result!.movies!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                context.read<WatchListCubit>().addMovie(result!.movies![index]);
                context.read<WatchListCubit>().searchMovies("");
                controller.clear();
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(result!.movies![index].title ?? ""),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
