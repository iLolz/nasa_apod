import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nasa_apod/src/core/utils/formatters.dart';
import 'package:nasa_apod/src/presentation/details/details_page.dart';

import '../../../../domain/entities/image_info.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required this.image,
  });

  final ApodImage image;

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          image: image,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => _navigateToDetails(context),
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                image.title,
                style: textTheme.titleMedium,
              ),
              Text(
                Formatters.toDateString(image.date),
                style: textTheme.labelSmall,
              ),
              const SizedBox(
                height: 8.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Hero(
                  tag: image.title,
                  child: CachedNetworkImage(
                    imageUrl: image.imageUrl,
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                image.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
