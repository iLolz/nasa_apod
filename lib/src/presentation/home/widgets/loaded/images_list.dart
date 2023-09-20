import 'package:flutter/material.dart';
import 'package:nasa_apod/src/presentation/home/widgets/loaded/image_card.dart';

import '../../../../domain/entities/apod_image.dart';

class ImagesList extends StatelessWidget {
  final List<ApodImage> images;

  const ImagesList(
    this.images, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (ApodImage image in images) ...[
        ImageCard(image: image),
        const SizedBox(
          height: 8.0,
        ),
      ],
    ]);
  }
}
