enum ApodMediaType {
  image,
  video,
  unknown,
}

class ApodImage {
  final String previewUrl;
  final String contentUrl;
  final String title;
  final String description;
  final DateTime date;
  final String displayDate;
  final ApodMediaType mediaType;

  ApodImage({
    required this.previewUrl,
    required this.title,
    required this.description,
    required this.date,
    required this.displayDate,
    required this.mediaType,
    required this.contentUrl,
  });

  bool get isVideo => mediaType == ApodMediaType.video;

  String get heroTag => '${date.toIso8601String()}|$title';

  bool get hasValidPreviewUrl {
    final uri = Uri.tryParse(previewUrl);

    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  bool get hasValidContentUrl {
    final uri = Uri.tryParse(contentUrl);

    return uri != null && uri.hasScheme && uri.hasAuthority;
  }
}
