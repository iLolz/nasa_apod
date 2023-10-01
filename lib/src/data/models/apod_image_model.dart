import '../../domain/entities/apod_image.dart';

class ApodImageModel {
  final DateTime date;
  final String explanation;
  final String hdImageUrl;
  final String title;
  final String mediaType;
  final String imageUrl;

  const ApodImageModel({
    required this.date,
    required this.explanation,
    required this.hdImageUrl,
    required this.title,
    required this.mediaType,
    required this.imageUrl,
  });

  factory ApodImageModel.fromMap(Map<String, dynamic> json) {
    String hdUrl() {
      if (json['media_type'] == 'video') {
        return json['url'];
      }

      return json.containsKey('hdurl') ? json['hdurl'] : json['url'];
    }

    String url() {
      return json['media_type'] == 'video'
          ? json['thumbnail_url']
          : json['url'];
    }

    return ApodImageModel(
      date: DateTime.parse(json['date']),
      explanation: json['explanation'],
      hdImageUrl: hdUrl(),
      title: json['title'],
      mediaType: json['media_type'],
      imageUrl: url(),
    );
  }

  ApodImage toEntity() {
    return ApodImage(
      date: date,
      description: explanation,
      imageUrl: imageUrl,
      title: title,
      mediaType: mediaType,
      hdImageUrl: hdImageUrl,
    );
  }
}
