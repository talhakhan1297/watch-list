class MovieDetails {
  final int id;
  final String? title;
  final String? tagline;
  final String? image;
  final String? poster;
  final String? overview;
  final String? release;
  final List? genres;
  final List? companies;
  final num? voteAvg;
  final CastList? cast;

  const MovieDetails({
    required this.id,
    this.title,
    this.tagline,
    this.image,
    this.poster,
    this.overview,
    this.release,
    this.genres,
    this.companies,
    this.voteAvg,
    this.cast,
  });

  MovieDetails copyWith({CastList? cast}) {
    return MovieDetails(
      id: id,
      title: title,
      tagline: tagline,
      image: image,
      poster: poster,
      overview: overview,
      release: release,
      genres: genres,
      companies: companies,
      voteAvg: voteAvg,
      cast: cast ?? this.cast,
    );
  }

  factory MovieDetails.fromJson(Map<String, dynamic> map) {
    return MovieDetails(
      id: map['id'],
      title: map['title'],
      tagline: map['tagline'],
      image: map['backdrop_path'],
      poster: map['poster_path'],
      overview: map['overview'],
      release: map['release_date'],
      genres: map['genres'],
      companies: map['production_companies'],
      voteAvg: map['vote_average'],
    );
  }
}

class CastList {
  const CastList({required this.castList});

  final List<Cast>? castList;

  factory CastList.fromJson(Map<String, dynamic> json) {
    return CastList(
      castList: (json['cast'] as List?)?.map((e) => Cast.fromJson(e)).toList(),
    );
  }
}

class Cast {
  const Cast({required this.image});

  final String? image;

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(image: json['profile_path']);
  }
}
