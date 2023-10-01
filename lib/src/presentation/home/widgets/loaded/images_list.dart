import 'package:flutter/material.dart';

import '../../../../domain/entities/apod_image.dart';
import 'image_card.dart';

class ImagesList extends StatelessWidget {
  final List<ApodImage> images;

  const ImagesList(
    this.images, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final image in images) ...[
          ImageCard(image: image),
          const SizedBox(
            height: 8.0,
          ),
        ],
      ],
    );
  }
}
