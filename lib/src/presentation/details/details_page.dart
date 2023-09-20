import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nasa_apod/src/core/utils/formatters.dart';
import 'package:nasa_apod/src/domain/entities/image_info.dart';

class DetailsPage extends StatelessWidget {
  final ApodImage image;

  const DetailsPage({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(image.title),
      ),
      body: ListView(
        children: [
          Hero(
            tag: image.title,
            child: CachedNetworkImage(
              imageUrl: image.imageUrl,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Photo shooted on: ${Formatters.toDateString(image.date)}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            ),
            child: Text(
              image.description,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
