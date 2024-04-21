import 'package:eventime/models/Video/video.dart';

class Videos {
  final int idMovie;
  final List<Video> videos;

  const Videos({
    required this.idMovie,
    required this.videos,
  });

  factory Videos.fromJson(Map<String, dynamic> json) {
    return Videos(
      idMovie: json["id"],
      videos: List<Video>.from(json["results"].map((x) => Video.fromJson(x)))
    );
  }
}