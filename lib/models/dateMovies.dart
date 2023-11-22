class DateMovies {
  final String minimum;
  final String maximum;

  const DateMovies({
    required this.minimum,
    required this.maximum,
  });

  factory DateMovies.fromJson(Map<String, dynamic> json) {
    return DateMovies(
      minimum: json['minimum'],
      maximum: json['maximum']
    );
  }
}