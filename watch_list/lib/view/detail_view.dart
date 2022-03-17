import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_list/cubits/movie_details_cubit/movie_details_cubit.dart';
import 'package:watch_list/models/movie_details.dart';
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
      body: Stack(
        children: [
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
            buildWhen: (previous, current) =>
                previous.movieDetailsState != current.movieDetailsState,
            builder: (context, state) {
              switch (state.movieDetailsState.apiCallState) {
                case APICallState.initial:
                  context
                      .read<MovieDetailsCubit>()
                      .getMovieDetails(int.parse(arg['id']!));
                  return const SizedBox();
                case APICallState.loading:
                  return const Center(child: CircularProgressIndicator());
                case APICallState.loaded:
                  return DetailsLoaded(result: state.movieDetailsState.model);
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
        ],
      ),
    );
  }
}

class DetailsLoaded extends StatelessWidget {
  const DetailsLoaded({Key? key, required this.result}) : super(key: key);

  final MovieDetails? result;

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Center(child: Text("Details not available"));
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Image.asset('assets/logo.png'),
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Image.network(
                "https://image.tmdb.org/t/p/w780/${result!.poster}",
                height: MediaQuery.of(context).size.height / 2,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xff322043),
                    alignment: Alignment.center,
                    child: const Icon(Icons.person, color: Colors.white),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      result!.title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      result!.overview!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Rating: ${result!.voteAvg}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Cast",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        result!.cast?.castList?.length ?? 0,
                        (index) => Image.network(
                          "https://image.tmdb.org/t/p/w185${result!.cast!.castList![index].image}",
                          width: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 4),
      ],
    );
  }
}
