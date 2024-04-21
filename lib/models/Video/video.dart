class Video {
  final String iso_639_1;
  final String iso_3166_1;
  final String name;
  final String key;
  final String published_at;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String id;

  const Video({
    required this.iso_639_1,
    required this.iso_3166_1,
    required this.name,
    required this.key,
    required this.published_at,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.id,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      iso_639_1: json['iso_639_1'],
      iso_3166_1: json['iso_3166_1'],
      name: json['name'],
      key: json['key'],
      published_at: json['published_at'],
      site: json['site'],
      size: json['size'],
      type: json['type'],
      official: json['official'],
      id: json['id'],
    );
  }
}