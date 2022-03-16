import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_list/cubit/watch_list_cubit.dart';
import 'package:watch_list/repository/watch_list_repository.dart';
import 'package:watch_list/view/movies_view.dart';
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
