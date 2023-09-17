import '../../domain/entities/image_info.dart';

class ImageInfoModel {
  final DateTime date;
  final String explanation;
  final String hdImageUrl;
  final String title;
  final String mediaType;
  final String imageUrl;

  const ImageInfoModel({
    required this.date,
    required this.explanation,
    required this.hdImageUrl,
    required this.title,
    required this.mediaType,
    required this.imageUrl,
  });

  factory ImageInfoModel.fromMap(Map<String, dynamic> json) {
    return ImageInfoModel(
      date: DateTime.parse(json['date']),
      explanation: json['explanation'],
      hdImageUrl: json['hdurl'],
      title: json['title'],
      mediaType: json['media_type'],
      imageUrl: json['url'],
    );
  }

  ImageInfo toEntity() {
    return ImageInfo(
      date: date,
      description: explanation,
      imageUrl: hdImageUrl,
      title: title,
    );
  }
}