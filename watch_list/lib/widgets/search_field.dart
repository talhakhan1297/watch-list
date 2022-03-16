import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_list/cubit/watch_list_cubit.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) => context.read<WatchListCubit>().searchMovies(value),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.read<WatchListCubit>().searchMovies("");
            controller.clear();
          },
          child: const Icon(Icons.clear),
        ),
        hintText: 'Search Movies',
      ),
    );
  }
}
