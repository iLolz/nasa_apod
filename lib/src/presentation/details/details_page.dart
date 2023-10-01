import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities/apod_image.dart';

class DetailsPage extends StatelessWidget {
  final ApodImage image;

  const DetailsPage({
    required this.image,
    super.key,
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
