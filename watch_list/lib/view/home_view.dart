import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_list/cubit/watch_list_cubit.dart';
import 'package:watch_list/repository/watch_list_repository.dart';
import 'package:watch_list/widgets/search_field.dart';
import 'package:watch_list/widgets/search_result.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchListCubit(repository: WatchListRepository()),
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Image.asset('assets/logo.png', height: 150),
                        ),
                        SearchField(controller: _controller),
                        SearchResultView(controller: _controller),
                        const SizedBox(height: 56),
                        const Text(
                          "Movies",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
                const MoviesView(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
              return Stack(
                children: [
                  Image.network(
                    "https://image.tmdb.org/t/p/w500/${state.movieState.model![index].poster}",
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
                        onPressed: () => context
                            .read<WatchListCubit>()
                            .deleteMovie(state.movieState.model![index].docId!),
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
                        onPressed: () => context
                            .read<WatchListCubit>()
                            .updateMovie(
                                state.movieState.model![index].copyWith(
                              watched: !state.movieState.model![index].watched,
                            )),
                        icon: state.movieState.model![index].watched
                            ? const Icon(Icons.check_box_outlined)
                            : const Icon(Icons.check_box_outline_blank),
                      ),
                    ),
                  ),
                ],
              );
            },
            childCount: state.movieState.model!.length,
          ),
        );
      },
    );
  }
}
