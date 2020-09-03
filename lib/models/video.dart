import 'package:meta/meta.dart' show required;

class Video {
  final String title, description, url, image;

  Video({
    @required this.title,
    @required this.description,
    @required this.url,
    @required this.image,
  });

  static Video fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'],
      description: json['description'],
      image: json['thumb'],
      url: (json['sources'] as List)[0],
    );
  }
}
