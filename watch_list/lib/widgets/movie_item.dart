import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_list/cubits/watch_list_cubit/watch_list_cubit.dart';
import 'package:watch_list/models/movie.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({
    required this.movie,
    required this.handleTap,
    Key? key,
  }) : super(key: key);

  final Movie movie;
  final Function(int) handleTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        handleTap(movie.id);
      },
      child: Stack(
        children: [
          Image.network(
            "https://image.tmdb.org/t/p/w500/${movie.poster}",
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color.fromARGB(169, 245, 91, 45),
                alignment: Alignment.center,
                child: const Icon(Icons.person, color: Colors.white),
              );
            },
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Card(
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () =>
                    context.read<WatchListCubit>().deleteMovie(movie.docId!),
                icon: const Icon(Icons.delete_outlined),
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 8,
            child: Card(
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () => context.read<WatchListCubit>().updateMovie(
                      movie.copyWith(watched: !movie.watched),
                    ),
                icon: movie.watched
                    ? const Icon(Icons.check_box_outlined)
                    : const Icon(Icons.check_box_outline_blank),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
