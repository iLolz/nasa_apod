import '../../core/utils/formatters.dart';
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
    String stringValue(String key) => (json[key] as String?)?.trim() ?? '';

    String hdUrl() {
      if (json['media_type'] == 'video') {
        return stringValue('url');
      }

      final hdUrl = stringValue('hdurl');

      if (hdUrl.isNotEmpty) {
        return hdUrl;
      }

      return stringValue('url');
    }

    String url() {
      if (json['media_type'] == 'video') {
        final thumbnailUrl = stringValue('thumbnail_url');

        if (thumbnailUrl.isNotEmpty) {
          return thumbnailUrl;
        }

        return '';
      }

      return stringValue('url');
    }

    return ApodImageModel(
      date: DateTime.parse(json['date']),
      explanation: stringValue('explanation'),
      hdImageUrl: hdUrl(),
      title: stringValue('title'),
      mediaType: stringValue('media_type'),
      imageUrl: url(),
    );
  }

  ApodImage toEntity() {
    return ApodImage(
      date: date,
      displayDate: Formatters.toDateString(date),
      description: explanation,
      previewUrl: imageUrl,
      title: title,
      mediaType: switch (mediaType) {
        'image' => ApodMediaType.image,
        'video' => ApodMediaType.video,
        _ => ApodMediaType.unknown,
      },
      contentUrl: hdImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String().split('T').first,
      'explanation': explanation,
      'hdurl': hdImageUrl,
      'title': title,
      'media_type': mediaType,
      'url': imageUrl,
    };
  }
}
