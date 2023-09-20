import '../../domain/entities/image_info.dart';

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
    return ApodImageModel(
      date: DateTime.parse(json['date']),
      explanation: json['explanation'],
      hdImageUrl: json['hdurl'],
      title: json['title'],
      mediaType: json['media_type'],
      imageUrl: json['url'],
    );
  }

  ApodImage toEntity() {
    return ApodImage(
      date: date,
      description: explanation,
      imageUrl: imageUrl,
      title: title,
    );
  }
}
