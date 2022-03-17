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
  });

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
    );
  }
}
