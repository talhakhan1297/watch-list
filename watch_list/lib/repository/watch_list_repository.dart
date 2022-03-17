import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:watch_list/models/movie.dart';
import 'package:watch_list/models/movie_details.dart';
import 'package:watch_list/models/search_result.dart';

class WatchListRepository {
  WatchListRepository({Client? httpClient})
      : _httpClient = httpClient ?? Client();

  final Client _httpClient;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static const _baseURL = 'api.themoviedb.org';
  static const _apiKey = '2e3196b2667f3f54ded1d98d15b5020d';

  final movies = FirebaseFirestore.instance.collection('movies');

  Future<SearchResult> searchMovies(String query) async {
    final searchRequest = Uri.https(
      _baseURL,
      '/3/search/movie',
      {
        'api_key': _apiKey,
        'query': query,
        'include_adult': false.toString(),
      },
    );

    final searchResponse = await _httpClient.get(searchRequest);

    if (searchResponse.statusCode != 200) {
      throw 'Item Request Failure';
    }

    final decoded = jsonDecode(searchResponse.body) as Map<String, dynamic>;

    if (decoded.isEmpty) {
      throw 'Item Not Found Failure';
    }

    return SearchResult.fromJson(decoded);
  }

  Future<MovieDetails> getMovieDetail(int id) async {
    final movieRequest = Uri.https(
      _baseURL,
      '/3/movie/$id',
      {
        'api_key': _apiKey,
        'language': 'en-US',
      },
    );
    final movieResponse = await _httpClient.get(movieRequest);
    if (movieResponse.statusCode != 200) {
      throw 'Movie Request Failure';
    }

    final decoded = jsonDecode(movieResponse.body) as Map<String, dynamic>;

    if (decoded.isEmpty) {
      throw 'Movie Not Found Failure';
    }

    return MovieDetails.fromJson(decoded);
  }

  Future<CastList> getCast(int id) async {
    final castRequest = Uri.https(
      _baseURL,
      '/3/movie/$id/credits',
      {
        'api_key': _apiKey,
        'language': 'en-US',
      },
    );
    final castResponse = await _httpClient.get(castRequest);
    if (castResponse.statusCode != 200) {
      throw 'Cast Request Failure';
    }

    final decoded = jsonDecode(castResponse.body) as Map<String, dynamic>;

    if (decoded.isEmpty) {
      throw 'Cast Not Found Failure';
    }

    return CastList.fromJson(decoded);
  }

  Stream<List<Movie>> streamMovies() =>
      movies.snapshots().map((event) => event.docs
          .map((e) => Movie.fromJson(e.data(), docId: e.reference.id))
          .toList());

  Future<void> addMovie(Movie movie) async {
    await movies
        .add(movie.toJson())
        .catchError((error) => throw "Failed to add movie");
  }

  Future<void> deleteMovie(String id) async {
    await movies
        .doc(id)
        .delete()
        .catchError((error) => throw "Failed to delete movie");
  }

  Future<void> updateMovie(String id, Movie movie) async {
    await movies
        .doc(id)
        .update(movie.toJson())
        .catchError((error) => throw "Failed to delete movie");
  }
}
